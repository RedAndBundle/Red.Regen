namespace Red.Regenerator;
using Microsoft.Sales.Document;
pageextension 70622 "Red Reg Sales Order Subform" extends "Sales Order Subform"

{
    layout
    {
        addlast(Control1)
        {
            field("Red Reg Generates Contract"; Rec."Red Reg Generates Contract")
            {
                ApplicationArea = All;
                Caption = 'Generates Contract';
                ToolTip = 'Specifies if the sales order generates a contract.';
                Editable = false;
            }
        }
    }
}