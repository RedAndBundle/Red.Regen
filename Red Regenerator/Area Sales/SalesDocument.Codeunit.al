namespace Red.Regenerator;
using Microsoft.Sales.Document;
codeunit 70620 "Red Reg Sales Document"
{
    Access = Internal;
    SingleInstance = true;

    var
        OriginalSalesLine: Record "Sales Line";
        SelectedItemContract: Record "Red Reg Sales Item Contract";
        ContractQuantity: Decimal;
        ItemContractSelected: Boolean;

    internal procedure SelectItemContract(SalesLine: Record "Sales Line")
    var
    begin
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then
            exit;

        if HasContractSalesLine(SalesLine) then
            exit;

        ClearGlobals();
        if not GetItemContract(SelectedItemContract, ContractQuantity, SalesLine) then
            exit;

        OriginalSalesLine := SalesLine;
        ItemContractSelected := true;
    end;

    internal procedure GenerateContractDocumentLine(SalesLine: Record "Sales Line")
    var
        NewSalesLine: Record "Sales Line";
    begin
        if not ItemContractSelected then
            exit;

        repeat
            CreateSalesLineFromItemContract(NewSalesLine, SelectedItemContract, SalesLine, ContractQuantity);
        until SelectedItemContract.Next() = 0;

        ClearGlobals();
    end;

    procedure GenerateContractDocumentLine(var NewSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line")
    var
        ItemContract: Record "Red Reg Sales Item Contract";
        Quantity: Decimal;
    begin
        Clear(NewSalesLine);
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then
            exit;

        if HasContractSalesLine(SalesLine) then
            exit;

        if not GetItemContract(ItemContract, Quantity, SalesLine) then
            exit;

        repeat
            CreateSalesLineFromItemContract(NewSalesLine, ItemContract, SalesLine, Quantity);
        until ItemContract.Next() = 0;
    end;

    local procedure HasContractSalesLine(SalesLine: Record "Sales Line"): Boolean
    var
        TestSalesLine: Record "Sales Line";
    begin
        TestSalesLine.SetRange("Document Type", SalesLine."Document Type");
        TestSalesLine.SetRange("Document No.", SalesLine."Document No.");
        TestSalesLine.SetRange("Attached to Line No.", SalesLine."Line No.");
        TestSalesLine.SetRange("Red Reg Generates Contract", true);
        exit(not TestSalesLine.IsEmpty());
    end;

    local procedure GetItemContract(var ItemContract: Record "Red Reg Sales Item Contract"; var Quantity: Decimal; SalesLine: Record "Sales Line"): Boolean
    var
        ItemContractSelect: Page "Red Reg Sls Item Contract Sel";
    begin
        ItemContract.SetRange(Type, SalesLine.Type);
        ItemContract.SetRange("No.", SalesLine."No.");
        if not ItemContract.FindSet() then
            exit;

        ItemContractSelect.SetSourceSalesLine(SalesLine);
        ItemContractSelect.SetTableView(ItemContract);
        ItemContractSelect.LookupMode(true);
        if not (ItemContractSelect.RunModal() in [Action::LookupOK, Action::OK]) then
            exit(false);

        Quantity := ItemContractSelect.GetQuantity();
        ItemContractSelect.SetSelectionFilter(ItemContract);
        exit(ItemContract.FindSet());
    end;

    local procedure CreateSalesLineFromItemContract(var NewSalesLine: Record "Sales Line"; ItemContract: Record "Red Reg Sales Item Contract"; SalesLine: Record "Sales Line"; Quantity: Decimal)
    begin
        ItemContract.CalcFields("Template Description");
        NewSalesLine.Init();
        NewSalesLine."Document Type" := SalesLine."Document Type";
        NewSalesLine."Document No." := SalesLine."Document No.";
        if NewSalesLine."Line No." = 0 then
            NewSalesLine."Line No." := SalesLine."Line No." + 1
        else
            NewSalesLine."Line No." += 1;

        NewSalesLine.Type := ItemContract."Template Type";
        NewSalesLine.Validate("No.", ItemContract."Template No.");
        NewSalesLine.Description := ItemContract."Template Description";
        NewSalesLine."Attached to Line No." := SalesLine."Line No.";
        NewSalesLine.Validate(Quantity, Quantity);
        NewSalesLine.Insert(true);
    end;

    local procedure ClearGlobals()
    begin
        Clear(OriginalSalesLine);
        Clear(SelectedItemContract);
        ContractQuantity := 0;
        ItemContractSelected := false;
    end;
}