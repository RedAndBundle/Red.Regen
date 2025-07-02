namespace Red.Regenerator;
page 70670 "Red Reg Setup"
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
            // TODO tegel op BC home pagina met contracten die gaan verlopen. + email mogelijkheid naar contract eigenaar.
            group(General)
            {
                field("Suppress Sales Post Commit"; Rec."Suppress Sales Post Commit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the sales post commit should be suppressed. Suppressing the commit ensures that the sales document cannot be posted without generating the new contract.';
                }
                field("Suppress Purchase Post Commit"; Rec."Suppress Purchase Post Commit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the purchase post commit should be suppressed. Suppressing the commit ensures that the purchase document cannot be posted without generating the new contract.';
                }
                // field("Red Reg Generate On"; Rec."Red Reg Generate On")
                // {
                //     ApplicationArea = All;
                // }
                // field("Allow Manual Generation"; Rec."Allow Manual Generation")
                // {
                //     ApplicationArea = All;
                // }
            }
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