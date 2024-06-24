tableextension 11311124 "Red Reg Purch. Cr. Memo Line" extends "Purch. Cr. Memo Line"
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