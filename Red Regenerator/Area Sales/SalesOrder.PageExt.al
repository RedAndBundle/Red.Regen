pageextension 11311113 "Red Reg Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Red Reg Contract No."; Rec."Red Reg Contract No.")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action("Red Reg Create Contract")
            {
                ApplicationArea = All;
                Caption = 'Generate Contract';
                Image = CreateDocument;
                ToolTip = 'Generates a Contract if there are sales lines with numbers that are specified in the Contract Generator List.';
                RunObject = codeunit "Red Reg Sales Generator";
                Visible = RedRegShowGenerateAction;
            }
            // TODO open generated and related contracts
        }
        addlast(Category_Process)
        {
            actionref("Red Reg Create Contract_Promoted"; "Red Reg Create Contract")
            {
            }
        }
    }
    var
        RedRegShowGenerateAction: Boolean;

    trigger OnOpenPage()
    begin
        RedRegShowGenerateAction := Rec.RedRegShowGenerate();
    end;
}