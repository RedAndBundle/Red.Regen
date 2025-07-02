namespace Red.Regenerator;
using Microsoft.Sales.Document;
pageextension 70621 "Red Reg Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Red Reg Contract No."; Rec."Red Reg Contract No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the contract that this document was created from.';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("Red Reg Create Contract Items")
            {
                ApplicationArea = All;
                Caption = 'Create Contract Items';
                Image = SuggestLines;
                ToolTip = 'Generates lines for contract items.';

                trigger OnAction()
                begin
                    Rec.GenerateContractItems();
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("Red Reg Create Contract Items Promoted"; "Red Reg Create Contract Items")
            {
            }
        }
    }
    // var
    //     RedRegShowGenerateAction: Boolean;

    // trigger OnOpenPage()
    // begin
    //     RedRegShowGenerateAction := Rec.RedRegShowGenerate();
    // end;
}