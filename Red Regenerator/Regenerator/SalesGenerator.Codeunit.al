codeunit 11311113 "Red Reg Sales Generator"
{
    TableNo = "Sales Header";
    Access = Internal;
    Permissions = tabledata "Red Reg Setup" = rimd, tabledata "Red Reg Generator" = rimd, tabledata "Sales Header" = rimd, tabledata "Sales Line" = rimd, tabledata "Sales Shipment Header" = r, tabledata "Sales Shipment Line" = r;

    trigger OnRun()
    begin
        // TODO needs something to mark the contract/lines as generated for the amount. Multiple contracts?
    end;

    procedure TestSalesSetup()
    var
        Generator: Record "Red Reg Generator";
        Setup: Record "Red Reg Setup";
    begin
        Generator.SetRange("Application Area", Generator."Application Area"::Sales);
        if Generator.IsEmpty() then
            exit;

        Setup.InitSetup();
        Setup.TestSalesSetup();
    end;

    procedure GenerateContractsAfterSalesPost(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; CommitIsSuppressed: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        ContractSalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        Generator: Record "Red Reg Generator";
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
        if SalesShipmentLine.FindSet() then
            repeat
                if GetGenerator(Generator, SalesShipmentLine, SalesHeader."Document Type") then begin
                    ContractSalesHeader := GetContractHeader(SalesHeader, SalesShipmentHeader, Generator);
                    InsertContractLine(ContractSalesHeader, SalesShipmentLine);
                end;
            until SalesShipmentLine.Next() = 0;
    end;

    local procedure GetGenerator(var Generator: Record "Red Reg Generator"; SalesShipmentLine: Record "Sales Shipment Line"; DocumentType: Enum "Sales Document Type"): Boolean
    begin
        if Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Any, SalesShipmentLine.Type, SalesShipmentLine."No.") then
            exit(true);
        if Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Any, Generator.Type::"Item Category", SalesShipmentLine."Item Category Code") then
            exit(true);

        case DocumentType of
            DocumentType::Order:
                if Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Order, SalesShipmentLine.Type, SalesShipmentLine."No.") then
                    exit(true)
                else
                    exit(Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Order, Generator.Type::"Item Category", SalesShipmentLine."Item Category Code"));
            DocumentType::Invoice:
                if Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Invoice, SalesShipmentLine.Type, SalesShipmentLine."No.") then
                    exit(true)
                else
                    exit(Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Invoice, Generator.Type::"Item Category", SalesShipmentLine."Item Category Code"));
        end;
    end;

    local procedure GetContractHeader(SalesHeader: Record "Sales Header"; SalesShipmentHeader: Record "Sales Shipment Header"; Generator: Record "Red Reg Generator") ContractSalesHeader: Record "Sales Header"
    var
        EmptyDateFormula: DateFormula;
    begin
        ContractSalesHeader.SetCurrentKey("Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration");
        ContractSalesHeader.SetRange("Red Reg Org. Document Type", SalesHeader."Document Type");
        ContractSalesHeader.SetRange("Red Reg Org. Document No.", SalesHeader."No.");
        ContractSalesHeader.SetRange("Red Reg Org. Shipment No.", SalesShipmentHeader."No.");
        ContractSalesHeader.SetRange("Red Reg Group", Generator."Contract Group");
        ContractSalesHeader.SetRange("Red Reg Duration", Generator."Duration");
        if ContractSalesHeader.FindFirst() then
            exit(ContractSalesHeader);

        ContractSalesHeader.Init();
        ContractSalesHeader."Document Type" := SalesHeader."Document Type"::"Red Regenerator";
        ContractSalesHeader.TransferFields(SalesHeader, false);
        ContractSalesHeader.Status := ContractSalesHeader.Status::Open;
        ContractSalesHeader."Red Reg Contract Status" := ContractSalesHeader."Red Reg Contract Status"::Concept;

        ContractSalesHeader."Red Reg Org. Document Type" := SalesHeader."Document Type";
        ContractSalesHeader."Red Reg Org. Document No." := SalesHeader."No.";
        ContractSalesHeader."Red Reg Org. Shipment No." := SalesShipmentHeader."No.";
        ContractSalesHeader."Red Reg Group" := Generator."Contract Group";
        ContractSalesHeader."Red Reg Start Date" := SalesShipmentHeader."Posting Date";
        ContractSalesHeader."Red Reg Next Billing Date" := ContractSalesHeader."Red Reg Start Date";
        if Generator."Duration" <> EmptyDateFormula then begin
            ContractSalesHeader.Validate("Red Reg Duration", Generator."Duration");
            if Generator."Red Reg Billing Period" <> EmptyDateFormula then
                ContractSalesHeader.Validate("Red Reg Billing Period", Generator."Red Reg Billing Period");
            ContractSalesHeader.RedRegCalculateNextBillingDate();
        end;
        ContractSalesHeader."Red Reg Contract Status" := ContractSalesHeader."Red Reg Contract Status"::Active;
        ContractSalesHeader.Insert(true);
    end;

    local procedure InsertContractLine(var SalesHeader: Record "Sales Header"; SalesShipmentLine: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Red Reg Org. Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Red Reg Org. Document No.", SalesHeader."No.");
        SalesLine.SetRange("Red Reg Org. Document Line No.", SalesShipmentLine."Line No.");
        SalesLine.SetRange("Red Reg Org. Shipment No.", SalesShipmentLine."Document No.");
        SalesLine.SetRange("Red Reg Org. Shipment Line No.", SalesShipmentLine."Line No.");
        if SalesLine.FindFirst() then begin
            SalesLine.Validate("Quantity", SalesShipmentLine.Quantity);
            SalesLine.Modify(true);
            exit;
        end;

        SalesLine.RedRegInitNewLine(SalesHeader);
        SalesLine.TransferFields(SalesShipmentLine, false);
        SalesLine."Red Reg Org. Document Type" := SalesHeader."Document Type";
        SalesLine."Red Reg Org. Document No." := SalesHeader."No.";
        SalesLine."Red Reg Org. Document Line No." := SalesShipmentLine."Line No.";
        SalesLine."Red Reg Org. Shipment No." := SalesShipmentLine."Document No.";
        SalesLine."Red Reg Org. Shipment Line No." := SalesShipmentLine."Line No.";
        SalesLine.Insert(true);
    end;
}