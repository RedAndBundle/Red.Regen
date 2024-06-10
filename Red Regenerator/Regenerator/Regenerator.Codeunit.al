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

    procedure CreateSalesDocument(var SalesHeader: Record "Sales Header")
    begin
        // CheckSalesDocumentForNextBillingDate
        // CheckNextBillingDateInContractPeriod
        // CreateSalesDocument
        SalesHeader.RedRegCalculateNextBillingDate();
    end;
}