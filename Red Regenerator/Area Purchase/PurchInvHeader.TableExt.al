namespace Red.Regenerator;
using Microsoft.Purchases.History;
tableextension 70606 "Red Reg Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(70605; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
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
        }
        field(70610; "Red Reg Duration"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Duration';
            // ToolTip = 'Specifies the duration of the contract.';
        }
        field(70613; "Red Reg Contract Iteration"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Iteration';
            // ToolTip = 'Specifies how many times the contract has been billed.';
            Editable = false;
        }
        field(70615; "Red Reg Sales Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract No.';
        }
    }
}