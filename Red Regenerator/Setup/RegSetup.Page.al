page 11311113 "Red Reg Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Red Reg Setup";

    layout
    {
        area(Content)
        {
            group(NoSeries)
            {
                Caption = 'No. Series';
                field(NoSeriesSales; Rec."No. Series Sales")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series that will be used for sales objects.';
                }
                field(NoSeriesPurchase; Rec."No. Series Purchase")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series that will be used for purchase objects.';
                }
            }
            group(General)
            {

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}