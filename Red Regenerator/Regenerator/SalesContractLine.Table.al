table 11311116 "Red Reg Sales Contract Line"
{
    DataClassification = CustomerContent;
    Caption = 'Red Reg Sales Contract Line';

    fields
    {

        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Red Reg Sales Contract Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Enum "Red Reg Contract Line Type")
        {
            Caption = 'Type';
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const(Item)) Item where(Blocked = const(false), "Sales Blocked" = const(false));
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
                end;
            end;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(11311113; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 0 : 5;
        }
        // unit cost

        // discount
    }

    keys
    {
        key(Key1; "Document No.")
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
}