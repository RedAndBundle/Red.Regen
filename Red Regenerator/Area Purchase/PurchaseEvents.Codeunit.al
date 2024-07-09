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
    begin
        if PreviewMode then
            exit;

        if not Setup.Get() then
            exit;

        // if (PurchaseHeader."Red Reg Contract No." <> '') or (has something to generate contract) then
        CommitIsSupressed := Setup."Suppress Purchase Post Commit";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        Generator: Codeunit "Red Reg Purchase Generator";
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        Generator.GenerateContractsAfterPurchasePost(PurchaseHeader, PurchRcpHdrNo, PurchInvHdrNo, CommitIsSupressed);
        Regenerator.ActivateContract(PurchaseHeader);
        // TODO add receipt Informaton to contract. ?? Is this even necessary? Does it add anything?
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
}