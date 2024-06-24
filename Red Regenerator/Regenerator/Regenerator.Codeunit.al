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

    procedure RegenerateSalesDocument(var ContractSalesHeader: Record "Sales Header")
    begin
        TestContract(ContractSalesHeader);
        PrepareContract(ContractSalesHeader);
        CheckSalesDocumentForNextIteration(ContractSalesHeader);
        CreateSalesDocument(ContractSalesHeader);
        ContractSalesHeader.RedRegCalculateNextBillingDate();
        // TODO also regenerate linked purchase contract or possibility to generate purchae order/invoice
    end;

    procedure RegeneratePurchaseDocument(var ContractPurchaseHeader: Record "Purchase Header")
    begin
        // TestContract(ContractPurchaseHeader);
        // PrepareContract(ContractPurchaseHeader);
        // CheckSalesDocumentForNextIteration(ContractPurchaseHeader);
        // CreateSalesDocument(ContractPurchaseHeader);
        ContractPurchaseHeader.RedRegCalculateNextBillingDate();
    end;

    local procedure TestContract(var ContractSalesHeader: Record "Sales Header")
    begin
        ContractSalesHeader.TestField("Red Reg Group");
        ContractSalesHeader.RedRegTestStatusIsActive();
        ContractSalesHeader.RedRegTestContractActive();
    end;

    local procedure PrepareContract(var ContractSalesHeader: Record "Sales Header")
    var
    begin
        ContractSalesHeader."Red Reg Contract Iteration" += 1;
        ContractSalesHeader.Modify();
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
}