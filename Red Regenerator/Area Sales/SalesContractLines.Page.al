namespace Red.Regenerator;
using Microsoft.Sales.Document;
page 11311125 "Red Reg Sales Contract Lines"
{
    Caption = 'Sales Contract Lines';
    DataCaptionFields = "Sell-to Customer No.";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    PageType = List;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = const("Red Regenerator"));
    CardPageId = "Red Reg Sales Contract";
    QueryCategory = 'Sales Contracts';
    RefreshOnActivate = true;
    AdditionalSearchTerms = 'Red Contracts, Licence, Warranty, Rental, contract list, contracts, contract overview, contract log, contract list, customer contracts';

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the contract.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the involved entry or record.';
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer.';
                }
                // field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                // {
                //     ApplicationArea = Basic, Suite;
                //     ToolTip = 'Specifies the name of the customer.';
                // }
                field("Red Reg Start Date"; Rec."Red Reg Start Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date that the contract has started.';
                }
                field("Red Reg End Date"; Rec."Red Reg End Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the contract will end.';
                }
                field("Red Reg Duration"; Rec."Red Reg Duration")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the duration of the contract. If left empty, the contract is valid indefinetely.';
                }
                field("Red Reg Group"; Rec."Red Reg Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the group that the Purchase contract belongs to.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the posting of the sales document will be recorded.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("Red Reg Org. Document No."; Rec."Red Reg Org. Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the original document number of the contract.';
                }
                field("Red Reg Org. Document Type"; Rec."Red Reg Org. Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the original document type of the contract.';
                }
                field("Red Reg Your Reference"; Rec."Red Reg Your Reference")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the reference of the contract.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = EditLines;
                    ShortCutKey = 'Return';
                    ToolTip = 'View or change detailed information about the customer.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        if not SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
                            exit;

                        SalesHeader.SetRecFilter();
                        Page.Run(Page::"Red Reg Sales Contract", Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            // action("Sales Reservation Avail.")
            // {
            //     ApplicationArea = Reservation;
            //     Caption = 'Sales Reservation Avail.';
            //     Image = "Report";
            //     //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
            //     //PromotedCategory = "Report";
            //     RunObject = Report "Sales Reservation Avail.";
            //     ToolTip = 'View, print, or save an overview of availability of items for shipment on sales documents, filtered on shipment status.';
            // }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Card_Promoted; ShowDocument)
                {
                }
            }
        }
    }
}

