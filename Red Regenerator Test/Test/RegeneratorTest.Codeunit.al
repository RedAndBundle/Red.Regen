
namespace Red.Regenerator.Test;
using Red.Regenerator;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Document;
codeunit 70802 "Regenerator Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    procedure GenerateSalesContract()
    var
        Customer: Record Customer;
        ContractHeader: Record "Sales Header";
        TestSetup: Codeunit "Test Setup";
        ItemNo: Code[20];
        UnitPrice: Decimal;
    begin
        // [FEATURE] Test the generate sales contract from a sales document
        // [Given] Regenerator setup with number series
        TestSetup.EnsureSetup();

        // [Given] an item set for non inventory
        TestSetup.EnsureNonInventoryItem(ItemNo, UnitPrice);

        // [Given] ensure a customer
        TestSetup.EnsureCustomer(Customer);

        // [Given] a Sales Contract
        TestSetup.EnsureSalesContract(ContractHeader, Customer, ItemNo);

        // [WHEN] ship a sales document
        ContractHeader.RedRegAccept();

        // [THEN] the sales contract is created with the correct lines
        TestSalesHeader(ContractHeader, ItemNo, UnitPrice);
    end;

    local procedure TestSalesHeader(ContractHeader: Record "Sales Header"; ItemNo: Code[20]; UnitPrice: Decimal)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Red Reg Contract No.", ContractHeader."No.");
        SalesHeader.SetRange("Red Reg Contract Iteration", ContractHeader."Red Reg Contract Iteration");
        SalesHeader.FindFirst();
        SalesHeader.TestField("Sell-to Customer No.", ContractHeader."Sell-to Customer No.");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.FindFirst();
        SalesLine.TestField("Unit Price", UnitPrice);
    end;
}