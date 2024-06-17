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
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Regenerate Document Type"; Rec."Regenerate Document Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}