namespace Red.Regenerator;

using Microsoft.Inventory.Item;

report 70653 "Red Reg Create Sales Templates"
{
    Caption = 'Create Sales Contract Templates';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.") where(Blocked = const(false), "Sales Blocked" = const(false));
            RequestFilterFields = "No.", "Item Category Code", Type;

            trigger OnPreDataItem()
            begin
                if ContractGroup = '' then
                    Error(ContractGroupBlankErr);

                CreatedCount := 0;
                SkippedExistingCount := 0;
                SkippedErrorCount := 0;
            end;

            trigger OnAfterGetRecord()
            begin
                if TemplateExists(Item."No.") then
                    SkippedExistingCount += 1
                else
                    if InsertContractTemplate(Item."No.") then
                        CreatedCount += 1
                    else
                        SkippedErrorCount += 1;
            end;

            trigger OnPostDataItem()
            begin
                Message(ResultMsg, CreatedCount, SkippedExistingCount, SkippedErrorCount);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Contract Template Settings';

                    field(ContractGroup; ContractGroup)
                    {
                        ApplicationArea = All;
                        Caption = 'Contract Group';
                        ToolTip = 'Specifies the contract group to set on the contract template created for every item that matches the filters below.';
                        TableRelation = "Red Reg Contract Group";
                    }
                    field(Duration; Duration)
                    {
                        ApplicationArea = All;
                        Caption = 'Duration';
                        ToolTip = 'Specifies the duration to set on the contract template, as a date formula. If you do not specify a duration you must set one manually after the template is created.';
                    }
                    field(BillingPeriod; BillingPeriod)
                    {
                        ApplicationArea = All;
                        Caption = 'Billing Period';
                        ToolTip = 'Specifies the billing period to set on the contract template, as a date formula. If you do not specify a billing period the contract duration is used.';
                    }
                    field(ShowOnDocuments; ShowOnDocuments)
                    {
                        ApplicationArea = All;
                        Caption = 'Show On Documents';
                        ToolTip = 'Specifies whether the contract lines should be shown on documents.';
                    }
                }
            }
        }
    }

    var
        Duration: DateFormula;
        BillingPeriod: DateFormula;
        ContractGroup: Code[20];
        ShowOnDocuments: Boolean;
        CreatedCount: Integer;
        SkippedExistingCount: Integer;
        SkippedErrorCount: Integer;
        ContractGroupBlankErr: Label 'You must select a Contract Group before you can create contract templates.';
        ResultMsg: Label 'Created %1 contract template(s).\Skipped %2 that already had a template.\Skipped %3 that could not be sold (blocked or missing setup).', Comment = '%1 = created count, %2 = already existing count, %3 = error count';

    local procedure TemplateExists(ItemNo: Code[20]): Boolean
    var
        ContractTemplate: Record "Red Reg Sales Contr. Template";
    begin
        exit(ContractTemplate.Get(ContractTemplate.Type::Item, ItemNo));
    end;

    local procedure InsertContractTemplate(ItemNo: Code[20]): Boolean
    var
        ContractTemplate: Record "Red Reg Sales Contr. Template";
    begin
        ContractTemplate.Init();
        ContractTemplate.Validate(Type, ContractTemplate.Type::Item);
        ContractTemplate.Validate("No.", ItemNo);
        ContractTemplate."Contract Group" := ContractGroup;
        ContractTemplate.Duration := Duration;
        ContractTemplate."Red Reg Billing Period" := BillingPeriod;
        ContractTemplate."Show On Documents" := ShowOnDocuments;
        exit(ContractTemplate.Insert(true));
    end;
}
