
table 11311117 "Red Reg Generator"
{
    Caption = 'Create Contract';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Application Area"; Enum "Red Reg Application Area")
        {
            Caption = 'Document Type';
            // ToolTip = 'Specifies fror which application area the contract is created.';
        }
        field(2; "Document Type"; Enum "Red Reg Document Type")
        {
            Caption = 'Document Type';
            // ToolTip = 'Specifies from which document type the contract is created. When a line from the selected document type is shipped a contract will be created. Type any takes precedent over other types.';
        }
        field(3; Type; Enum "Red Reg Create Contract Type")
        {
            Caption = 'Type';
            // ToolTip = 'Specifies fror which line type the contract is created. Item takes precedence over Item Category.';
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            // ToolTip = 'Specifies fror which source number the contract is created.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const(Item)) Item where(Blocked = const(false), "Sales Blocked" = const(false))
            else
            if (Type = const("Item Category")) "Item Category";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                case Type of
                    Type::"G/L Account":
                        CopyFromGLAccount();
                    Type::Item:
                        CopyFromItem();
                    Type::Resource:
                        CopyFromResource();
                    Type::"Item Category":
                        CopyFromItemCategory();
                end;
            end;
        }
        field(5; "Generation Moment"; Enum "Red Reg Generation Moments")
        {
            Caption = 'Generation Moment';
            // ToolTip = 'Specifies when the contract is generated. This can be automatically or manual.';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            // ToolTip = 'Specifies the description of the contract.';
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            // ToolTip = 'Specifies the second description of the contract.';
        }
        field(12; "Contract Group"; Code[20])
        {
            Caption = 'Contract Group';
            // ToolTip = 'Specifies the settings of the contract that will be created.';
            DataClassification = CustomerContent;
            TableRelation = "Red Reg Contract Group";
        }
        field(13; Duration; DateFormula)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
            // ToolTip = 'Specifies the duration of the contract in a date formula. If you do not specify a duration you must set one manually after the contract is generated.';
        }
        field(14; "Red Reg Billing Period"; DateFormula)
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Period';
            // ToolTip = 'Specifies the billing period of the contract. If you do not specify a billing period the contract duration is used.';
        }
    }

    keys
    {
        key(Key1; "Application Area", "Document Type", Type, "No.")
        {
            Clustered = true;
        }
    }

    local procedure CopyFromGLAccount()
    var
        GLAccout: Record "G/L Account";
    begin
        GLAccout.Get("No.");
        GLAccout.CheckGLAcc();
        GLAccout.TestField("Direct Posting", true);
        Description := GLAccout.Name;
    end;

    local procedure CopyFromItem()
    var
        Item: Record Item;
        SalesBlockedErr: Label 'You cannot sell %1 %2 because the %3 check box is selected on the %1 card.', Comment = '%1 - Table Caption (Item), %2 - Item No., %3 - Field Caption';
    begin
        Item.Get("No.");
        Item.TestField(Blocked, false);
        Item.TestField("Gen. Prod. Posting Group");
        if Item."Sales Blocked" then
            Error(SalesBlockedErr, Item.TableCaption(), Item."No.", Item.FieldCaption("Sales Blocked"));

        if Item.Type = Item.Type::Inventory then
            Item.TestField("Inventory Posting Group");

        Description := Item.Description;
        "Description 2" := Item."Description 2";
    end;

    local procedure CopyFromResource()
    var
        Resource: Record Resource;
    begin
        Resource.Get("No.");
        Resource.CheckResourcePrivacyBlocked(false);
        Resource.TestField(Blocked, false);
        Description := Resource.Name;
        "Description 2" := Resource."Name 2";
    end;

    local procedure CopyFromItemCategory()
    var
        ItemCategory: Record "Item Category";
    begin
        ItemCategory.Get("No.");
        Description := ItemCategory.Description;
    end;
}