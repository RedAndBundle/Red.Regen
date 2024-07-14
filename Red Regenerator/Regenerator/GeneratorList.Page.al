page 11311118 "Red Reg Generator List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Red Reg Generator";
    Caption = 'Contract Generator List';

    layout
    {
        area(Content)
        {
            repeater(repeater)
            {
                field("Application Area"; Rec."Application Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fror which application area the contract is created.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies from which document type the contract is created. When a line from the selected document type is shipped a contract will be created. Type any takes precedent over other types.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fror which line type the contract is created. Item takes precedence over Item Category.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies fror which source number the contract is created.';
                }
                field("Generation Moment"; Rec."Generation Moment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies when the contract is generated. This can be automatically or manual.';
                }
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