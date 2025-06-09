tableextension 11311130 "Red Reg Sales Line Archive" extends "Sales Line Archive"
{
    fields
    {
        // modify("No.")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         RedRegAddContractLine();
        //     end;
        // }
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
}