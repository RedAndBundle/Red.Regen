table 11311114 "Red Reg Contract Group"
{
    DataClassification = ToBeClassified;
    Caption = 'Contract Group';
    LookupPageId = "Red Reg Contract Groups";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            // ToolTip = 'Specifies the code of the contract group.';
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
            // ToolTip = 'Specifies the description of the contract group.';
        }
        field(3; "Regenerate Document Type"; Enum "Red Reg Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Regenerate Type';
            // ToolTip = 'Specifies the type of regeneration for the contract group.';
            ValuesAllowed = 1, 2;
            InitValue = 2;
        }
        // TODO
        // Renew Automatically
        // Renew to document type
        // Renew days before end date
        // Invoice on regeneration
        // Post on regeneration
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}