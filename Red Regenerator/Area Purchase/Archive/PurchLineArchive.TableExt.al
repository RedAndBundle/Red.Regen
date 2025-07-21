namespace Red.Regenerator;
using Microsoft.Purchases.Archive;
using Microsoft.Purchases.Document;
tableextension 70611 "Red Reg Purch. Line Archive" extends "Purchase Line Archive"
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
        field(70602; "Red Reg Org. Document Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Line No.';
            // Used for linking the contract to a sales document when you created the contract from the sales document through the Generator.
            // Unused when creating a document through the Regenerator.
        }

        field(70603; "Red Reg Org. Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment No.';
            // TODO obsolete when creating a contract through release or manual. Delete?
        }
        field(70604; "Red Reg Org. Shipment Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment Line No.';
            // TODO obsolete when creating a contract through release or manual. Delete?
        }
        field(70605; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
            // Used for linking the sales document to a contract when you created the document from the contract through the Regenerator.
            // Unused when creating a contract through the Generator.
        }
        field(70606; "Red Reg Contract Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Line No.';
            // Used for linking the sales document to a contract when you created the document from the contract through the Regenerator.
            // Unused when creating a contract through the Generator.
        }
        field(70607; "Red Reg Sales Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract No.';
        }
        field(70608; "Red Reg Sales Contract Ln. No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract Line No.';
        }
    }
}