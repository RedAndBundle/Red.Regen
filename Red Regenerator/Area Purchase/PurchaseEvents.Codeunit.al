codeunit 11311116 "Red Reg Purchase Events"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCode(sender: Record "Purchase Header"; var PurchaseHeader: Record "Purchase Header"; var NoSeriesCode: Code[20]; PurchSetup: Record "Purchases & Payables Setup"; var IsHandled: Boolean)
    var
        Setup: Record "Red Reg Setup";
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::"Red Regenerator" then
            exit;

        NoSeriesCode := Setup.GetPurchaseNoSeriesCode();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        Generator: Codeunit "Red Reg Purchase Generator";
    begin
        if PreviewMode then
            exit;

        Generator.TestPurchaseSetup();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostCommitPurchaseDoc', '', false, false)]
    local procedure OnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; ModifyHeader: Boolean; var CommitIsSupressed: Boolean; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    var
        Setup: Record "Red Reg Setup";
        Generator: Codeunit "Red Reg Purchase Generator";
    begin
        if PreviewMode then
            exit;

        if not Setup.Get() then
            exit;

        // if (PurchaseHeader."Red Reg Contract No." <> '') or (has something to generate contract) then
        if Generator.WillGenerateContractsAfterPurchasePost(PurchaseHeader) then
            CommitIsSupressed := Setup."Suppress Purchase Post Commit";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        Generator: Codeunit "Red Reg Purchase Generator";
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Generator.GenerateContracts(PurchaseHeader, Enum::"Red Reg Generation Moments"::Manual);
        Generator.GenerateContractsAfterPurchasePost(PurchaseHeader, PurchRcpHdrNo, PurchInvHdrNo, CommitIsSupressed);
        Regenerator.ActivateContract(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnAfterReleasePurchaseDoc, '', false, false)]
    local procedure OnAfterReleaseSalesDoc(var PurchaseHeader: Record "Purchase Header"; var LinesWereModified: Boolean; SkipWhseRequestOperations: Boolean; PreviewMode: Boolean)
    var
        Generator: Codeunit "Red Reg Purchase Generator";
    begin
        if PreviewMode then
            exit;

        Generator.GenerateContracts(PurchaseHeader, Enum::"Red Reg Generation Moments"::OnRelease);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Purch. Invoice - Update", OnAfterRecordChanged, '', false, false)]
    local procedure OnAfterRecordChanged(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header")
    begin
        if IsChanged then
            exit;

        IsChanged := (PurchInvHeader."Red Reg Contract No." <> xPurchInvHeader."Red Reg Contract No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Inv. Header - Edit", OnBeforePurchInvHeaderModify, '', false, false)]
    local procedure OnBeforePurchInvHeaderModify(var PurchInvHeader: Record "Purch. Inv. Header"; PurchInvHeaderRec: Record "Purch. Inv. Header")
    begin
        PurchInvHeader."Red Reg Contract No." := PurchInvHeaderRec."Red Reg Contract No.";
    end;
}