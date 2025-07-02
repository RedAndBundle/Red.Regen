namespace Red.Regenerator;
using Microsoft.Sales.Archive;
using Microsoft.Sales.Document;
using Microsoft.Purchases.Document;
tableextension 70628 "Red Reg Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(70600; "Red Reg Org. Document Type"; Enum "Sales Document Type")
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
            // ToolTip = 'Specifies the group that the sales contract belongs to.';
        }
        field(70608; "Red Reg Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
            // ToolTip = 'Specifies the date that the contract has started.';
        }
        field(70609; "Red Reg End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
            // ToolTip = 'Specifies the date when the contract will end.';
            Editable = false;
        }
        field(70610; "Red Reg Duration"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Duration';
            // ToolTip = 'Specifies the duration of the contract. If left empty, the contract is valid indefinetely.';
            // TODO must be able to be blank if contract is valid indefinitely
        }
        field(70611; "Red Reg Billing Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Period';
            // ToolTip = 'Specifies the billing period of the contract.';
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
        field(70615; "Red Reg Has Purchase Contract"; Boolean)
        {
            Caption = 'Has Purchase Contract';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Header" where("Document Type" = const("Red Regenerator"), "Red Reg Sales Contract No." = field("No.")));
        }
    }
}