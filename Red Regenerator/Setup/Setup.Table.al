namespace Red.Regenerator;
using Microsoft.Foundation.NoSeries;
table 70670 "Red Reg Setup"
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
            // ToolTip = 'Specifies the number series that will be used for sales objects.';
            TableRelation = "No. Series";
        }
        field(11; "Suppress Sales Post Commit"; Boolean)
        {
            Caption = 'Suppress Sales Post Commit';
            InitValue = true;
            // ToolTip = 'Specifies if the sales post commit should be suppressed. Suppressing the commit ensures that the sales document cannot be posted without generating the new contract.';
        }
        // field(12; "Red Reg Generate On"; Enum "Red Reg Generation Moments")
        // {
        //     DataClassification = CustomerContent;
        //     Caption = 'Generate On';
        //     // ToolTip = 'Specifies when the contract is generated. This can be automatically or manual.';
        // }
        // field(13; "Allow Manual Generation"; Boolean)
        // {
        //     Caption = 'Allow Manual Generation';
        //     // ToolTip = 'Specifies if the contracts can be generated manually.';
        // }
        field(20; "No. Series Purchase"; Code[20])
        {
            Caption = 'No. Series Purchase';
            // ToolTip = 'Specifies the number series that will be used for purchase objects.';
            TableRelation = "No. Series";
        }
        field(21; "Suppress Purchase Post Commit"; Boolean)
        {
            Caption = 'Suppress Purchase Post Commit';
            InitValue = true;
            // ToolTip = 'Specifies if the purchase post commit should be suppressed. Suppressing the commit ensures that the purchase document cannot be posted without generating the new contract.';
        }
        field(30; "Action on Close"; Option)
        {
            Caption = 'Action on Close';
            OptionCaption = ' ,Archive,Archive and delete';
            OptionMembers = " ",Archive,"Archive and delete";
            ToolTip = 'Specifies if you want to automatically archive sales contracts when closed.';
        }
        field(31; "Action on Cancel"; Option)
        {
            Caption = 'Action on Cancel';
            OptionCaption = ' ,Archive,Archive and delete';
            OptionMembers = " ",Archive,"Archive and delete";
            ToolTip = 'Specifies if you want to automatically archive sales contracts when canceled.';
        }
        // TODO
        // Regenerate via job queue
        // Regenerate via batch job
        // Archive Sales Contracts
        // Archive Purchase Contracts
        // Sales Contract Report no
        // Purchase Contract Report no
        // Regenerate days before end date
        // Post and send on regeneration
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    procedure InitSetup()
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

    internal procedure GetPurchaseNoSeriesCode(): Code[20]
    begin
        Get();
        TestField("No. Series Purchase");
        exit("No. Series Purchase");
    end;

    internal procedure JobQueueSalesActive(): Boolean
    var
    // p: Page "Purchase Order"
    begin

    end;
}