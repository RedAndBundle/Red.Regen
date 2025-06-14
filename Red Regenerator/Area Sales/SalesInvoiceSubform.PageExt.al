namespace Red.Regenerator;
using Microsoft.Sales.Document;
using System.Security.User; pageextension 11311121 "Red Reg Sales Invoice Subform" extends "Sales Invoice Subform"

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