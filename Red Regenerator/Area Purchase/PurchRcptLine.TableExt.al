namespace Red.Regenerator;
using Microsoft.Purchases.History;
tableextension 70609 "Red Reg Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
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
        field(70607; "Red Reg Sales Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract No.';
        }
        field(70608; "Red Reg Sales Contract Ln. No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract Line No.';
        }
    }
}