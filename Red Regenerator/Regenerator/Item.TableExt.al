namespace Red.Regenerator;
using Microsoft.Inventory.Item;
tableextension 70640 "Red Reg Item" extends Item
{
    fields
    {
        field(70600; "Red Reg Purchase Templates"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Red Reg Purch. Contr. Template" where("No." = field("No."), Type = const(Item)));
            Caption = 'Purchase Contract Templates';
            ToolTip = 'Specifies the number of purchase contract templates that are linked to this item. Drill down for the list of templates.';
            Editable = false;
        }
        field(70610; "Red Reg Sales Templates"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Red Reg Sales Contr. Template" where("No." = field("No."), Type = const(Item)));
            Caption = 'Sales Contract Templates';
            ToolTip = 'Specifies the number of sales contract templates that are linked to this item. Drill down for the list of templates.';
            Editable = false;
        }
        field(70611; "Red Reg Sales Item Contracts"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Red Reg Sales Item Contract" where("No." = field("No."), Type = const(Item)));
            Caption = 'Sales Item Contracts';
            ToolTip = 'Specifies the number of sales item contracts that are linked to this item. Drill down for the list of contracts.';
            Editable = false;
        }
    }
}