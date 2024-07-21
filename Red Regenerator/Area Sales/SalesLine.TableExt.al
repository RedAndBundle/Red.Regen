tableextension 11311114 "Red Reg Sales Line" extends "Sales Line"
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
            // Used for linking the sales document to a contract when you created the document from the contract through the Regenerator.
            // Unused when creating a contract through the Generator.
        }
        field(11311119; "Red Reg Contract Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Contract Line No.';
        }
    }

    trigger OnInsert()
    begin
        RedRegCreatePurchaseContract();
    end;

    trigger OnModify()
    begin
        // TODO cannot modify active contract, cannot change document + posting date if sales doc is linked to a contract
        RedRegCreatePurchaseContract();
    end;

    trigger OnDelete()
    begin
        // TODO cannot modify active contract, cannot change document + posting date if sales doc is linked to a contract
        RedRegCreatePurchaseContract();
    end;

    internal procedure RedRegInitNewLine(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        "Document Type" := SalesHeader."Document Type";
        "Document No." := SalesHeader."No.";

        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "Document No.");
        if SalesLine.FindLast() then
            "Line No." := SalesLine."Line No."
        else
            "Line No." := 0;

        "Line No." += 10000;
    end;

    local procedure RedRegCreatePurchaseContract()
    var
        PurchaseGenerator: Codeunit "Red Reg Purchase Generator";
    begin
        PurchaseGenerator.CreatePurchaseContractFromSalesLine(Rec);
    end;
}