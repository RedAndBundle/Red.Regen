pageextension 11311116 "Red Reg Posted Purch. Invoice" extends "Posted Purchase Invoice"
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
            // action("Red Reg Create Contract")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Generate Contract';
            //     Image = CreateDocument;
            //     ToolTip = 'Generates a Contract if there are sales lines with numbers that are specified in the Contract Generator List.';
            //     RunObject = codeunit "Red Reg Purchase Generator";
            //     Visible = RedRegShowGenerateAction;
            //     Enabled = Rec."Red Reg Contract No." = '';
            // }
            // TODO open generated and related contracts
        }
        addlast(Category_Process)
        {
            // actionref("Red Reg Create Contract_Promoted"; "Red Reg Create Contract")
            // {
            // }
        }
    }
}