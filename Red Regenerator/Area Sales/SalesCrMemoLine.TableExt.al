namespace Red.Regenerator;
using Microsoft.Sales.History;
tableextension 70623 "Red Reg Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
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