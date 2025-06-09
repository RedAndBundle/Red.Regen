tableextension 11311113 "Red Reg Sales Header" extends "Sales Header"
{
    fields
    {
        field(11311113; "Red Reg Org. Document Type"; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Type';
            // Used for linking the contract to a sales document when you created the contract from the sales document through the Generator.
            // Unused when creating a document through the Regenerator.
        }
        field(11311114; "Red Reg Org. Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document No.';
            // Used for linking the contract to a sales document when you created the contract from the sales document through the Generator.
            // Unused when creating a document through the Regenerator.
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
            // Used for linking the sales document to a contract when you created the document from the contract through the Regenerator.
            // Unused when creating a contract through the Generator.
        }
        field(11311120; "Red Reg Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group';
            TableRelation = "Red Reg Contract Group";
            // ToolTip = 'Specifies the group that the sales contract belongs to.';
        }
        field(11311121; "Red Reg Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
            // ToolTip = 'Specifies the date that the contract has started.';

            trigger OnValidate()
            begin
                RedRegCalculateDates();
            end;
        }
        field(11311122; "Red Reg End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
            // ToolTip = 'Specifies the date when the contract will end.';
            Editable = false;
        }
        field(11311123; "Red Reg Duration"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Duration';
            // ToolTip = 'Specifies the duration of the contract. If left empty, the contract is valid indefinetely.';
            // TODO must be able to be blank if contract is valid indefinitely

            trigger OnValidate()
            begin
                RedRegCalculateDates();
            end;
        }
        field(11311124; "Red Reg Billing Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Period';
            // ToolTip = 'Specifies the billing period of the contract.';

            trigger OnValidate()
            begin
                RedRegCalculateBillingPeriod();
            end;
        }
        field(11311125; "Red Reg Next Billing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Next Billing Date';
            // ToolTip = 'Specifies the date of the next billing.';
            Editable = false;
        }
        field(11311126; "Red Reg Contract Iteration"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Iteration';
            // ToolTip = 'Specifies how many times the contract has been billed.';
            Editable = false;
        }
        field(11311127; "Red Reg Contract Status"; Enum "Red Reg Contract Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Status';
            // ToolTip = 'Specifies the status of the contract.';
            Editable = false;
        }
        field(11311128; "Red Reg Has Purchase Contract"; Boolean)
        {
            Caption = 'Has Purchase Contract';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Header" where("Document Type" = const("Red Regenerator"), "Red Reg Sales Contract No." = field("No.")));
        }
    }

    keys
    {
        key("Red Reg Contract Template"; "Red Reg Org. Document Type", "Red Reg Org. Document No.", "Red Reg Org. Shipment No.", "Red Reg Group", "Red Reg Duration")
        {
        }
    }

    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
        // TODO cannot modify active contract, cannot change document + posting date if sales doc is linked to a contract
    end;

    trigger OnDelete()
    begin
        // TODO cannot modify active contract, cannot change document + posting date if sales doc is linked to a contract
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

        Regenerator.RegenerateSalesDocument(Rec);
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
    begin
        // Test open sales documents
        // Test contract end date
        "Red Reg Contract Status" := "Red Reg Contract Status"::Closed;
        RedRegArchive();
    end;

    internal procedure RedRegCancel()
    begin
        // Test open sales documents
        "Red Reg Contract Status" := "Red Reg Contract Status"::Canceled;
        RedRegArchive();
    end;

    local procedure RedRegArchive()
    var
        // p: page "Sales Quote";
        ArchiveManagement: Codeunit "ArchiveManagement";
    begin
        // TODO archive contract
        ArchiveManagement.ArchiveSalesDocument(Rec);
    end;

    internal procedure RedRegenerate()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Regenerator.RegenerateSalesDocument(Rec);
    end;

    internal procedure RedRegenerateAndPost()
    var
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Regenerator.RegenerateSalesDocument(Rec);
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
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if "Red Reg Contract Status" <> "Red Reg Contract Status"::Accepted then
            exit(false);

        SalesInvoiceHeader.SetRange("Red Reg Contract No.", "No.");
        exit(not SalesInvoiceHeader.IsEmpty());
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

    local procedure TestModifyAllowed()
    var
        NotAllowedErr: Label 'You can only change or activate the contract when the status is concept or expired.';
    begin
        if not ("Red Reg Contract Status" in ["Red Reg Contract Status"::Concept, "Red Reg Contract Status"::Expired]) then
            Error(NotAllowedErr);
    end;

    internal procedure GenerateContractItems()
    var
        SalesLine: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        SalesDocument: Codeunit "Red Reg Sales Document";
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        if SalesLine.FindSet() then
            repeat
                SalesDocument.GenerateContractDocumentLine(TempSalesLine, SalesLine);
            until SalesLine.Next() = 0;

        if TempSalesLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine := TempSalesLine;
                SalesLine.Insert();
            until TempSalesLine.Next() = 0;
    end;
}