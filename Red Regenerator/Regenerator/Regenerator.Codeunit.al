codeunit 11311114 "Red Reg Regenerator"
{
    TableNo = "Sales Header";
    Access = Internal;
    trigger OnRun()
    begin

    end;

    procedure ActivateContract(var SalesHeader: Record "Sales Header")
    var
        ContractSalesHeader: Record "Sales Header";
    begin
        if SalesHeader."Red Reg Contract No." = '' then
            exit;

        if not ContractSalesHeader.Get(ContractSalesHeader."Document Type"::"Red Regenerator", SalesHeader."Red Reg Contract No.") then
            exit;

        if not (ContractSalesHeader."Red Reg Contract Status" in [ContractSalesHeader."Red Reg Contract Status"::Concept, ContractSalesHeader."Red Reg Contract Status"::Accepted]) then
            exit;

        ContractSalesHeader."Red Reg Contract Status" := ContractSalesHeader."Red Reg Contract Status"::Active;
        ContractSalesHeader.Modify();
    end;

    procedure ActivateContract(var PurchaseHeader: Record "Purchase Header")
    var
        ContractPurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader."Red Reg Contract No." = '' then
            exit;

        if not ContractPurchaseHeader.Get(ContractPurchaseHeader."Document Type"::"Red Regenerator", PurchaseHeader."Red Reg Contract No.") then
            exit;

        if not (ContractPurchaseHeader."Red Reg Contract Status" in [ContractPurchaseHeader."Red Reg Contract Status"::Concept, ContractPurchaseHeader."Red Reg Contract Status"::Accepted]) then
            exit;

        ContractPurchaseHeader."Red Reg Contract Status" := ContractPurchaseHeader."Red Reg Contract Status"::Active;
        ContractPurchaseHeader.Modify();
    end;

    procedure RegenerateSalesDocument(var ContractSalesHeader: Record "Sales Header")
    begin
        TestContract(ContractSalesHeader);
        PrepareContract(ContractSalesHeader);
        CheckSalesDocumentForNextIteration(ContractSalesHeader);
        CreateSalesDocument(ContractSalesHeader);
        ContractSalesHeader.RedRegCalculateNextBillingDate();
    end;

    procedure RegeneratePurchaseDocument(var ContractPurchaseHeader: Record "Purchase Header")
    begin
        TestContract(ContractPurchaseHeader);
        PrepareContract(ContractPurchaseHeader);
        CheckPurchaseDocumentForNextIteration(ContractPurchaseHeader);
        CreatePurchaseDocument(ContractPurchaseHeader);
        ContractPurchaseHeader.RedRegCalculateNextBillingDate();
    end;

    procedure RenewContract(var ContractSalesHeader: Record "Sales Header")
    begin
        ContractSalesHeader."Red Reg End Date" := CalcDate(ContractSalesHeader."Red Reg Duration", ContractSalesHeader."Red Reg End Date");
        ContractSalesHeader.RedRegCalculateNextBillingDate();
        ContractSalesHeader.Modify();
    end;

    procedure RenewContract(var ContractPurchaseHeader: Record "Purchase Header")
    begin
        ContractPurchaseHeader."Red Reg End Date" := CalcDate(ContractPurchaseHeader."Red Reg Duration", ContractPurchaseHeader."Red Reg Next Billing Date");
        ContractPurchaseHeader.RedRegCalculateNextBillingDate();
        ContractPurchaseHeader.Modify();
    end;

    local procedure TestContract(var ContractSalesHeader: Record "Sales Header")
    begin
        ContractSalesHeader.TestField("Red Reg Group");
        ContractSalesHeader.RedRegTestStatusIsActive();
        ContractSalesHeader.RedRegTestContractActive();
    end;

    local procedure TestContract(var ContractPurchaseHeader: Record "Purchase Header")
    begin
        ContractPurchaseHeader.TestField("Red Reg Group");
        ContractPurchaseHeader.RedRegTestStatusIsActive();
        ContractPurchaseHeader.RedRegTestContractActive();
    end;

    local procedure PrepareContract(var ContractSalesHeader: Record "Sales Header")
    var
    begin
        ContractSalesHeader."Red Reg Contract Iteration" += 1;
        ContractSalesHeader.Modify();
    end;

    local procedure PrepareContract(var ContractPurchaseHeader: Record "Purchase Header")
    var
    begin
        ContractPurchaseHeader."Red Reg Contract Iteration" += 1;
        ContractPurchaseHeader.Modify();
    end;

    local procedure CheckSalesDocumentForNextIteration(var ContractSalesHeader: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        AlreadyBilledLbl: Label 'The contract has already been billed on %1 %2.', Comment = '%1 = document type, %2 = document no.';
    begin
        SalesHeader.SetRange("Bill-to Customer No.", ContractSalesHeader."Bill-to Customer No.");
        SalesHeader.SetRange("Red Reg Contract No.", ContractSalesHeader."No.");
        SalesHeader.SetRange("Red Reg Contract Iteration", ContractSalesHeader."Red Reg Contract Iteration");
        if SalesHeader.FindFirst() then
            Error(AlreadyBilledLbl, SalesHeader."Document Type", SalesHeader."No.");

        SalesInvoiceHeader.SetRange("Bill-to Customer No.", ContractSalesHeader."Bill-to Customer No.");
        SalesInvoiceHeader.SetRange("Red Reg Contract No.", ContractSalesHeader."No.");
        SalesInvoiceHeader.SetRange("Red Reg Contract Iteration", ContractSalesHeader."Red Reg Contract Iteration");
        if SalesInvoiceHeader.FindFirst() then
            Error(AlreadyBilledLbl, SalesInvoiceHeader.TableCaption, SalesInvoiceHeader."No.");
    end;

    local procedure CheckPurchaseDocumentForNextIteration(var ContractPurchaseHeader: Record "Purchase Header")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        AlreadyBilledLbl: Label 'The contract has already been billed on %1 %2.', Comment = '%1 = document type, %2 = document no.';
    begin
        PurchaseHeader.SetRange("Pay-to Vendor No.", ContractPurchaseHeader."Pay-to Vendor No.");
        PurchaseHeader.SetRange("Red Reg Contract No.", ContractPurchaseHeader."No.");
        PurchaseHeader.SetRange("Red Reg Contract Iteration", ContractPurchaseHeader."Red Reg Contract Iteration");
        if PurchaseHeader.FindFirst() then
            Error(AlreadyBilledLbl, PurchaseHeader."Document Type", PurchaseHeader."No.");

        PurchInvHeader.SetRange("Pay-to Vendor No.", ContractPurchaseHeader."Pay-to Vendor No.");
        PurchInvHeader.SetRange("Red Reg Contract No.", ContractPurchaseHeader."No.");
        PurchInvHeader.SetRange("Red Reg Contract Iteration", ContractPurchaseHeader."Red Reg Contract Iteration");
        if PurchInvHeader.FindFirst() then
            Error(AlreadyBilledLbl, PurchInvHeader.TableCaption, PurchInvHeader."No.");
    end;

    local procedure CreateSalesDocument(var ContractSalesHeader: Record "Sales Header")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ContractSalesLine: Record "Sales Line";
        ContractGroup: Record "Red Reg Contract Group";
    begin
        ContractGroup.Get(ContractSalesHeader."Red Reg Group");

        SalesHeader.Init();
        case ContractGroup."Regenerate Document Type" of
            ContractGroup."Regenerate Document Type"::Order:
                SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            ContractGroup."Regenerate Document Type"::Invoice:
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        end;
        // TODO, creates with old no series, should be new no series
        // TODO posting date not correct, should be next billing date

        SalesHeader.TransferFields(ContractSalesHeader, false);
        SalesHeader.Status := SalesHeader.Status::Open;
        SalesHeader."Red Reg Contract No." := ContractSalesHeader."No.";
        SalesHeader.Validate("Posting Date", ContractSalesHeader."Red Reg Next Billing Date");
        SalesHeader.Insert(true);

        ContractSalesLine.SetRange("Document Type", ContractSalesHeader."Document Type");
        ContractSalesLine.SetRange("Document No.", ContractSalesHeader."No.");
        if ContractSalesLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Line No." := ContractSalesLine."Line No.";
                SalesLine.TransferFields(ContractSalesLine, false);
                SalesLine.Insert(true);
            until ContractSalesLine.Next() = 0;
    end;

    local procedure CreatePurchaseDocument(var ContractPurchaseHeader: Record "Purchase Header")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        ContractPurchaseLine: Record "Purchase Line";
        ContractGroup: Record "Red Reg Contract Group";
    begin
        ContractGroup.Get(ContractPurchaseHeader."Red Reg Group");

        PurchaseHeader.Init();
        case ContractGroup."Regenerate Document Type" of
            ContractGroup."Regenerate Document Type"::Order:
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
            ContractGroup."Regenerate Document Type"::Invoice:
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        end;

        PurchaseHeader.TransferFields(ContractPurchaseHeader, false);
        PurchaseHeader.Status := PurchaseHeader.Status::Open;
        PurchaseHeader."Red Reg Contract No." := ContractPurchaseHeader."No.";
        PurchaseHeader."Red Reg Sales Contract No." := ContractPurchaseHeader."Red Reg Sales Contract No.";
        PurchaseHeader.Validate("Posting Date", ContractPurchaseHeader."Red Reg Next Billing Date");
        PurchaseHeader.Insert(true);

        ContractPurchaseLine.SetRange("Document Type", ContractPurchaseHeader."Document Type");
        ContractPurchaseLine.SetRange("Document No.", ContractPurchaseHeader."No.");
        if ContractPurchaseLine.FindSet() then
            repeat
                PurchaseLine.Init();
                PurchaseLine."Document No." := PurchaseHeader."No.";
                PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                PurchaseLine."Line No." := ContractPurchaseLine."Line No.";
                PurchaseLine.TransferFields(ContractPurchaseLine, false);
                PurchaseLine."Red Reg Sales Contract No." := ContractPurchaseLine."Red Reg Sales Contract No.";
                PurchaseLine."Red Reg Sales Contract Ln. No." := ContractPurchaseLine."Red Reg Sales Contract Ln. No.";
                PurchaseLine.Insert(true);
            until ContractPurchaseLine.Next() = 0;
    end;
}