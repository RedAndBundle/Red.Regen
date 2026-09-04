namespace Red.Regenerator.Test;
using Red.Regenerator;
codeunit 70803 "Create Sales Templates Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [HandlerFunctions('CreateSalesTemplatesRequestPageHandler,ResultMessageHandler')]
    procedure CreatesTemplateForMatchingItem()
    var
        ContractGroup: Record "Red Reg Contract Group";
        ContractTemplate: Record "Red Reg Sales Contr. Template";
        ExpectedDuration: DateFormula;
        ExpectedBillingPeriod: DateFormula;
        ItemNo: Code[20];
        UnitPrice: Decimal;
    begin
        // [FEATURE] Create Sales Contract Templates report
        // [GIVEN] a sellable item that has no contract template yet
        TestSetup.EnsureNonInventoryItem(ItemNo, UnitPrice);
        ContractGroup.Get(TestSetup.EnsureContractGroup());

        // [WHEN] running the report, filtered to that item, with template settings entered
        ItemNoFilter := ItemNo;
        ContractGroupToSet := ContractGroup.Code;
        DurationToSet := '<1Y>';
        BillingPeriodToSet := '<1M>';
        ShowOnDocumentsToSet := true;
        Report.Run(Report::"Red Reg Create Sales Templates");

        // [THEN] a contract template is created for the item with the entered settings
        ContractTemplate.Get(ContractTemplate.Type::Item, ItemNo);
        ContractTemplate.TestField("Contract Group", ContractGroup.Code);
        Evaluate(ExpectedDuration, DurationToSet);
        ContractTemplate.TestField(Duration, ExpectedDuration);
        Evaluate(ExpectedBillingPeriod, BillingPeriodToSet);
        ContractTemplate.TestField("Red Reg Billing Period", ExpectedBillingPeriod);
        ContractTemplate.TestField("Show On Documents", true);
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [HandlerFunctions('CreateSalesTemplatesRequestPageHandler,ResultMessageHandler')]
    procedure SkipsItemThatAlreadyHasATemplate()
    var
        ContractGroup: Record "Red Reg Contract Group";
        ContractTemplate: Record "Red Reg Sales Contr. Template";
        OriginalDuration: DateFormula;
        ItemNo: Code[20];
        UnitPrice: Decimal;
    begin
        // [FEATURE] Create Sales Contract Templates report
        // [GIVEN] an item that already has a contract template
        TestSetup.EnsureNonInventoryItem(ItemNo, UnitPrice);
        TestSetup.EnsureSalesContractTemplate(ItemNo);
        ContractGroup.Get(TestSetup.EnsureContractGroup());

        // [WHEN] running the report for that item with different template settings
        ItemNoFilter := ItemNo;
        ContractGroupToSet := ContractGroup.Code;
        DurationToSet := '<2Y>';
        BillingPeriodToSet := '<3M>';
        ShowOnDocumentsToSet := true;
        Report.Run(Report::"Red Reg Create Sales Templates");

        // [THEN] the existing template is left untouched, not overwritten
        ContractTemplate.Get(ContractTemplate.Type::Item, ItemNo);
        ContractTemplate.TestField(Description, 'Test Sales Contract Template');
        Evaluate(OriginalDuration, '<1Y>');
        ContractTemplate.TestField(Duration, OriginalDuration);
        ContractTemplate.TestField("Show On Documents", false);
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [HandlerFunctions('CreateSalesTemplatesRequestPageHandler')]
    procedure ErrorsWhenContractGroupIsBlank()
    var
        ItemNo: Code[20];
        UnitPrice: Decimal;
    begin
        // [FEATURE] Create Sales Contract Templates report
        // [GIVEN] a sellable item and no Contract Group entered on the request page
        TestSetup.EnsureNonInventoryItem(ItemNo, UnitPrice);
        ItemNoFilter := ItemNo;
        ContractGroupToSet := '';
        DurationToSet := '<1Y>';
        BillingPeriodToSet := '<1Y>';
        ShowOnDocumentsToSet := false;

        // [WHEN] running the report
        // [THEN] it errors instead of creating a template
        asserterror Report.Run(Report::"Red Reg Create Sales Templates");
        ItemHasNoContractTemplate(ItemNo);
    end;

    local procedure ItemHasNoContractTemplate(ItemNo: Code[20])
    var
        ContractTemplate: Record "Red Reg Sales Contr. Template";
    begin
        if ContractTemplate.Get(ContractTemplate.Type::Item, ItemNo) then
            Error('No contract template should have been created.');
    end;

    [RequestPageHandler]
    procedure CreateSalesTemplatesRequestPageHandler(var CreateSalesTemplates: TestRequestPage "Red Reg Create Sales Templates")
    begin
        CreateSalesTemplates.Item.SetFilter("No.", ItemNoFilter);
        CreateSalesTemplates.ContractGroup.SetValue(ContractGroupToSet);
        CreateSalesTemplates.Duration.SetValue(DurationToSet);
        CreateSalesTemplates.BillingPeriod.SetValue(BillingPeriodToSet);
        CreateSalesTemplates.ShowOnDocuments.SetValue(ShowOnDocumentsToSet);
        CreateSalesTemplates.OK().Invoke();
    end;

    [MessageHandler]
    procedure ResultMessageHandler(Message: Text)
    begin
        LastResultMessage := Message;
    end;

    var
        TestSetup: Codeunit "Test Setup";
        ItemNoFilter: Code[20];
        ContractGroupToSet: Code[20];
        DurationToSet: Text[30];
        BillingPeriodToSet: Text[30];
        ShowOnDocumentsToSet: Boolean;
        LastResultMessage: Text;
}
