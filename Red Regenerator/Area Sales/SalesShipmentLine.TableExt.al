namespace Red.Regenerator;
using Microsoft.Sales.History;
tableextension 70627 "Red Reg Sales Shipment Line" extends "Sales Shipment Line"
{
    fields
    {
        field(70605; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
        }
        field(70606; "Red Reg Contract Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Line No.';
        }
    }
}