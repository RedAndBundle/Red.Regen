page 11311122 "Red Reg Item Contracts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Red Reg Item Contract";
    Caption = 'Item Contracts';

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
                }
                field("Template No."; Rec."Template No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which source number the contract is created.';
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