codeunit 11311115 "Red Reg Sales Events"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeGetNoSeriesCode', '', false, false)]
    local procedure OnBeforeGetNoSeriesCode(var SalesHeader: Record "Sales Header"; SalesSetup: Record "Sales & Receivables Setup"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    var
        Setup: Record "Red Reg Setup";
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::"Red Regenerator" then
            exit;

        NoSeriesCode := Setup.GetSalesNoSeriesCode();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean; var CalledBy: Integer)
    var
        Generator: Codeunit "Red Reg Sales Generator";
    begin
        if PreviewMode then
            exit;

        Generator.TestSalesSetup();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCommitSalesDoc', '', false, false)]
    local procedure OnBeforePostCommitSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; var ModifyHeader: Boolean; var CommitIsSuppressed: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        Setup: Record "Red Reg Setup";
    begin
        if PreviewMode then
            exit;

        if not Setup.Get() then
            exit;

        // if (SalesHeader."Red Reg Contract No." <> '') or (has something to generate contract) then
        CommitIsSuppressed := Setup."Suppress Sales Post Commit";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        Generator: Codeunit "Red Reg Sales Generator";
        Regenerator: Codeunit "Red Reg Regenerator";
    begin
        if PreviewMode then
            exit;

        Generator.GenerateContractsAfterSalesPost(SalesHeader, SalesShptHdrNo, SalesInvHdrNo, CommitIsSuppressed, CustLedgerEntry);
        Regenerator.ActivateContract(SalesHeader);
    end;
}