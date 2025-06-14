namespace Red.Regenerator;
using Microsoft.Sales.History;
using Microsoft.Purchases.Document;
tableextension 11311121 "Red Reg Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
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
            // ToolTip = 'Specifies the group that the sales contract belongs to.';
        }
        field(11311121; "Red Reg Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
            // ToolTip = 'Specifies the date that the contract has started.';
        }
        field(11311122; "Red Reg End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
            // ToolTip = 'Specifies the date when the contract will end.';
        }
        field(11311123; "Red Reg Duration"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Duration';
            // ToolTip = 'Specifies the duration of the contract.';
        }
        field(11311128; "Red Reg Purchase Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Contract No.';
        }
        field(11311129; "Red Reg Purch. Document Type"; Enum "Purchase Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Document Type';
        }
        field(11311130; "Red Reg Purch. Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase Document No.';
        }
    }
}