codeunit 11311119 "Red Reg Sales Document"
{
    Access = Internal;

    procedure GenerateContractDocumentLine(var NewSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line")
    var
        ItemContract: Record "Red Reg Sales Item Contract";
        Quantity: Decimal;
    begin
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then
            exit;

        if HasContractSalesLine(SalesLine) then
            exit;

        if not GetItemContract(ItemContract, Quantity, SalesLine) then
            exit;

        CreateSalesLineFromItemContract(NewSalesLine, ItemContract, SalesLine, Quantity);
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
        exit(ItemContract.FindFirst());
    end;

    local procedure CreateSalesLineFromItemContract(var NewSalesLine: Record "Sales Line"; ItemContract: Record "Red Reg Sales Item Contract"; SalesLine: Record "Sales Line"; Quantity: Decimal)
    begin
        if Quantity = 0 then
            exit;

        ItemContract.CalcFields("Template Description");
        NewSalesLine.Init();
        NewSalesLine."Document Type" := SalesLine."Document Type";
        NewSalesLine."Document No." := SalesLine."Document No.";
        NewSalesLine."Line No." := SalesLine."Line No." + 1;
        NewSalesLine.Type := ItemContract."Template Type";
        NewSalesLine.Validate("No.", ItemContract."Template No.");
        NewSalesLine.Description := ItemContract."Template Description";
        NewSalesLine."Attached to Line No." := SalesLine."Line No.";
        NewSalesLine.Validate(Quantity, Quantity);
        NewSalesLine.Insert(true);

        // NewSalesLine.Validate("Unit Price", ItemContract."Unit Price");
        // NewSalesLine.Validate("Quantity", ItemContract.Quantity);
        // NewSalesLine.Validate("Unit of Measure", ItemContract."Unit of Measure");
        // NewSalesLine.Validate("Posting Date", SalesLine."Posting Date");
        // NewSalesLine.Validate("Document Date", SalesLine."Document Date");
        // NewSalesLine."Red Reg Contract Line No." := ItemContract."Red Reg Contract Line No.";
    end;
}