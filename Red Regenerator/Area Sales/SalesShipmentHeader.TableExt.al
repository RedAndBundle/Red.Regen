namespace Red.Regenerator;
using Microsoft.Sales.History;
using Microsoft.Purchases.Document;
tableextension 70626 "Red Reg Sales Shipment Header" extends "Sales Shipment Header"
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
        field(70615; "Red Reg Purchase Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Contract No.';
        }
        field(70616; "Red Reg Purch. Document Type"; Enum "Purchase Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Document Type';
        }
        field(70617; "Red Reg Purch. Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Document No.';
        }
    }
}