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
        field(10; "No. Series Sales"; Code[20])
        {
            Caption = 'No. Series Sales';
            ToolTip = 'Specifies the number series that will be used for sales objects.';
            TableRelation = "No. Series";
        }
        field(11; "Suppress Sales Post Commit"; Boolean)
        {
            Caption = 'Suppress Sales Post Commit';
            ToolTip = 'Specifies if the sales post commit should be suppressed. Suppressing the commit ensures that the sales document cannot be posted without generating the new contract.';
        }
        field(20; "No. Series Purchase"; Code[20])
        {
            Caption = 'No. Series Purchase';
            ToolTip = 'Specifies the number series that will be used for purchase objects.';
            TableRelation = "No. Series";
        }
        field(21; "Suppress Purchase Post Commit"; Boolean)
        {
            Caption = 'Suppress Purchase Post Commit';
            ToolTip = 'Specifies if the purchase post commit should be suppressed. Suppressing the commit ensures that the purchase document cannot be posted without generating the new contract.';
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

    internal procedure TestSalesSetup()
    begin
        TestField("No. Series Sales");
    end;

    internal procedure TestPurchaseSetup()
    begin
        TestField("No. Series Purchase");
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