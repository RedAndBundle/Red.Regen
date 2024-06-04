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
            Caption = 'No. Series Sales';
            ToolTip = 'Specifies the number series that will be used for sales objects.';
            TableRelation = "No. Series";
        }
        field(3; "No. Series Purchase"; Code[20])
        {
            Caption = 'No. Series Purchase';
            ToolTip = 'Specifies the number series that will be used for purchase objects.';
            TableRelation = "No. Series";
        }
        // TODO
        // Regenerate via job queue
        // Regenerate via batch job
        // Archive Sales Contracts
        // Archive Purchase Contracts
        // Sales Contract Report no
        // Purchase Contract Report no
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    internal procedure InitSetup()
    begin
        if Get() then
            exit;

        Init();
        Insert();
    end;

    internal procedure GetSalesNoSeriesCode(): Code[20]
    begin
        Get();
        TestField("No. Series Sales");
        exit("No. Series Sales");
    end;

    internal procedure JobQueueSalesActive(): Boolean
    var
    // p: Page "Sales Order List";
    begin

    end;
}