codeunit 11311118 "Red Reg Enum Assignment Mgt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Enum Assignment Management", 'OnGetSalesApprovalDocumentType', '', false, false)]
    local procedure OnGetSalesApprovalDocumentType(SalesDocumentType: Enum "Sales Document Type"; var ApprovalDocumentType: Enum "Approval Document Type"; var IsHandled: Boolean)
    begin
        if IsHandled then
            exit;

        case SalesDocumentType of
            SalesDocumentType::"Red Regenerator":
                begin
                    ApprovalDocumentType := ApprovalDocumentType::"Red Regenerator";
                    IsHandled := true;
                end;
        end;
    end;
}