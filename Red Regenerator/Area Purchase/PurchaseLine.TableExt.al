tableextension 11311116 "Red Reg Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(11311113; "Red Reg Org. Document Type"; Enum "Purchase Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Type';
        }
        field(11311114; "Red Reg Org. Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document No.';
        }
        field(11311115; "Red Reg Org. Document Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Line No.';
        }

        field(11311116; "Red Reg Org. Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment No.';
        }
        field(11311117; "Red Reg Org. Shipment Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment Line No.';
        }
        field(11311118; "Red Reg Contract No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
        }
        field(11311119; "Red Reg Contract Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Line No.';
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