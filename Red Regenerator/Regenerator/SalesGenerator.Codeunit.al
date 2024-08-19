codeunit 11311113 "Red Reg Sales Generator"
{
    TableNo = "Sales Header";
    Access = Internal;
    Permissions = tabledata "Red Reg Setup" = rimd, tabledata "Red Reg Generator" = rimd, tabledata "Sales Header" = rimd, tabledata "Sales Line" = rimd, tabledata "Sales Shipment Header" = r, tabledata "Sales Shipment Line" = r;

    trigger OnRun()
    begin
        GenerateContracts(Rec, Enum::"Red Reg Generation Moments"::Manual);
        // TODO keep contract in sync on modify sales header + line
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

    procedure WillGenerateContractsAfterSalesPost(var SalesHeader: Record "Sales Header"): Boolean
    var
        SalesLine: Record "Sales Line";
        Generator: Record "Red Reg Generator";
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::"Blanket Order",
            SalesHeader."Document Type"::"Credit Memo",
            SalesHeader."Document Type"::Quote,
            SalesHeader."Document Type"::"Return Order":
                exit(false);
        end;

        if SalesHeader."Red Reg Contract No." <> '' then
            exit(false);

        Generator.SetRange("Application Area", Generator."Application Area"::Sales);
        Generator.SetRange("Generation Moment", Generator."Generation Moment"::OnPost);
        if Generator.IsEmpty() then
            exit(false);

        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        if SalesLine.FindSet() then
            repeat
                if HasGenerator(SalesLine.Type, SalesLine."No.", SalesLine."Item Category Code", SalesHeader."Document Type", Generator."Generation Moment"::OnPost) then
                    exit(true);
            until SalesLine.Next() = 0;
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
                if GetGenerator(Generator, SalesShipmentLine.Type, SalesShipmentLine."No.", SalesShipmentLine."Item Category Code", SalesHeader."Document Type") then
                    if Generator."Generation Moment" = Generator."Generation Moment"::OnPost then begin
                        ContractSalesHeader := GetContractHeader(SalesHeader, SalesShipmentHeader."Posting Date", Generator);
                        InsertContractLine(ContractSalesHeader, SalesShipmentLine);
                    end;
            until SalesShipmentLine.Next() = 0;
    end;

    procedure GenerateContracts(var SalesHeader: Record "Sales Header"; GenerationMoment: Enum "Red Reg Generation Moments")
    var
        ContractSalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
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
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        if SalesLine.FindSet() then
            repeat
                if GetGenerator(Generator, SalesLine.Type, SalesLine."No.", SalesLine."Item Category Code", SalesLine."Document Type") then
                    if Generator."Generation Moment" = GenerationMoment then begin
                        ContractSalesHeader := GetContractHeader(SalesHeader, SalesHeader."Document Date", Generator);
                        InsertContractLine(ContractSalesHeader, SalesLine);
                    end;
            until SalesLine.Next() = 0;
    end;

    local procedure HasGenerator(Type: Enum "Sales Line Type"; No: Code[20]; ItemCategoryCode: Code[20]; DocumentType: Enum "Sales Document Type"; GenerationMoment: Enum "Red Reg Generation Moments"): Boolean
    var
        Generator: Record "Red Reg Generator";
    begin
        case DocumentType of
            DocumentType::Order:
                Generator.SetFilter("Document Type", '%1|%2', Generator."Document Type"::Any, Enum::"Red Reg Document Type"::Order);
            DocumentType::Invoice:
                Generator.SetFilter("Document Type", '%1|%2', Generator."Document Type"::Any, Enum::"Red Reg Document Type"::Invoice);
        end;

        Generator.SetRange("Application Area", Generator."Application Area"::Sales);
        Generator.SetRange("Generation Moment", GenerationMoment);
        Generator.SetRange(Type, Generator.ConvertType(Type));
        Generator.SetRange("No.", No);
        if not Generator.IsEmpty() then
            exit(true);

        if (Type = Type::Item) and (ItemCategoryCode <> '') then begin
            Generator.SetRange("No.", ItemCategoryCode);
            exit(not Generator.IsEmpty);
        end;
    end;

    local procedure GetGenerator(var Generator: Record "Red Reg Generator"; Type: Enum "Sales Line Type"; No: Code[20]; ItemCategoryCode: Code[20]; DocumentType: Enum "Sales Document Type"): Boolean
    begin
        if GetGenerator(Generator, Type, No, ItemCategoryCode, Enum::"Red Reg Document Type"::Any) then
            exit(true);

        case DocumentType of
            DocumentType::Order:
                exit(GetGenerator(Generator, Type, No, ItemCategoryCode, Enum::"Red Reg Document Type"::Order));
            DocumentType::Invoice:
                exit(GetGenerator(Generator, Type, No, ItemCategoryCode, Enum::"Red Reg Document Type"::Invoice));
        end;
    end;

    local procedure GetGenerator(var Generator: Record "Red Reg Generator"; Type: Enum "Sales Line Type"; No: Code[20]; ItemCategoryCode: Code[20]; RegDocumentType: Enum "Red Reg Document Type"): Boolean
    begin
        if Generator.Get(Generator."Application Area"::Sales, RegDocumentType, Generator.ConvertType(Type), No) then
            exit(true);

        if (Type = Type::Item) and (ItemCategoryCode <> '') then
            if Generator.Get(Generator."Application Area"::Sales, RegDocumentType, Generator.Type::"Item Category", ItemCategoryCode) then
                exit(true);
    end;

    local procedure GetContractHeader(SalesHeader: Record "Sales Header"; StartDate: Date; Generator: Record "Red Reg Generator") ContractSalesHeader: Record "Sales Header"
    var
        EmptyDateFormula: DateFormula;
    begin
        ContractSalesHeader.SetCurrentKey("Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration");
        ContractSalesHeader.SetRange("Red Reg Org. Document Type", SalesHeader."Document Type");
        ContractSalesHeader.SetRange("Red Reg Org. Document No.", SalesHeader."No.");
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
        ContractSalesHeader."Red Reg Group" := Generator."Contract Group";
        ContractSalesHeader."Red Reg Start Date" := StartDate;
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

    local procedure InsertContractLine(var ContractSalesHeader: Record "Sales Header"; SalesShipmentLine: Record "Sales Shipment Line")
    var
        ContractSalesLine: Record "Sales Line";
    begin
        ContractSalesLine.SetRange("Document Type", ContractSalesHeader."Document Type");
        ContractSalesLine.SetRange("Document No.", ContractSalesHeader."No.");
        ContractSalesLine.SetRange("Red Reg Org. Document Type", ContractSalesHeader."Red Reg Org. Document Type");
        ContractSalesLine.SetRange("Red Reg Org. Document No.", ContractSalesHeader."Red Reg Org. Document No.");
        ContractSalesLine.SetRange("Red Reg Org. Document Line No.", SalesShipmentLine."Line No.");
        ContractSalesLine.SetRange("Red Reg Org. Shipment No.", SalesShipmentLine."Document No.");
        ContractSalesLine.SetRange("Red Reg Org. Shipment Line No.", SalesShipmentLine."Line No.");
        if ContractSalesLine.FindFirst() then begin
            ContractSalesLine.Validate("Quantity", SalesShipmentLine.Quantity);
            ContractSalesLine.Modify(true);
            exit;
        end;

        ContractSalesLine.RedRegInitNewLine(ContractSalesHeader);
        ContractSalesLine.TransferFields(SalesShipmentLine, false);
        ContractSalesLine.Validate(Quantity, SalesShipmentLine.Quantity);
        ContractSalesLine."Red Reg Org. Document Type" := ContractSalesHeader."Red Reg Org. Document Type";
        ContractSalesLine."Red Reg Org. Document No." := ContractSalesHeader."No.";
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