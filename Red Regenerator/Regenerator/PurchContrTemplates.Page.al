namespace Red.Regenerator;
page 11311124 "Red Reg Purch. Contr Templates"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Red Reg Purch. Contr. Template";
    Caption = 'Purchase Contract Templates';

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
                field("Application Area"; Rec."Application Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which application area the contract is created.';
                }
                // field("Generation Moment"; Rec."Generation Moment")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies when the contract is generated. This can be automatically or manual.';
                // }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the contract.';
                }
                field("Contract Group"; Rec."Contract Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the settings of the contract that will be created.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the contract in a date formula. If you do not specify a duration you must set one manually after the contract is generated.';
                }
                field("Red Reg Billing Period"; Rec."Red Reg Billing Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the billing period of the contract. If you do not specify a billing period the contract duration is used.';
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