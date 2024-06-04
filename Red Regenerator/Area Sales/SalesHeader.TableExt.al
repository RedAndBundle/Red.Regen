tableextension 11311113 "Red Reg Sales Header" extends "Sales Header"
{
    fields
    {
        field(11311113; "Red Reg Org. Document Type"; Enum "Red Reg Document Type")
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
                CalculateDates();
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
            ToolTip = 'Specifies the duration of the contract.';

            trigger OnValidate()
            begin
                CalculateDates();
            end;
        }
    }

    local procedure CalculateDates()
    var
        EmpptyDateFormula: DateFormula;
    begin
        case true of
            "Red Reg Start Date" = 0D,
            "Red Reg Duration" = EmpptyDateFormula:
                exit;
        end;

        "Red Reg End Date" := CalcDate("Red Reg Duration", "Red Reg Start Date");
    end;

    internal procedure Regenerate()
    begin

    end;

    internal procedure RegenerateAndPost()
    begin

    end;

    internal procedure SendContract()
    begin

    end;

    internal procedure PrintContract()
    begin

    end;
}