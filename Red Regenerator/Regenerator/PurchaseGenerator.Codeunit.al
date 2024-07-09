codeunit 11311117 "Red Reg Purchase Generator"
{
    TableNo = "Purchase Header";
    Access = Internal;
    Permissions = tabledata "Red Reg Setup" = rimd, tabledata "Red Reg Generator" = rimd, tabledata "Purchase Header" = rimd, tabledata "Purchase Line" = rimd, tabledata "Purch. Rcpt. Header" = r, tabledata "Purch. Rcpt. Line" = r;

    trigger OnRun()
    begin
        GenerateContracts(Rec, Enum::"Red Reg Generation Moments"::Manual);
    end;

    procedure TestPurchaseSetup()
    var
        Generator: Record "Red Reg Generator";
        Setup: Record "Red Reg Setup";
    begin
        Generator.SetRange("Application Area", Generator."Application Area"::Purchase);
        if Generator.IsEmpty() then
            exit;

        Setup.InitSetup();
        Setup.TestPurchaseSetup();
    end;

    procedure GenerateContractsAfterPurchasePost(var PurchaseHeader: Record "Purchase Header"; PurchaseShptHdrNo: Code[20]; PurchaseInvHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        ContractPurchaseHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        Generator: Record "Red Reg Generator";
    begin
        GenerateContracts(PurchaseHeader, Enum::"Red Reg Generation Moments"::Manual);

        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::"Blanket Order",
            PurchaseHeader."Document Type"::"Credit Memo",
            PurchaseHeader."Document Type"::Quote,
            PurchaseHeader."Document Type"::"Return Order":
                exit;
        end;

        if PurchaseHeader."Red Reg Contract No." <> '' then
            exit;

        if not PurchRcptHeader.Get(PurchaseShptHdrNo) then
            exit;

        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        if PurchRcptLine.FindSet() then
            repeat
                if GetGenerator(Generator, PurchRcptLine.Type, PurchRcptLine."No.", PurchRcptLine."Item Category Code", PurchaseHeader."Document Type") then
                    if Generator."Generation Moment" = Generator."Generation Moment"::OnPost then begin
                        ContractPurchaseHeader := GetContractHeader(PurchaseHeader, PurchRcptHeader."Posting Date", Generator);
                        InsertContractLine(ContractPurchaseHeader, PurchRcptLine);
                    end;
            until PurchRcptLine.Next() = 0;
    end;

    procedure GenerateContracts(var PurchaseHeader: Record "Purchase Header"; GenerationMoment: Enum "Red Reg Generation Moments")
    var
        ContractPurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Generator: Record "Red Reg Generator";
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::"Blanket Order",
            PurchaseHeader."Document Type"::"Credit Memo",
            PurchaseHeader."Document Type"::Quote,
            PurchaseHeader."Document Type"::"Return Order":
                exit;
        end;

        if PurchaseHeader."Red Reg Contract No." <> '' then
            exit;

        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        if PurchaseLine.FindSet() then
            repeat
                if GetGenerator(Generator, PurchaseLine.Type, PurchaseLine."No.", PurchaseLine."Item Category Code", PurchaseHeader."Document Type") then begin
                    ContractPurchaseHeader := GetContractHeader(PurchaseHeader, PurchaseHeader."Document Date", Generator);
                    InsertContractLine(ContractPurchaseHeader, PurchaseLine);
                end;
            until PurchaseLine.Next() = 0;
    end;

    procedure CreatePurchaseContractFromSalesLine(SalesLine: Record "Sales Line")
    var
        ContractPurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        ContractGroup: Record "Red Reg Contract Group";
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::"Red Regenerator" then
            exit;

        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        if not ContractGroup.Get(SalesHeader."Red Reg Group") then
            exit;

        if ContractGroup."Purchase Type" <> ContractGroup."Purchase Type"::"Purchase Contract" then
            exit;

        ContractPurchaseHeader := GetContractHeader(SalesHeader, SalesLine);
        InsertContractLine(ContractPurchaseHeader, SalesLine);
    end;

    local procedure GetGenerator(var Generator: Record "Red Reg Generator"; Type: Enum "Purchase Line Type"; No: Code[20]; ItemCategoryCode: Code[20]; DocumentType: Enum "Purchase Document Type"): Boolean
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

    local procedure GetGenerator(var Generator: Record "Red Reg Generator"; Type: Enum "Purchase Line Type"; No: Code[20]; ItemCategoryCode: Code[20]; RegDocumentType: Enum "Red Reg Document Type"): Boolean
    begin
        if Generator.Get(Generator."Application Area"::Purchase, RegDocumentType, Type, No) then
            exit(true);

        if (Type = Type::Item) and (ItemCategoryCode <> '') then
            if Generator.Get(Generator."Application Area"::Purchase, RegDocumentType, Generator.Type::"Item Category", ItemCategoryCode) then
                exit(true);
    end;

    local procedure GetContractHeader(PurchaseHeader: Record "Purchase Header"; StartDate: Date; Generator: Record "Red Reg Generator") ContractPurchaseHeader: Record "Purchase Header"
    var
        EmptyDateFormula: DateFormula;
    begin
        ContractPurchaseHeader.SetCurrentKey("Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration");
        ContractPurchaseHeader.SetRange("Red Reg Org. Document Type", PurchaseHeader."Document Type");
        ContractPurchaseHeader.SetRange("Red Reg Org. Document No.", PurchaseHeader."No.");
        ContractPurchaseHeader.SetRange("Red Reg Group", Generator."Contract Group");
        ContractPurchaseHeader.SetRange("Red Reg Duration", Generator."Duration");
        if ContractPurchaseHeader.FindFirst() then
            exit(ContractPurchaseHeader);

        ContractPurchaseHeader.Init();
        ContractPurchaseHeader."Document Type" := ContractPurchaseHeader."Document Type"::"Red Regenerator";
        ContractPurchaseHeader.TransferFields(PurchaseHeader, false);
        ContractPurchaseHeader.Status := ContractPurchaseHeader.Status::Open;
        ContractPurchaseHeader."Red Reg Contract Status" := ContractPurchaseHeader."Red Reg Contract Status"::Concept;

        ContractPurchaseHeader."Red Reg Org. Document Type" := PurchaseHeader."Document Type";
        ContractPurchaseHeader."Red Reg Org. Document No." := PurchaseHeader."No.";
        ContractPurchaseHeader."Red Reg Group" := Generator."Contract Group";
        ContractPurchaseHeader."Red Reg Start Date" := StartDate;
        ContractPurchaseHeader."Red Reg Next Billing Date" := ContractPurchaseHeader."Red Reg Start Date";
        if Generator."Duration" <> EmptyDateFormula then begin
            ContractPurchaseHeader.Validate("Red Reg Duration", Generator."Duration");
            if Generator."Red Reg Billing Period" <> EmptyDateFormula then
                ContractPurchaseHeader.Validate("Red Reg Billing Period", Generator."Red Reg Billing Period");
            ContractPurchaseHeader.RedRegCalculateNextBillingDate();
        end;
        ContractPurchaseHeader."Red Reg Contract Status" := ContractPurchaseHeader."Red Reg Contract Status"::Active;
        ContractPurchaseHeader.Insert(true);
    end;

    local procedure GetContractHeader(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line") ContractPurchaseHeader: Record "Purchase Header"
    var
        Item: Record Item;
        Vendor: Record Vendor;
    begin
        SalesLine.TestField(Type, SalesLine.Type::Item);
        Item.Get(SalesLine."No.");
        Item.TestField("Vendor No.");
        Vendor.Get(Item."Vendor No.");


        ContractPurchaseHeader.SetCurrentKey("Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration");
        ContractPurchaseHeader.SetRange("Red Reg Contract No.", SalesHeader."No.");
        ContractPurchaseHeader.SetRange("Document Type", ContractPurchaseHeader."Document Type"::"Red Regenerator");
        ContractPurchaseHeader.SetRange("Red Reg Contract Status", ContractPurchaseHeader."Red Reg Contract Status"::Concept);
        ContractPurchaseHeader.SetRange("Buy-from Vendor No.", Vendor."No.");

        if ContractPurchaseHeader.FindFirst() then
            exit(ContractPurchaseHeader);

        ContractPurchaseHeader.Init();
        ContractPurchaseHeader."Document Type" := ContractPurchaseHeader."Document Type"::"Red Regenerator";
        ContractPurchaseHeader.Validate("Buy-from Vendor No.", Vendor."No.");
        ContractPurchaseHeader.Status := ContractPurchaseHeader.Status::Open;
        ContractPurchaseHeader."Red Reg Contract Status" := ContractPurchaseHeader."Red Reg Contract Status"::Concept;
        ContractPurchaseHeader."Red Reg Sales Contract No." := SalesHeader."No.";
        ContractPurchaseHeader."Red Reg Group" := SalesHeader."Red Reg Group";
        ContractPurchaseHeader.Validate("Red Reg Start Date", SalesHeader."Red Reg Start Date");
        ContractPurchaseHeader.Validate("Red Reg Duration", SalesHeader."Red Reg Duration");
        ContractPurchaseHeader.Insert(true);
    end;

    local procedure InsertContractLine(var ContractPurchaseHeader: Record "Purchase Header"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        ContractPurchaseLine: Record "Purchase Line";
    begin
        ContractPurchaseLine.SetRange("Document Type", ContractPurchaseHeader."Document Type");
        ContractPurchaseLine.SetRange("Document No.", ContractPurchaseHeader."No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Document Type", ContractPurchaseHeader."Red Reg Org. Document Type");
        ContractPurchaseLine.SetRange("Red Reg Org. Document No.", ContractPurchaseHeader."Red Reg Org. Document No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Document Line No.", PurchRcptLine."Line No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Shipment No.", PurchRcptLine."Document No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Shipment Line No.", PurchRcptLine."Line No.");
        if ContractPurchaseLine.FindFirst() then begin
            ContractPurchaseLine.Validate("Quantity", PurchRcptLine.Quantity);
            ContractPurchaseLine.Modify(true);
            exit;
        end;

        ContractPurchaseLine.RedRegInitNewLine(ContractPurchaseHeader);
        ContractPurchaseLine.TransferFields(PurchRcptLine, false);
        ContractPurchaseLine.Validate(Quantity, PurchRcptLine.Quantity);
        ContractPurchaseLine."Red Reg Org. Document Type" := ContractPurchaseHeader."Red Reg Org. Document Type";
        ContractPurchaseLine."Red Reg Org. Document No." := ContractPurchaseHeader."Red Reg Org. Document No.";
        ContractPurchaseLine."Red Reg Org. Document Line No." := PurchRcptLine."Line No.";
        ContractPurchaseLine."Red Reg Org. Shipment No." := PurchRcptLine."Document No.";
        ContractPurchaseLine."Red Reg Org. Shipment Line No." := PurchRcptLine."Line No.";
        ContractPurchaseLine.Insert(true);
    end;

    local procedure InsertContractLine(var ContractPurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line")
    var
        ContractPurchaseLine: Record "Purchase Line";
    begin
        ContractPurchaseLine.SetRange("Document Type", ContractPurchaseHeader."Document Type");
        ContractPurchaseLine.SetRange("Document No.", ContractPurchaseHeader."No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Document Type", ContractPurchaseHeader."Red Reg Org. Document Type");
        ContractPurchaseLine.SetRange("Red Reg Org. Document No.", ContractPurchaseHeader."Red Reg Org. Document No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Document Line No.", PurchaseLine."Line No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Shipment No.", PurchaseLine."Document No.");
        ContractPurchaseLine.SetRange("Red Reg Org. Shipment Line No.", PurchaseLine."Line No.");
        if ContractPurchaseLine.FindFirst() then begin
            ContractPurchaseLine.Validate("Quantity", PurchaseLine.Quantity);
            ContractPurchaseLine.Modify(true);
            exit;
        end;

        ContractPurchaseLine.RedRegInitNewLine(ContractPurchaseHeader);
        ContractPurchaseLine.TransferFields(PurchaseLine, false);
        ContractPurchaseLine."Red Reg Org. Document Type" := ContractPurchaseHeader."Red Reg Org. Document Type";
        ContractPurchaseLine."Red Reg Org. Document No." := ContractPurchaseHeader."Red Reg Org. Document No.";
        ContractPurchaseLine."Red Reg Org. Document Line No." := PurchaseLine."Line No.";
        ContractPurchaseLine."Red Reg Org. Shipment No." := PurchaseLine."Document No.";
        ContractPurchaseLine."Red Reg Org. Shipment Line No." := PurchaseLine."Line No.";
        ContractPurchaseLine.Insert(true);
    end;

    local procedure InsertContractLine(var ContractPurchaseHeader: Record "Purchase Header"; SalesLine: Record "Sales Line")
    var
        ContractPurchaseLine: Record "Purchase Line";
    begin
        ContractPurchaseLine.SetRange("Document Type", ContractPurchaseHeader."Document Type");
        ContractPurchaseLine.SetRange("Document No.", ContractPurchaseHeader."No.");

        ContractPurchaseLine.SetRange("Red Reg Sales Contract No.", SalesLine."Document No.");
        ContractPurchaseLine.SetRange("Red Reg Sales Contract Ln. No.", SalesLine."Line No.");
        if ContractPurchaseLine.FindFirst() then begin
            ContractPurchaseLine.Validate("Quantity", SalesLine.Quantity);
            ContractPurchaseLine.Modify(true);
            exit;
        end;

        ContractPurchaseLine.RedRegInitNewLine(ContractPurchaseHeader);
        ContractPurchaseLine.Validate(Type, SalesLine.Type);
        ContractPurchaseLine.Validate("No.", SalesLine."No.");
        ContractPurchaseLine.Validate(Quantity, SalesLine.Quantity);
        ContractPurchaseLine."Red Reg Org. Document Type" := ContractPurchaseHeader."Document Type";
        ContractPurchaseLine."Red Reg Org. Document No." := ContractPurchaseHeader."No.";
        ContractPurchaseLine."Red Reg Sales Contract No." := SalesLine."Document No.";
        ContractPurchaseLine."Red Reg Sales Contract Ln. No." := SalesLine."Line No.";
        ContractPurchaseLine.Insert(true);
    end;
}