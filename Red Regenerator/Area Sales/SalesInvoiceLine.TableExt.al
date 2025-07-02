namespace Red.Regenerator;
using Microsoft.Sales.History;
tableextension 70625 "Red Reg Sales Invoice Line" extends "Sales Invoice Line"
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