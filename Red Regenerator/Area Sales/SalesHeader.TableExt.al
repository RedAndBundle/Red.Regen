tableextension 11311113 "Red Reg Sales Header" extends "Sales Header"
{
    fields
    {
        field(11311113; "Red Reg Org. Document Type"; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Type';
        }
        field(11311114; "Red Reg Org. Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document No.';
        }
        field(11311116; "Red Reg Org. Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment No.';
        }
        field(11311118; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
        }
        field(11311120; "Red Reg Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group';
            TableRelation = "Red Reg Contract Group";
            ToolTip = 'Specifies the group that the sales contract belongs to.';
        }
        field(11311121; "Red Reg Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
            ToolTip = 'Specifies the date that the contract has started.';

            trigger OnValidate()
            begin
                RedRegCalculateDates();
            end;
        }
        field(11311122; "Red Reg End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
            ToolTip = 'Specifies the date when the contract will end.';
            Editable = false;
        }
        field(11311123; "Red Reg Duration"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Duration';
            ToolTip = 'Specifies the duration of the contract. If left empty, the contract is valid indefinetely.';

            trigger OnValidate()
            begin
                RedRegCalculateDates();
            end;
        }
        field(11311124; "Red Reg Billing Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Period';
            ToolTip = 'Specifies the billing period of the contract.';

            trigger OnValidate()
            begin
                RedRegCalculateBillingPeriod();
            end;
        }
        field(11311125; "Red Reg Next Billing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Billing Date';
            ToolTip = 'Specifies the date of the next billing.';
            Editable = false;
        }
        field(11311126; "Red Reg Contract Status"; Enum "Red Reg Contract Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Status';
            ToolTip = 'Specifies the status of the contract.';
            Editable = false;
        }
    }

    keys
    {
        key("Red Reg Generator"; "Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration")
        {
        }
    }

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

        "Red Reg End Date" := CalcDate("Red Reg Duration", "Red Reg Start Date");

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
    end;

    internal procedure RedRegAccept()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        TestModifyAllowed();
        TestField("Red Reg Start Date");
        TestField("Red Reg Billing Period");
        if "Red Reg Next Billing Date" = 0D then
            "Red Reg Next Billing Date" := "Red Reg Start Date";
        Regenerator.CreateSalesDocument(Rec);
        "Red Reg Contract Status" := "Red Reg Contract Status"::Accepted;
        Modify(true);
    end;

    internal procedure RedRegClose()
    begin
        // Test open sales documents
        // Test contract end date
        "Red Reg Contract Status" := "Red Reg Contract Status"::Closed;
    end;

    internal procedure RedRegCancel()
    begin
        // Test open sales documents
        "Red Reg Contract Status" := "Red Reg Contract Status"::Canceled;
    end;

    internal procedure RedRegenerate()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Regenerator.CreateSalesDocument(Rec);
    end;

    internal procedure RedRegenerateAndPost()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Regenerator.CreateSalesDocument(Rec);
        // TODO Post
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

    internal procedure RedRegShowClose(): Boolean
    begin
        exit("Red Reg Contract Status" in ["Red Reg Contract Status"::Expired]);
    end;

    internal procedure RedRegShowCancel(): Boolean
    begin
        exit("Red Reg Contract Status" in ["Red Reg Contract Status"::Accepted, "Red Reg Contract Status"::Active]);
    end;

    local procedure TestModifyAllowed()
    var
        NotAllowedErr: Label 'You can only change or activate the contract when the status is concept or expired.';
    begin
        if not ("Red Reg Contract Status" in ["Red Reg Contract Status"::Concept, "Red Reg Contract Status"::Expired]) then
            Error(NotAllowedErr);
    end;
}