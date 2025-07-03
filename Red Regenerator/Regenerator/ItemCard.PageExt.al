namespace Red.Regenerator;
using Microsoft.Inventory.Item;
pageextension 70640 "Red REgItem Card" extends "Item Card"
{
    layout
    {
        addlast("Prices & Sales")
        {
            field("Red Reg Sales Item Contracts"; Rec."Red Reg Sales Item Contracts")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = true;
                DrillDownPageId = "Red Reg Sales Item Contracts";
            }
            field("Red Reg Sales Templates"; Rec."Red Reg Sales Templates")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = true;
                DrillDownPageId = "Red Reg Sales Contr. Templates";
            }
        }
        addlast(Replenishment)
        {
            field("Red Reg Purchase Templates"; Rec."Red Reg Purchase Templates")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = true;
                DrillDownPageId = "Red Reg Purch. Contr Templates";
            }
        }
    }
}