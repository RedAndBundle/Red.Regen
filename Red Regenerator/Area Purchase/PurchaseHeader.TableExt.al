namespace Red.Regenerator;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Archive;
using Microsoft.Utilities;
using Microsoft.Sales.Document;
using Microsoft.Purchases.History;
tableextension 70602 "Red Reg Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(70600; "Red Reg Org. Document Type"; Enum "Purchase Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Type';
            // Used for linking the contract to a sales document when you created the contract from the sales document through the Generator.
            // Unused when creating a document through the Regenerator.
        }
        field(70601; "Red Reg Org. Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document No.';
            // Used for linking the contract to a sales document when you created the contract from the sales document through the Generator.
            // Unused when creating a document through the Regenerator.
        }
        field(70603; "Red Reg Org. Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment No.';
            // TODO obsolete when creating a contract through release or manual. Delete?
        }
        field(70605; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
            // Used for linking the sales document to a contract when you created the document from the contract through the Regenerator.
            // Unused when creating a contract through the Generator.
        }
        field(70607; "Red Reg Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group';
            TableRelation = "Red Reg Contract Group";
            // ToolTip = 'Specifies the group that the Purchase contract belongs to.';
        }
        field(70608; "Red Reg Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
            // ToolTip = 'Specifies the date that the contract has started.';

            trigger OnValidate()
            begin
                RedRegCalculateDates();
            end;
        }
        field(70609; "Red Reg End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
            // ToolTip = 'Specifies the date when the contract will end.';
            Editable = false;
            // TODO must be able to be blank if contract is valid indefinitely
        }
        field(70610; "Red Reg Duration"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Duration';
            // ToolTip = 'Specifies the duration of the contract. If left empty, the contract is valid indefinetely.';

            trigger OnValidate()
            begin
                RedRegCalculateDates();
            end;
        }
        field(70611; "Red Reg Billing Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Period';
            // ToolTip = 'Specifies the billing period of the contract.';

            trigger OnValidate()
            begin
                RedRegCalculateBillingPeriod();
            end;
        }
        field(70612; "Red Reg Next Billing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Billing Date';
            // ToolTip = 'Specifies the date of the next billing.';
            Editable = false;
        }
        field(70613; "Red Reg Contract Iteration"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Iteration';
            // ToolTip = 'Specifies how many times the contract has been billed.';
            Editable = false;
        }
        field(70614; "Red Reg Contract Status"; Enum "Red Reg Contract Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Status';
            // ToolTip = 'Specifies the status of the contract.';
            Editable = false;
        }
        field(70615; "Red Reg Sales Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract No.';
        }
        field(70616; "Red Reg Sales Document Type"; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Document Type';
        }
        field(70617; "Red Reg Sales Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Document No.';
        }
        field(70619; "Red Reg Work Description"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Work Description';
        }
    }

    keys
    {
        key("Red Reg Contract Template"; "Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration")
        {
        }
    }

    trigger OnDelete()
    begin
        // TODO cannot delete active contract
        // TODO reset iteration and next billing date if Purchase doc is linked to a contract
    end;

    trigger OnModify()
    begin
        // TODO cannot modify active contract
        // TODO cannot change document + posting date if Purchase doc is linked to a contract
    end;

    local procedure RedRegCalculateDates()
    var
        EmptyDateFormula: DateFormula;
    begin
        TestModifyAllowed();
        "Red Reg End Date" := 0D;

        case true of
            "Red Reg Start Date" = 0D:
                exit;
        end;

        if "Red Reg Duration" = EmptyDateFormula then
            exit;

        "Red Reg End Date" := CalcDate('<-1D>', CalcDate("Red Reg Duration", "Red Reg Start Date"));

        if "Red Reg Billing Period" <> EmptyDateFormula then
            exit;

        Validate("Red Reg Billing Period", "Red Reg Duration");
    end;

    local procedure RedRegCalculateBillingPeriod()
    var
        EmptyDateFormula: DateFormula;
    begin
        if "Red Reg Billing Period" = EmptyDateFormula then begin
            "Red Reg Next Billing Date" := 0D;
            exit;
        end;
    end;

    internal procedure RedRegCalculateNextBillingDate()
    begin
        TestField("Red Reg Billing Period");
        if "Red Reg Next Billing Date" = 0D then
            "Red Reg Next Billing Date" := "Red Reg Start Date"
        else
            "Red Reg Next Billing Date" := CalcDate("Red Reg Billing Period", "Red Reg Next Billing Date");

        if "Red Reg Next Billing Date" <= "Red Reg End Date" then
            exit;

        "Red Reg Next Billing Date" := 0D;
        "Red Reg Contract Status" := "Red Reg Contract Status"::Expired;
    end;

    internal procedure RedRegAccept()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        TestModifyAllowed();
        TestField("Red Reg Start Date");
        TestField("Red Reg Billing Period");
        TestField("Red Reg Group");
        if "Red Reg Next Billing Date" = 0D then
            "Red Reg Next Billing Date" := "Red Reg Start Date";

        Regenerator.RegeneratePurchaseDocument(Rec);
        "Red Reg Contract Status" := "Red Reg Contract Status"::Accepted;
        Modify(true);
    end;

    internal procedure RedRegActivate()
    begin
        if not RedRegShowActivate() then
            exit;

        "Red Reg Contract Status" := "Red Reg Contract Status"::Active;
        Modify();
    end;

    internal procedure RedRegTestContractActive(): Boolean
    var
        ContractExpiredErr: Label '%1 is greater than %2.', Comment = '%1 = next billing date, %2 = end date.';
    begin
        TestField("Red Reg Next Billing Date");

        if "Red Reg Next Billing Date" > "Red Reg End Date" then
            Error(ContractExpiredErr, FieldCaption("Red Reg Next Billing Date"), FieldCaption("Red Reg End Date"));
    end;

    internal procedure RedRegTestStatusIsActive()
    var
        ContractInactiveErr: Label 'Contract status must not be %1.', Comment = '%1 = status';
    begin
        if "Red Reg Contract Status" in ["Red Reg Contract Status"::Expired, "Red Reg Contract Status"::Closed, "Red Reg Contract Status"::Canceled] then
            Error(ContractInactiveErr, "Red Reg Contract Status");
    end;

    internal procedure RedRegClose()
    var
        Setup: Record "Red Reg Setup";
    begin
        // Test open Purchase documents
        // Test contract end date
        "Red Reg Contract Status" := "Red Reg Contract Status"::Closed;
        Setup.Get();
        case Setup."Action on Close" of
            Setup."Action on Close"::Archive:
                RedRegArchive();
            Setup."Action on Close"::"Archive and delete":
                begin
                    RedRegArchive();
                    Delete(true);
                end;
        end;
    end;

    internal procedure RedRegCancel()
    var
        Setup: Record "Red Reg Setup";
    begin
        "Red Reg Contract Status" := "Red Reg Contract Status"::Canceled;
        Setup.Get();
        case Setup."Action on Cancel" of
            Setup."Action on Cancel"::Archive:
                RedRegArchive();
            Setup."Action on Cancel"::"Archive and delete":
                begin
                    if not Setup."Archive Purchase Contracts" then
                        RedRegArchive();

                    Delete(true);
                end;
        end;
    end;

    local procedure RedRegArchive()
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        ArchiveManagement.StorePurchDocument(Rec, false);
    end;

    internal procedure RedRegAutoArchive(): Boolean
    var
        Setup: Record "Red Reg Setup";
    begin
        if this."Document Type" <> this."Document Type"::"Red Regenerator" then
            exit(false);

        if not Setup.Get() then
            exit(false);

        if Setup."Archive Purchase Contracts" then
            RedRegArchive();

        exit(true);
    end;

    internal procedure RedRegenerate()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Regenerator.RegeneratePurchaseDocument(Rec);
    end;

    internal procedure RedRegenerateAndPost()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Regenerator.RegeneratePurchaseDocument(Rec);
        // TODO Post
    end;

    internal procedure RedRegRenew()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Regenerator.RenewContract(Rec);
    end;

    internal procedure RedRegSendContract()
    begin

    end;

    internal procedure RedRegPrintContract()
    begin

    end;

    internal procedure RedRegShowAccept(): Boolean
    begin
        exit("Red Reg Contract Status" in ["Red Reg Contract Status"::Concept, "Red Reg Contract Status"::Expired]);
    end;

    internal procedure RedRegShowActivate(): Boolean
    var
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
    begin
        if "Red Reg Contract Status" = "Red Reg Contract Status"::AutoGenerated then
            exit(true);

        if "Red Reg Contract Status" <> "Red Reg Contract Status"::Accepted then
            exit(false);

        PurchaseInvoiceHeader.SetRange("Red Reg Contract No.", "No.");
        exit(not PurchaseInvoiceHeader.IsEmpty());
    end;

    internal procedure RedRegShowClose(): Boolean
    begin
        exit("Red Reg Contract Status" in ["Red Reg Contract Status"::Expired]);
    end;

    internal procedure RedRegShowCancel(): Boolean
    begin
        exit("Red Reg Contract Status" in ["Red Reg Contract Status"::Accepted, "Red Reg Contract Status"::Active]);
    end;

    internal procedure RedRegShowRegenerate(): Boolean
    begin
        exit("Red Reg Contract Status" in ["Red Reg Contract Status"::Active]);
    end;

    internal procedure RedRegShowRenew(): Boolean
    begin
        exit("Red Reg Contract Status" in ["Red Reg Contract Status"::Active, "Red Reg Contract Status"::Expired, "Red Reg Contract Status"::Closed]);
    end;

    // internal procedure RedRegShowGenerate(): Boolean
    // var
    //     Generator: Record "Red Reg Contract Template";
    //     Setup: Record "Red Reg Setup";
    // begin
    //     Generator.SetRange("Application Area", Generator."Application Area"::Purchase);
    //     if Generator.IsEmpty() then
    //         exit(false);

    //     if not Setup.Get() then
    //         exit(false);

    //     Generator.SetRange("Generation Moment", Generator."Generation Moment"::Manual);
    //     exit(not Generator.IsEmpty());
    // end;

    internal procedure RedRegSetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Red Reg Work Description");
        "Red Reg Work Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify();
    end;

    local procedure TestModifyAllowed()
    var
        NotAllowedErr: Label 'You can only change or activate the contract when the status is concept or expired.';
    begin
        if not ("Red Reg Contract Status" in ["Red Reg Contract Status"::Concept, "Red Reg Contract Status"::Expired, "Red Reg Contract Status"::AutoGenerated]) then
            Error(NotAllowedErr);
    end;
}