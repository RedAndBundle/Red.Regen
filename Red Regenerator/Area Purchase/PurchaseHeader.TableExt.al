tableextension 11311115 "Red Reg Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(11311114; "Red Reg Group"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Group';
            TableRelation = "Red Reg Contract Group";
        }
        field(11311115; "Red Reg Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(11311116; "Red Reg End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';
        }
        field(11311117; "Red Reg Org. Document Type"; Enum "Red Reg Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document Type';
        }
        field(11311118; "Red Reg Org. Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Document No.';
        }
        field(11311119; "Red Reg Org. Shipment No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Originating Shipment No.';
        }
    }
}