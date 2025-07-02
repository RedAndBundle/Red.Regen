namespace Red.Regenerator;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Document;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Projects.Resources.Resource;

table 70651 "Red Reg Sales Item Contract"
{
    Caption = 'Item Contract';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';
            ToolTip = 'Specifies for which line type the item line is created. Item takes precedence over Item Category.';
            ValuesAllowed = 1, 2, 3;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies for which source number the item line is created.';
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
        field(4; "Template Type"; Enum "Sales Line Type")
        {
            Caption = 'Template Type';
            ToolTip = 'Specifies the Template Type.';
            ValuesAllowed = 1, 2, 3;

            trigger OnValidate()
            begin
                "Template No." := '';
            end;
        }
        field(5; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            ToolTip = 'Specifies the Template No.';
            TableRelation = "Red Reg Sales Contr. Template"."No." where(Type = field("Template Type"));
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the item description.';
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            ToolTip = 'Specifies the second item description.';
        }
        field(12; "Template Description"; Text[100])
        {
            Caption = 'Template Description';
            ToolTip = 'Specifies the description of the template.';
            FieldClass = FlowField;
            CalcFormula = lookup("Red Reg Sales Contr. Template"."Description" where(Type = field("Template Type"), "No." = field("Template No.")));
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Template Type", "Template No.")
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