namespace Red.Regenerator;
using Microsoft.Purchases.Document;
pageextension 70603 "Red Reg Purchase Order" extends "Purchase Order"
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