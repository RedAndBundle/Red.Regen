namespace Red.Regenerator;
using Microsoft.Purchases.History;
tableextension 11311128 "Red Reg Purch. Rcpt. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(11311118; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
        }
        field(11311119; "Red Reg Contract Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Line No.';
        }
        field(11311120; "Red Reg Sales Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract No.';
        }
        field(11311121; "Red Reg Sales Contract Ln. No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract Line No.';
        }
    }
}