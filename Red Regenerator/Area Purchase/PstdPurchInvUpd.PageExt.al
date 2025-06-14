namespace Red.Regenerator;
using Microsoft.Purchases.History;
pageextension 11311119 "Red Reg Pstd Purch. Inv. Upd." extends "Posted Purch. Invoice - Update"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("Red Reg Contract No."; Rec."Red Reg Contract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Red Registration Contract No.';
            }
        }
    }
}