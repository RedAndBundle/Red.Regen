namespace Red.Regenerator;
using Microsoft.Sales.Document;
pageextension 11311117 "Red Reg Sales Invoice" extends "Sales Invoice"
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
}