page 70664 "Red Reg Archive Reason Codes"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Contract Archive Reason Codes';
    PageType = List;
    SourceTable = "Red Reg Archive Reason Code";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(repeater)
            {
                ShowCaption = false;
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document type for which the reason will be used.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a reason code to attach to the entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description for de reason.';
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
}

