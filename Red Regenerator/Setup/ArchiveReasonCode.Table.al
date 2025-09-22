table 70664 "Red Reg Archive Reason Code"
{
    Caption = 'Red Reg Archive Reason Code';
    LookupPageID = "Red Reg Archive Reason Codes";

    fields
    {
        field(1; "Document Type"; option)
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
            OptionMembers = "Sales","Purchase";
            OptionCaption = 'Sales,Purchase';
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Code")
        {
            Clustered = true;
        }
    }
}

