namespace Red.Regenerator;
using Microsoft.Sales.Setup;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.Document;
using Microsoft.Utilities;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Posting;
codeunit 70621 "Red Reg Sales Events"
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
        Generator: Codeunit "Red Reg Sales Generator";
    begin
        if PreviewMode then
            exit;

        if not Setup.Get() then
            exit;

        if not Setup."Suppress Sales Post Commit" then
            exit;

        if Generator.WillGenerateContractsAfterSalesPost(SalesHeader) then
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

        // Generator.GenerateContracts(SalesHeader, Enum::"Red Reg Generation Moments"::Manual);
        Generator.GenerateContractsAfterSalesPost(SalesHeader, SalesShptHdrNo, SalesInvHdrNo, CommitIsSuppressed, CustLedgerEntry);
        Regenerator.ActivateContract(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
    // Generator: Codeunit "Red Reg Sales Generator";
    begin
        if PreviewMode then
            exit;

        // Generator.GenerateContracts(SalesHeader, Enum::"Red Reg Generation Moments"::OnRelease);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, 'No.', false, false)]
    local procedure OnAfterValidateSalesLineNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        // Rec.RedRegAddContractLine();
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::ArchiveManagement, OnBeforeAutoArchiveSalesDocument, '', false, false)]
    local procedure OnBeforeAutoArchiveSalesDocument(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        IsHandled := SalesHeader.RedRegAutoArchive();
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::ArchiveManagement, OnBeforeStoreSalesDocument, '', false, false)]
    local procedure OnBeforeStoreSalesDocument(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::"Red Regenerator" then
            exit;

        SalesHeader.TestField("Red Reg Archive Reason Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::ArchiveManagement, OnBeforeStorePurchDocument, '', false, false)]
    local procedure OnBeforeStorePurchDocument(var PurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    begin
        if PurchHeader."Document Type" <> PurchHeader."Document Type"::"Red Regenerator" then
            exit;

        PurchHeader.TestField("Red Reg Archive Reason Code");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", OnBeforeNoOnAfterValidate, '', false, false)]
    local procedure OnBeforeNoOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        SalesDocument: Codeunit "Red Reg Sales Document";
    begin
        // Page runmodal to select the item contract template
        if SalesLine."No." = xSalesLine."No." then
            exit;
        SalesDocument.SelectItemContract(SalesLine);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", OnAfterNoOnAfterValidate, '', false, false)]
    local procedure OnAfterNoOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
        // Create the new sales line(s) from the selected item contract template
        if SalesLine."No." = xSalesLine."No." then
            exit;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", OnInsertRecordEvent, '', false, false)]
    local procedure OnInsertRecordEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        // Create the new sales line(s) from the selected item contract template
        if Rec."No." = xRec."No." then
            exit;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", OnModifyRecordEvent, '', false, false)]
    local procedure OnModifyRecordEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        // Create the new sales line(s) from the selected item contract template
        if Rec."No." = xRec."No." then
            exit;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterModifyEventSalesLine(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    var
        SalesDocument: Codeunit "Red Reg Sales Document";
    begin
        SalesDocument.GenerateContractDocumentLine(Rec);
    end;
}