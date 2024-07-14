page 11311114 "Red Reg Contract Groups"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Red Reg Contract Group";
    Caption = 'Contract Groups';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the contract group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the contract group.';
                }
                field("Regenerate Document Type"; Rec."Regenerate Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of regeneration for the contract group.';
                }
                field("Purchase Type"; Rec."Purchase Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of purchase document to generate.';
                }
            }
        }
    }
}