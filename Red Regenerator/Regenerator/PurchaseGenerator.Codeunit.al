namespace Red.Regenerator;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.History;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;
codeunit 70640 "Red Reg Purchase Generator"
{
    TableNo = "Purchase Header";
    Access = Internal;
    Permissions = tabledata "Red Reg Setup" = rimd, tabledata "Red Reg Purch. Contr. Template" = rimd, tabledata "Purchase Header" = rimd, tabledata "Purchase Line" = rimd, tabledata "Purch. Rcpt. Header" = r, tabledata "Purch. Rcpt. Line" = r;

    trigger OnRun()
    begin
    end;

    procedure TestPurchaseSetup()
    var
        ContractTemplate: Record "Red Reg Purch. Contr. Template";
        Setup: Record "Red Reg Setup";
    begin
        // ContractTemplate.SetFilter("Application Area", '%1|%2', ContractTemplate."Application Area"::Purchase, ContractTemplate."Application Area"::" ");
        if ContractTemplate.IsEmpty() then
            exit;

        Setup.InitSetup();
        Setup.TestPurchaseSetup();
    end;

    procedure WillGenerateContractsAfterPurchasePost(var PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::"Blanket Order",
            PurchaseHeader."Document Type"::"Credit Memo",
            PurchaseHeader."Document Type"::Quote,
            PurchaseHeader."Document Type"::"Return Order",
            PurchaseHeader."Document Type"::"Red ReGenerator":
                exit(false);
        end;

        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Red Reg Generates Contract", true);
        exit(not PurchaseLine.IsEmpty());
    end;

    procedure GenerateContractsAfterPurchasePost(var PurchaseHeader: Record "Purchase Header"; PurchaseShptHdrNo: Code[20]; PurchaseInvHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        ContractPurchaseHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ContractTemplate: Record "Red Reg Purch. Contr. Template";
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

        if not PurchRcptHeader.Get(PurchaseShptHdrNo) then
            exit;

        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        if PurchRcptLine.FindSet() then
            repeat
                if GetContractTemplate(ContractTemplate, PurchRcptLine.Type, PurchRcptLine."No.") then begin
                    ContractPurchaseHeader := GetContractHeader(PurchaseHeader, PurchRcptHeader."Posting Date", ContractTemplate);
                    InsertContractLine(ContractPurchaseHeader, PurchRcptLine);
                end;
            until PurchRcptLine.Next() = 0;
    end;

    procedure GenerateContracts(var PurchaseHeader: Record "Purchase Header")
    var
        ContractPurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        ContractTemplate: Record "Red Reg Purch. Contr. Template";
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
                if GetContractTemplate(ContractTemplate, PurchaseLine.Type, PurchaseLine."No.") then begin
                    ContractPurchaseHeader := GetContractHeader(PurchaseHeader, PurchaseHeader."Document Date", ContractTemplate);
                    InsertContractLine(ContractPurchaseHeader, PurchaseLine);
                end;
            until PurchaseLine.Next() = 0;
    end;

    // local procedure HasContractTemplate(Type: Enum "Purchase Line Type"; No: Code[20]; ItemCategoryCode: Code[20]): Boolean
    // var
    //     ContractTemplate: Record "Red Reg Purch. Contr. Template";
    // begin
    //     If not (Type in [Type::"G/L Account", Type::"Resource", Type::"Item"]) then
    //         exit(false);

    //     ContractTemplate.SetFilter("Application Area", '%1|%2', ContractTemplate."Application Area"::Purchase, ContractTemplate."Application Area"::" ");
    //     ContractTemplate.SetRange(Type, ContractTemplate.ConvertType(Type));
    //     ContractTemplate.SetRange("No.", No);
    //     if not ContractTemplate.IsEmpty() then
    //         exit(true);

    //     if (Type = Type::Item) and (ItemCategoryCode <> '') then begin
    //         ContractTemplate.SetRange("No.", ItemCategoryCode);
    //         exit(not ContractTemplate.IsEmpty);
    //     end;
    // end;

    local procedure GetContractTemplate(var ContractTemplate: Record "Red Reg Purch. Contr. Template"; Type: Enum "Purchase Line Type"; No: Code[20]): Boolean
    begin
        exit(ContractTemplate.Get(Type, No));
    end;

    procedure CreatePurchaseContractFromSalesLine(SalesLine: Record "Sales Line")
    var
        ContractPurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        ContractGroup: Record "Red Reg Contract Group";
    begin
        if SalesLine."Document Type" <> SalesLine."Document Type"::"Red ReGenerator" then
            exit;

        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        if not ContractGroup.Get(SalesHeader."Red Reg Group") then
            exit;

        if ContractGroup."Purchase Type" <> ContractGroup."Purchase Type"::"Purchase Contract" then
            exit;

        ContractPurchaseHeader := GetContractHeader(SalesHeader, SalesLine);
        InsertContractLine(ContractPurchaseHeader, SalesLine);
    end;

    local procedure GetContractHeader(PurchaseHeader: Record "Purchase Header"; StartDate: Date; ContractTemplate: Record "Red Reg Purch. Contr. Template") ContractPurchaseHeader: Record "Purchase Header"
    var
        EmptyDateFormula: DateFormula;
    begin
        ContractPurchaseHeader.SetCurrentKey("Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration");
        ContractPurchaseHeader.SetRange("Red Reg Org. Document Type", PurchaseHeader."Document Type");
        ContractPurchaseHeader.SetRange("Red Reg Org. Document No.", PurchaseHeader."No.");
        ContractPurchaseHeader.SetRange("Red Reg Group", ContractTemplate."Contract Group");
        ContractPurchaseHeader.SetRange("Red Reg Duration", ContractTemplate."Duration");
        if ContractPurchaseHeader.FindFirst() then
            exit(ContractPurchaseHeader);

        ContractPurchaseHeader.Init();
        ContractPurchaseHeader."Document Type" := ContractPurchaseHeader."Document Type"::"Red ReGenerator";
        ContractPurchaseHeader.TransferFields(PurchaseHeader, false);
        ContractPurchaseHeader.Status := ContractPurchaseHeader.Status::Open;
        ContractPurchaseHeader."Red Reg Contract Status" := ContractPurchaseHeader."Red Reg Contract Status"::Concept;

        ContractPurchaseHeader."Red Reg Org. Document Type" := PurchaseHeader."Document Type";
        ContractPurchaseHeader."Red Reg Org. Document No." := PurchaseHeader."No.";
        ContractPurchaseHeader."Red Reg Group" := ContractTemplate."Contract Group";
        ContractPurchaseHeader."Red Reg Start Date" := StartDate;
        ContractPurchaseHeader."Red Reg Next Billing Date" := ContractPurchaseHeader."Red Reg Start Date";
        if ContractTemplate."Duration" <> EmptyDateFormula then begin
            ContractPurchaseHeader.Validate("Red Reg Duration", ContractTemplate."Duration");
            if ContractTemplate."Red Reg Billing Period" <> EmptyDateFormula then
                ContractPurchaseHeader.Validate("Red Reg Billing Period", ContractTemplate."Red Reg Billing Period");
            ContractPurchaseHeader.RedRegCalculateNextBillingDate();
        end;

        ContractPurchaseHeader."Red Reg Contract Status" := ContractPurchaseHeader."Red Reg Contract Status"::AutoGenerated;
        ContractPurchaseHeader.Insert(true);
    end;

    local procedure GetContractHeader(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line") ContractPurchaseHeader: Record "Purchase Header"
    var
        Item: Record Item;
        Vendor: Record Vendor;
    begin
        // TODO get from GL and Resource lines
        SalesLine.TestField(Type, SalesLine.Type::Item);
        Item.Get(SalesLine."No.");
        Item.TestField("Vendor No.");
        Vendor.Get(Item."Vendor No.");

        ContractPurchaseHeader.SetCurrentKey("Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration");
        ContractPurchaseHeader.SetRange("Red Reg Contract No.", SalesHeader."No.");
        ContractPurchaseHeader.SetRange("Document Type", ContractPurchaseHeader."Document Type"::"Red ReGenerator");
        ContractPurchaseHeader.SetRange("Red Reg Contract Status", ContractPurchaseHeader."Red Reg Contract Status"::Concept);
        ContractPurchaseHeader.SetRange("Buy-from Vendor No.", Vendor."No.");

        if ContractPurchaseHeader.FindFirst() then
            exit(ContractPurchaseHeader);

        ContractPurchaseHeader.Init();
        ContractPurchaseHeader."Document Type" := ContractPurchaseHeader."Document Type"::"Red ReGenerator";
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