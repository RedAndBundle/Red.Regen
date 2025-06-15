namespace Red.Regenerator.Test;
using Red.Regenerator;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
codeunit 70801 "Generator Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure GenerateSalesContract()
    var
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesTemplate: Record "Red Reg Sales Contr. Template";
        TestSetup: Codeunit "Test Setup";
        ItemNo: Code[20];
        UnitPrice: Decimal;
    begin
        // [FEATURE] Test the generate sales contract from a sales document
        // [Given] Regenerator setup with number series
        TestSetup.EnsureSetup();

        // [Given] an item set for non inventory
        TestSetup.EnsureNonInventoryItem(ItemNo, UnitPrice);

        // [Given] a Red Sales Contract Template
        SalesTemplate := TestSetup.EnsureSalesContractTemplate(ItemNo);

        // [Given] ensure a customer
        TestSetup.EnsureCustomer(Customer);

        // [Given] a sales document with lines
        TestSetup.EnsureSourceRecord(SalesHeader, Customer, ItemNo);

        // [WHEN] ship a sales document
        TestSetup.EnsureSourceRecordPosted(SalesHeader);

        // [THEN] the sales contract is created with the correct lines
        TestForSalesContract(SalesHeader, SalesTemplate, UnitPrice);
    end;

    local procedure TestForSalesContract(SalesHeader: Record "Sales Header"; SalesTemplate: Record "Red Reg Sales Contr. Template"; UnitPrice: Decimal)
    var
        ContractHeader: Record "Sales Header";
        ContractLine: Record "Sales Line";
    begin
        ContractHeader.SetRange("Red Reg Org. Document No.", SalesHeader."No.");
        ContractHeader.SetRange("Red Reg Org. Document Type", SalesHeader."Document Type");
        ContractHeader.FindFirst();
        ContractHeader.TestField("Red Reg Duration", SalesTemplate.Duration);
        ContractHeader.TestField("Red Reg Billing Period", SalesTemplate."Red Reg Billing Period");
        ContractLine.SetRange("Document Type", ContractHeader."Document Type");
        ContractLine.SetRange("Document No.", ContractHeader."No.");
        ContractLine.SetRange(Type, SalesTemplate.Type);
        ContractLine.SetRange("No.", SalesTemplate."No.");
        ContractLine.FindFirst();
        ContractLine.TestField("Unit Price", UnitPrice);
    end;
}