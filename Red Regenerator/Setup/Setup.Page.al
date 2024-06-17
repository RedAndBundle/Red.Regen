page 11311113 "Red Reg Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Red Reg Setup";
    Caption = 'Regenerator Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Suppress Sales Post Commit"; Rec."Suppress Sales Post Commit")
                {
                    ApplicationArea = All;
                }
                field("Suppress Purchase Post Commit"; Rec."Suppress Purchase Post Commit")
                {
                    ApplicationArea = All;
                }
            }
            group(NoSeries)
            {
                Caption = 'No. Series';
                field(NoSeriesSales; Rec."No. Series Sales")
                {
                    ApplicationArea = All;
                }
                field(NoSeriesPurchase; Rec."No. Series Purchase")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action(ActionName)
    //         {
    //             ApplicationArea = All;

    //             trigger OnAction()
    //             begin

    //             end;
    //         }
    //     }
    // }
    trigger OnOpenPage()
    begin
        Rec.InitSetup();
    end;
}