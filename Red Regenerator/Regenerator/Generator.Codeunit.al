codeunit 11311113 "Red Reg Generator"
{
    TableNo = "Red Reg Generator";
    Access = Internal;

    trigger OnRun()
    begin

    end;

    procedure GenerateContractsAfterSalesPost(var SalesHeader: Record "Sales Header"; SalesShptHdrNo: Code[20]; SalesInvHdrNo: Code[20]; CommitIsSuppressed: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; PreviewMode: Boolean)
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        Generator: Record "Red Reg Generator";
    begin
        if PreviewMode then
            exit;

        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::"Blanket Order",
            SalesHeader."Document Type"::"Credit Memo",
            SalesHeader."Document Type"::Quote,
            SalesHeader."Document Type"::"Return Order":
                exit;
        end;

        if not SalesShipmentHeader.Get(SalesShptHdrNo) then
            exit;

        SalesShipmentLine.SetRange("Document No.", SalesShipmentHeader."No.");
        if SalesShipmentLine.FindSet() then
            repeat
                if GetGenerator(Generator, SalesShipmentLine, SalesHeader."Document Type") then
                    CreateSalesContract(Generator, SalesShipmentLine, SalesHeader);
            until SalesShipmentLine.Next() = 0;
    end;

    local procedure CreateSalesContract(Generator: Record "Red Reg Generator"; SalesShipmentLine: Record "Sales Shipment Line"; SalesHeader: Record "Sales Header")
    var
    // myInt: Integer;
    begin
        // GetContractHeader(Customer, ContractGroup, StartDate, EndDate, DocumentType, DocumentNo, ShipmentNo);
        // InsertContractLine();
    end;

    local procedure GetGenerator(var Generator: Record "Red Reg Generator"; SalesShipmentLine: Record "Sales Shipment Line"; DocumentType: Enum "Sales Document Type"): Boolean
    begin
        if Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Any, SalesShipmentLine.Type, SalesShipmentLine."No.") then
            exit(true);

        case DocumentType of
            DocumentType::Order:
                exit(Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Order, SalesShipmentLine.Type, SalesShipmentLine."No."));
            DocumentType::Invoice:
                exit(Generator.Get(Generator."Application Area"::Sales, Generator."Document Type"::Invoice, SalesShipmentLine.Type, SalesShipmentLine."No."));
        end;
    end;
}