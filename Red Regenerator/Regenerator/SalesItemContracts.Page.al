namespace Red.Regenerator;
page 70651 "Red Reg Sales Item Contracts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Red Reg Sales Item Contract";
    Caption = 'Sales Item Contracts';

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which line type the contract is created. Item takes precedence over Item Category.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which source number the contract is created.';
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the contract.';
                }
                field("Template Type"; Rec."Template Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which line type the contract is created. Item takes precedence over Item Category.';
                    ValuesAllowed = "G/L Account", "Item", "Resource";
                }
                field("Template No."; Rec."Template No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which source number the contract is created.';
                }
                field("Template Description"; Rec."Template Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the template.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action(ActionName)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin

            //     end;
            // }
        }
    }
}