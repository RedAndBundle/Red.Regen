namespace Red.Regenerator;
using Microsoft.Sales.Archive;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Document;
using Microsoft.Sales.History;
codeunit 70650 "Red Reg Sales Generator"
{
    TableNo = "Sales Header";
    Access = Internal;
    Permissions = tabledata "Red Reg Setup" = rimd, tabledata "Red Reg Sales Contr. Template" = rimd, tabledata "Sales Header" = rimd, tabledata "Sales Line" = rimd, tabledata "Sales Shipment Header" = r, tabledata "Sales Shipment Line" = r;

    trigger OnRun()
    begin
    end;

    procedure TestSalesSetup()
    var
        ContractTemplate: Record "Red Reg Sales Contr. Template";
        Setup: Record "Red Reg Setup";
    begin
        // ContractTemplate.SetFilter("Application Area", '%1|%2', ContractTemplate."Application Area"::Sales, ContractTemplate."Application Area"::" ");
        if ContractTemplate.IsEmpty() then
            exit;

        Setup.InitSetup();
        Setup.TestSalesSetup();
    end;

    procedure WillGenerateContractsAfterSalesPost(var SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::"Blanket Order",
            SalesHeader."Document Type"::"Credit Memo",
            SalesHeader."Document Type"::Quote,
            SalesHeader."Document Type"::"Return Order",
            SalesHeader."Document Type"::"Red Regenerator":
                exit(false);
        end;

        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Red Reg Generates Contract", true);
        exit(not SalesLine.IsEmpty());
    end;

    procedure GenerateContractsAfterSalesPost(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; CommitIsSuppressed: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        ContractSalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        ContractTemplate: Record "Red Reg Sales Contr. Template";
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::"Blanket Order",
            SalesHeader."Document Type"::"Credit Memo",
            SalesHeader."Document Type"::Quote,
            SalesHeader."Document Type"::"Return Order":
                exit;
        end;

        if SalesHeader."Red Reg Contract No." <> '' then
            exit;

        if not SalesShipmentHeader.Get(SalesShptHdrNo) then
            exit;

        SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
        SalesShipmentLine.SetFilter(Type, '%1|%2|%3', SalesShipmentLine.Type::Item, SalesShipmentLine.Type::Resource, SalesShipmentLine.Type::"G/L Account");
        if SalesShipmentLine.FindSet() then
            repeat
                if GetContractTemplate(ContractTemplate, SalesShipmentLine.Type, SalesShipmentLine."No.") then begin
                    ContractSalesHeader := GetContractHeader(SalesHeader, SalesShipmentHeader."Posting Date", ContractTemplate);
                    InsertContractLine(ContractSalesHeader, SalesShipmentLine);
                end;
            until SalesShipmentLine.Next() = 0;
    end;

    procedure GenerateContracts(var SalesHeader: Record "Sales Header")
    var
        ContractSalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ContractTemplate: Record "Red Reg Sales Contr. Template";
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::"Blanket Order",
            SalesHeader."Document Type"::"Credit Memo",
            SalesHeader."Document Type"::Quote,
            SalesHeader."Document Type"::"Return Order":
                exit;
        end;

        if SalesHeader."Red Reg Contract No." <> '' then
            exit;
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetFilter(Type, '%1|%2|%3', SalesLine.Type::Item, SalesLine.Type::Resource, SalesLine.Type::"G/L Account");
        if SalesLine.FindSet() then
            repeat
                if GetContractTemplate(ContractTemplate, SalesLine.Type, SalesLine."No.") then begin
                    ContractSalesHeader := GetContractHeader(SalesHeader, SalesHeader."Document Date", ContractTemplate);
                    InsertContractLine(ContractSalesHeader, SalesLine);
                end;
            until SalesLine.Next() = 0;
    end;

    local procedure GetContractTemplate(var ContractTemplate: Record "Red Reg Sales Contr. Template"; Type: Enum "Sales Line Type"; No: Code[20]): Boolean
    begin
        exit(ContractTemplate.Get(Type, No));
    end;

    local procedure GetContractHeader(SalesHeader: Record "Sales Header"; StartDate: Date; ContractTemplate: Record "Red Reg Sales Contr. Template") ContractSalesHeader: Record "Sales Header"
    var
        EmptyDateFormula: DateFormula;
    begin
        ContractSalesHeader.SetCurrentKey("Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration");
        ContractSalesHeader.SetRange("Red Reg Org. Document Type", SalesHeader."Document Type");
        ContractSalesHeader.SetRange("Red Reg Org. Document No.", SalesHeader."No.");
        ContractSalesHeader.SetRange("Red Reg Group", ContractTemplate."Contract Group");
        ContractSalesHeader.SetRange("Red Reg Duration", ContractTemplate."Duration");
        if ContractSalesHeader.FindFirst() then
            exit(ContractSalesHeader);

        ContractSalesHeader.Init();
        ContractSalesHeader."Document Type" := SalesHeader."Document Type"::"Red ReGenerator";
        ContractSalesHeader.TransferFields(SalesHeader, false);
        ContractSalesHeader.Status := ContractSalesHeader.Status::Open;
        ContractSalesHeader."Red Reg Contract Status" := ContractSalesHeader."Red Reg Contract Status"::Concept;

        ContractSalesHeader."Red Reg Org. Document Type" := SalesHeader."Document Type";
        ContractSalesHeader."Red Reg Org. Document No." := SalesHeader."No.";
        ContractSalesHeader."Red Reg Group" := ContractTemplate."Contract Group";
        ContractSalesHeader."Red Reg Start Date" := StartDate;
        ContractSalesHeader."Red Reg Next Billing Date" := ContractSalesHeader."Red Reg Start Date";
        if ContractTemplate."Duration" <> EmptyDateFormula then begin
            ContractSalesHeader.Validate("Red Reg Duration", ContractTemplate."Duration");
            if ContractTemplate."Red Reg Billing Period" <> EmptyDateFormula then
                ContractSalesHeader.Validate("Red Reg Billing Period", ContractTemplate."Red Reg Billing Period");
            ContractSalesHeader.RedRegCalculateNextBillingDate();
        end;
        ContractSalesHeader."Red Reg Contract Status" := ContractSalesHeader."Red Reg Contract Status"::Active;
        ContractSalesHeader.Insert(true);
    end;

    local procedure InsertContractLine(var ContractSalesHeader: Record "Sales Header"; SalesShipmentLine: Record "Sales Shipment Line")
    var
        ContractSalesLine: Record "Sales Line";
    begin
        if SalesShipmentLine.Quantity = 0 then
            exit;

        ContractSalesLine.SetRange("Document Type", ContractSalesHeader."Document Type");
        ContractSalesLine.SetRange("Document No.", ContractSalesHeader."No.");
        ContractSalesLine.SetRange("Unit Price", SalesShipmentLine."Unit Price");
        ContractSalesLine.SetRange("Red Reg Org. Document Type", ContractSalesHeader."Red Reg Org. Document Type");
        ContractSalesLine.SetRange("Red Reg Org. Document No.", ContractSalesHeader."Red Reg Org. Document No.");
        ContractSalesLine.SetRange("Red Reg Org. Document Line No.", SalesShipmentLine."Line No.");
        ContractSalesLine.SetRange("Red Reg Org. Shipment No.", SalesShipmentLine."Document No.");
        ContractSalesLine.SetRange("Red Reg Org. Shipment Line No.", SalesShipmentLine."Line No.");
        if ContractSalesLine.FindFirst() then begin
            ContractSalesLine.Validate("Quantity", ContractSalesLine.Quantity + SalesShipmentLine.Quantity);
            ContractSalesLine.Modify(true);
            exit;
        end;

        ContractSalesLine.RedRegInitNewLine(ContractSalesHeader);
        ContractSalesLine.TransferFields(SalesShipmentLine, false);
        ContractSalesLine.Validate(Quantity, SalesShipmentLine.Quantity);
        ContractSalesLine.Validate("Unit Price", SalesShipmentLine."Unit Price");
        ContractSalesLine."Red Reg Org. Document Type" := ContractSalesHeader."Red Reg Org. Document Type";
        ContractSalesLine."Red Reg Org. Document No." := ContractSalesHeader."Red Reg Org. Document No.";
        ContractSalesLine."Red Reg Org. Document Line No." := SalesShipmentLine."Line No.";
        ContractSalesLine."Red Reg Org. Shipment No." := SalesShipmentLine."Document No.";
        ContractSalesLine."Red Reg Org. Shipment Line No." := SalesShipmentLine."Line No.";
        ContractSalesLine.Insert(true);
    end;

    local procedure InsertContractLine(var ContractSalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    var
        ContractSalesLine: Record "Sales Line";
    begin
        ContractSalesLine.SetRange("Document Type", ContractSalesHeader."Document Type");
        ContractSalesLine.SetRange("Document No.", ContractSalesHeader."No.");
        ContractSalesLine.SetRange("Red Reg Org. Document Type", ContractSalesHeader."Red Reg Org. Document Type");
        ContractSalesLine.SetRange("Red Reg Org. Document No.", ContractSalesHeader."Red Reg Org. Document No.");
        ContractSalesLine.SetRange("Red Reg Org. Document Line No.", SalesLine."Line No.");
        if ContractSalesLine.FindFirst() then begin
            ContractSalesLine.Validate("Quantity", SalesLine.Quantity);
            ContractSalesLine.Modify(true);
            exit;
        end;

        ContractSalesLine.RedRegInitNewLine(ContractSalesHeader);
        ContractSalesLine.TransferFields(SalesLine, false);
        ContractSalesLine."Red Reg Org. Document Type" := ContractSalesHeader."Red Reg Org. Document Type";
        ContractSalesLine."Red Reg Org. Document No." := ContractSalesHeader."Red Reg Org. Document No.";
        ContractSalesLine."Red Reg Org. Document Line No." := SalesLine."Line No.";
        ContractSalesLine.Insert(true);
    end;
}