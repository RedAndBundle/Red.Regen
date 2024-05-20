table 11311113 "Red Reg Setup"
{
    DataClassification = OrganizationIdentifiableInformation;
    Caption = 'Red Regeneration Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';

        }
        field(2; "No. Series Sales"; Code[20]) /* check sales receivables for naming convention */
        {
        }
        field(3; "No. Series Purchase"; Code[20])
        {
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}