table 11311116 "Red Reg Sales Contract Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Red Reg Sales Contract Line';

    fields
    {

        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Red Reg Sales Contract Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Code[20])
        {
            Caption = 'Type';
            TableRelation = "Red Reg Sales Contract Header";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(11311113, "Unit Price"; Decimal)
        {
            Cap
        }
        // unit cost

        // discount
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }
}