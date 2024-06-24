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
    }
}