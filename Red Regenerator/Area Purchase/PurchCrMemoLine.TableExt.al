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