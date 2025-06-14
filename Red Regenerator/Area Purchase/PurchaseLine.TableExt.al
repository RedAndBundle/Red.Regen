namespace Red.Regenerator;
using Microsoft.Purchases.Document;
tableextension 11311116 "Red Reg Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(11311113; "Red Reg Org. Document Type"; Enum "Purchase Document Type")
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
        field(11311115; "Red Reg Org. Document Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Line No.';
            // Used for linking the contract to a sales document when you created the contract from the sales document through the Generator.
            // Unused when creating a document through the Regenerator.
        }

        field(11311116; "Red Reg Org. Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment No.';
            // TODO obsolete when creating a contract through release or manual. Delete?
        }
        field(11311117; "Red Reg Org. Shipment Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment Line No.';
            // TODO obsolete when creating a contract through release or manual. Delete?
        }
        field(11311118; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
            // Used for linking the sales document to a contract when you created the document from the contract through the Regenerator.
            // Unused when creating a contract through the Generator.
        }
        field(11311119; "Red Reg Contract Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Line No.';
            // Used for linking the sales document to a contract when you created the document from the contract through the Regenerator.
            // Unused when creating a contract through the Generator.
        }
        field(11311120; "Red Reg Sales Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract No.';
        }
        field(11311121; "Red Reg Sales Contract Ln. No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Contract Line No.';
        }
        field(11311122; "Red Reg Generates Contract"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Red Reg Purch. Contr. Template" where(Type = field("Type"), "No." = field("No.")));
            Caption = 'Generates Contract';
            ToolTip = 'Specifies whether this line generates a contract when the document is posted.';
        }
    }

    internal procedure RedRegInitNewLine(PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        "Document Type" := PurchaseHeader."Document Type";
        "Document No." := PurchaseHeader."No.";

        PurchaseLine.SetRange("Document Type", "Document Type");
        PurchaseLine.SetRange("Document No.", "Document No.");
        if PurchaseLine.FindLast() then
            "Line No." := PurchaseLine."Line No."
        else
            "Line No." := 0;

        "Line No." += 10000;
    end;
}