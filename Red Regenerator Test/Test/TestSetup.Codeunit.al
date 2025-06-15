namespace Red.Regenerator.Test;
using Microsoft.Sales.Document;
using Microsoft.Foundation.NoSeries;
using Red.Regenerator;
using Microsoft.Sales.Posting;
using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
codeunit 70800 "Test Setup"
{
    Access = Internal;

    procedure EnsureSetup()
    var
        Setup: Record "Red Reg Setup";
    begin
        Setup.InitSetup();
        Setup."No. Series Sales" := EnsureNumberSeries('REDREGENSLS');
        Setup."No. Series Purchase" := EnsureNumberSeries('REDREGENPUR');
        Setup.Modify();
    end;

    local procedure EnsureNumberSeries(Code: Code[20]): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Init();
        NoSeries.Code := Code;
        NoSeries."Default Nos." := true;
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine."Starting No." := 'RED0001';
        NoSeriesLine.Insert(true);
        exit(NoSeries.Code);
    end;

    procedure EnsureNonInventoryItem(var ItemNo: Code[20]; var UnitPrice: Decimal);
    var
        Item: Record Item;
    begin
        Item.Init();
        Item.Type := Item.Type::"Non-Inventory";
        Item."Unit Price" := 100;
        Item."Gen. Prod. Posting Group" := 'RETAIL';
        Item."VAT Prod. Posting Group" := 'VAT25';
        Item.Insert(true);
        Item.Validate("Base Unit of Measure", 'PCS');
        Item.Modify(true);
        ItemNo := Item."No.";
        UnitPrice := Item."Unit Price";
    end;

    procedure EnsureSalesContractTemplate(ItemNo: Code[20]): Record "Red Reg Sales Contr. Template"
    var
        SalesTemplate: Record "Red Reg Sales Contr. Template";
    begin
        SalesTemplate.Init();
        SalesTemplate.Type := SalesTemplate.Type::Item;
        SalesTemplate."No." := ItemNo;
        SalesTemplate."Description" := 'Test Sales Contract Template';
        // SalesTemplate."Application Area" := SalesTemplate."Application Area"::
        SalesTemplate."Contract Group" := EnsureContractGroup();
        Evaluate(SalesTemplate.Duration, '<1Y>');
        Evaluate(SalesTemplate."Red Reg Billing Period", '<1Y>');
        SalesTemplate.Insert(true);
        exit(SalesTemplate);
    end;

    local procedure EnsureContractGroup(): Code[20]
    var
        ContractGroup: Record "Red Reg Contract Group";
    begin
        ContractGroup.DeleteAll();
        ContractGroup.Init();
        ContractGroup.Code := 'TESTGROUP';
        ContractGroup."Description" := 'Test Contract Group';
        ContractGroup."Regenerate Document Type" := ContractGroup."Regenerate Document Type"::Invoice;
        ContractGroup.Insert();
        exit(ContractGroup.Code);
    end;

    procedure EnsureSourceRecord(var SalesHeader: Record "Sales Header"; Customer: Record Customer; ItemNo: Code[20])
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Validate("Sell-to Customer No.", Customer."No.");
        SalesHeader."Location Code" := '';
        SalesHeader.Insert(true);
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := 10000;
        SalesLine.Type := SalesLine.Type::Item;
        SalesLine.Validate("No.", Item."No.");
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Location Code", SalesHeader."Location Code");
        SalesLine.Validate("Unit Price", Item."Unit Price");
        SalesLine.Validate("Line Discount %", 0);
        SalesLine.Insert();
    end;

    procedure EnsureSalesContract(var ContractHeader: Record "Sales Header"; Customer: Record Customer; ItemNo: Code[20])
    var
        ContractLine: Record "Sales Line";
        Item: Record Item;
    begin
        Item.Get(ItemNo);
        ContractHeader.Init();
        ContractHeader."Document Type" := ContractHeader."Document Type"::"Red Regenerator";
        ContractHeader.Validate("Sell-to Customer No.", Customer."No.");
        ContractHeader."Location Code" := '';
        ContractHeader."Red Reg Start Date" := WorkDate();
        Evaluate(ContractHeader."Red Reg Duration", '<1Y>');
        ContractHeader.Validate("Red Reg Duration");
        Evaluate(ContractHeader."Red Reg Billing Period", '<1Y>');
        ContractHeader.Validate("Red Reg Billing Period");
        ContractHeader."Red Reg Group" := EnsureContractGroup();
        ContractHeader.Insert(true);
        ContractLine.Init();
        ContractLine."Document Type" := ContractHeader."Document Type";
        ContractLine."Document No." := ContractHeader."No.";
        ContractLine."Line No." := 10000;
        ContractLine.Type := ContractLine.Type::Item;
        ContractLine.Validate("No.", Item."No.");
        ContractLine.Validate(Quantity, 1);
        ContractLine.Validate("Location Code", ContractHeader."Location Code");
        ContractLine.Validate("Unit Price", Item."Unit Price");
        ContractLine.Validate("Line Discount %", 0);
        ContractLine.Insert();
    end;

    procedure EnsureSourceRecordPosted(SalesHeader: Record "Sales Header") Result: Record "Sales Invoice Header"
    var
        SalesLine: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
    begin
        SalesHeader.Ship := true;
        SalesHeader."Invoice" := true;
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        if SalesLine.FindSet() then
            repeat
                SalesLine.Validate("Location Code", '');
                SalesLine.Modify(true);
            until SalesLine.Next() = 0;

        SalesPost.SetSuppressCommit(true);
        SalesPost.Run(SalesHeader);
        Result.SetRange("No.", SalesHeader."Last Posting No.");
        Result.FindFirst();
    end;

    procedure EnsureCustomer(var Customer: Record Customer)
    begin
        Customer.SetRange(Blocked, Customer.Blocked::" ");
        // Customer.SetRange("Gen. Bus. Posting Group", 'DOMESTIC');
        Customer.FindFirst();
    end;
}