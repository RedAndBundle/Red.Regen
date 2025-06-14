namespace Red.Regenerator;
using Microsoft.Sales.Document;
page 11311123 "Red Reg Sls Item Contract Sel"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Red Reg Sales Item Contract";
    Caption = 'Choose Item Contract';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(SalesLine)
            {
                Caption = 'Sales Line';

                field(SalesLineType; SalesLine.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the type of the source sales line.';
                    Editable = false;
                }
                field(SalesLineNo; SalesLine."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the source sales line.';
                    Editable = false;
                }
                field(SalesLineDescription; SalesLine.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the source sales line.';
                    Editable = false;
                }
                field(SalesLineDescription2; SalesLine."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies the second description of the source sales line.';
                    Editable = false;
                    Visible = false;
                }
                field(SalesLineQuantity; SalesLine.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Original Quantity';
                    ToolTip = 'Specifies the quantity of the source sales line.';
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Contract Quantity';
                    ToolTip = 'Specifies the quantity to select for the contract.';
                    Editable = true;
                    MinValue = 0;
                    DecimalPlaces = 0 : 5;
                }
                field(SalesLineUnitOfMeasure; SalesLine."Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Unit of Measure';
                    ToolTip = 'Specifies the unit of measure of the source sales line.';
                    Editable = false;
                }
            }
            repeater(repeater)
            {
                // field(Type; Rec.Type)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies for which line type the contract is created. Item takes precedence over Item Category.';
                //     Editable = false;
                // }
                // field("No."; Rec."No.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies for which source number the contract is created.';
                //     Editable = false;
                // }
                // field("Description"; Rec.Description)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the description of the contract.';
                //     Editable = false;
                // }
                field("Template Type"; Rec."Template Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which line type the contract is created. Item takes precedence over Item Category.';
                    ValuesAllowed = "G/L Account", "Item", "Resource";
                    Editable = false;
                }
                field("Template No."; Rec."Template No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies for which source number the contract is created.';
                    Editable = false;
                }
                field("Template Description"; Rec."Template Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the template.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action(ActionName)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin

            //     end;
            // }
        }
    }

    var
        SalesLine: Record "Sales Line";
        Quantity: Decimal;

    internal procedure SetSourceSalesLine(NewSalesLine: Record "Sales Line")
    begin
        SalesLine := NewSalesLine;
        Quantity := SalesLine.Quantity;
    end;

    internal procedure GetQuantity(): Decimal
    begin
        exit(Quantity);
    end;
}