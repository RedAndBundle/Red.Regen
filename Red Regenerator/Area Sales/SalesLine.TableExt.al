namespace Red.Regenerator;
using Microsoft.Sales.Document;
tableextension 11311114 "Red Reg Sales Line" extends "Sales Line"
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
        field(11311120; "Red Reg Generates Contract"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Red Reg Sales Contr. Template" where(Type = field("Type"), "No." = field("No.")));
            Caption = 'Generates Contract';
            ToolTip = 'Specifies whether this line generates a contract when the document is released.';
        }
        field(11311130; "Red Reg Group"; Code[20])
        {
            Caption = 'Group';
            Editable = false;
            TableRelation = "Red Reg Contract Group";
            // ToolTip = 'Specifies the group that the sales contract belongs to.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Red Reg Group" where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(11311131; "Red Reg Start Date"; Date)
        {
            Caption = 'Start Date';
            Editable = false;
            // ToolTip = 'Specifies the date that the contract has started.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Red Reg Start Date" where("No." = field("Document No."), "Document Type" = field("Document Type")));

        }
        field(11311132; "Red Reg End Date"; Date)
        {
            Caption = 'End Date';
            // ToolTip = 'Specifies the date when the contract will end.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Red Reg End Date" where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(11311133; "Red Reg Duration"; DateFormula)
        {
            Caption = 'Duration';
            Editable = false;
            // ToolTip = 'Specifies the duration of the contract. If left empty, the contract is valid indefinetely.';
            // TODO must be able to be blank if contract is valid indefinitely
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Red Reg Duration" where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(11311134; "Red Reg Your Reference"; Text[100])
        {
            Caption = 'Your Reference';
            Editable = false;
            // ToolTip = 'Specifies the reference of the contract.';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Your Reference" where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
    }

    trigger OnInsert()
    begin
        // RedRegCreatePurchaseContract();
        // TODO fix does not work. Need some form of on after generate sales doc to create the purchase contracts
        // Move to accept procedure in sales contract
    end;

    trigger OnModify()
    begin
        // TODO cannot modify active contract, cannot change document + posting date if sales doc is linked to a contract
        // RedRegCreatePurchaseContract();
    end;

    trigger OnDelete()
    begin
        // TODO cannot modify active contract, cannot change document + posting date if sales doc is linked to a contract
        // RedRegCreatePurchaseContract();
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

    // local procedure RedRegCreatePurchaseContract()
    // var
    //     PurchaseGenerator: Codeunit "Red Reg Purchase Generator";
    // begin
    //     // TODO fix does not work. Need some form of on after generate sales doc to create the purchase contracts
    //     PurchaseGenerator.CreatePurchaseContractFromSalesLine(Rec);
    // end;

    // internal procedure RedRegAddContractLine()
    // var
    //     SalesDocument: Codeunit "Red Reg Sales Document";
    // begin
    //     SalesDocument.GenerateContractDocumentLine(Rec);
    // end;
}