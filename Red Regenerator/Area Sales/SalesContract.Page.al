page 11311116 "Red Reg Sales Contract"
{
    Caption = 'Sales Contract';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter("Red Regenerator"));
    AdditionalSearchTerms = 'Licence, Warranty, Rental';

    AboutTitle = 'About sales contract details';
    AboutText = 'Choose the contract details and fill in order lines with quantities of what you are selling. Regenerate the contract when you are ready to ship or invoice. This creates unposted sales documents.';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';

                    trigger OnValidate()
                    begin
                        IsSalesLinesEditable := Rec.SalesLinesEditable();
                        Rec.SelltoCustomerNoOnAfterValidate(Rec, xRec);
                        CurrPage.Update();
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Name';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';

                    AboutTitle = 'Who are you selling to?';
                    AboutText = 'You can choose existing customers, or add new customers when you create orders. Orders can automatically choose special prices and discounts that you have set for each customer.';

                    trigger OnValidate()
                    begin
                        Rec.SelltoCustomerNoOnAfterValidate(Rec, xRec);
                        CurrPage.Update();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookupSellToCustomerName(Text));
                    end;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = VAT;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s VAT registration number for customers.';
                    Visible = false;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                    Visible = false;
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("Sell-to Address"; Rec."Sell-to Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the address where the customer is located.';
                    }
                    field("Sell-to Address 2"; Rec."Sell-to Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address 2';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Sell-to City"; Rec."Sell-to City")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'City';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the city of the customer on the sales document.';
                    }
                    group(SelltoCounty)
                    {
                        ShowCaption = false;
                        Visible = IsSellToCountyVisible;
                        field("Sell-to County"; Rec."Sell-to County")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'County';
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the state, province or county of the address.';
                        }
                    }
                    field("Sell-to Post Code"; Rec."Sell-to Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Code';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Country/Region Code';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the country or region of the address.';

                        trigger OnValidate()
                        begin
                            IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
                        end;
                    }
                    field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact No.';
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact person that the sales document will be sent to.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if not Rec.SelltoContactLookup() then
                                exit(false);
                            Text := Rec."Sell-to Contact No.";
                            CurrPage.Update();
                            exit(true);
                        end;

                        trigger OnValidate()
                        begin
                            if Rec.GetFilter("Sell-to Contact No.") = xRec."Sell-to Contact No." then
                                if Rec."Sell-to Contact No." <> xRec."Sell-to Contact No." then
                                    Rec.SetRange("Sell-to Contact No.");
                            if Rec."Sell-to Contact No." <> xRec."Sell-to Contact No." then
                                CurrPage.Update();
                        end;
                    }
                    field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Phone No.';
                        Importance = Additional;
                        ToolTip = 'Specifies the telephone number of the contact person that the sales document will be sent to.';
                    }
                    field(SellToMobilePhoneNo; SellToContact."Mobile Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mobile Phone No.';
                        Importance = Additional;
                        Editable = false;
                        ExtendedDatatype = PhoneNo;
                        ToolTip = 'Specifies the mobile telephone number of the contact person that the sales document will be sent to.';
                    }
                    field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Email';
                        Importance = Additional;
                        ToolTip = 'Specifies the email address of the contact person that the sales document will be sent to.';
                    }
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contact';
                    Editable = Rec."Sell-to Customer No." <> '';
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                }
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of archived versions for this document.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the related document was created.';
                }
                field("Red Reg Contract Status"; Rec."Red Reg Contract Status")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    Editable = false;
                    ToolTip = 'Specifies the status of the contract.';
                }
                field("Red Reg Start Date"; Rec."Red Reg Start Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date that the contract has started.';

                    trigger OnValidate()
                    begin
                        SaveInvoiceDiscountAmount();
                    end;
                }
                field("Red Reg Duration"; Rec."Red Reg Duration")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the duration of the contract. If left empty, the contract is valid indefinetely.';
                }
                field("Red Reg End Date"; Rec."Red Reg End Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    QuickEntry = false;
                    ToolTip = 'Specifies the date when the contract will end.';
                }
                field("Red Reg Billing Period"; Rec."Red Reg Billing Period")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the billing period of the contract.';
                }
                field("Red Reg Next Billing Date"; Rec."Red Reg Next Billing Date")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    Editable = false;
                    ToolTip = 'Specifies the date of the next billing.';
                }
                field("Red Reg Group"; Rec."Red Reg Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the group that the Purchase contract belongs to.';
                }
                field("Red Reg Contract Iteration"; Rec."Red Reg Contract Iteration")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    Editable = false;
                    ToolTip = 'Specifies how many times the contract has been billed.';
                }
                field("Red Reg Has Purchase Contract"; Rec."Red Reg Has Purchase Contract")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies if there are purchase contracts that were created from this sales contract';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ShowMandatory = ExternalDocNoMandatory;
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s reference. The content will be printed on sales documents.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the name of the salesperson who is assigned to the customer.';

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate();
                    end;
                }
                field("Campaign No."; Rec."Campaign No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the campaign that the document is linked to.';
                }
                field("Opportunity No."; Rec."Opportunity No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the opportunity that the sales quote is assigned to.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    AccessByPermission = TableData "Responsibility Center" = R;
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                // field("Job Queue Status"; Rec."Job Queue Status")
                // {
                //     ApplicationArea = All;
                //     Importance = Additional;
                //     ToolTip = 'Specifies the status of a job queue entry or task that handles the regeneration of sales contracts.';
                //     Visible = JobQueuesUsed;
                // }
            }
            group(WorkDescription)
            {
                Caption = 'Work Description';
                field(WorkDescriptionField; WorkDescription)
                {
                    ApplicationArea = Basic, Suite;
                    MultiLine = true;
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    ToolTip = 'Specifies the products or service being offered.';

                    trigger OnValidate()
                    begin
                        Rec.SetWorkDescription(WorkDescription);
                    end;
                }
            }
            part(SalesLines; "Red Reg Sales Contract Subform")
            {
                ApplicationArea = Basic, Suite;
                Editable = IsSalesLinesEditable;
                Enabled = IsSalesLinesEditable;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency of amounts on the sales document.';

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if Rec."Posting Date" <> 0D then
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                        else
                            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate());
                        if ChangeExchangeRate.RunModal() = ACTION::OK then begin
                            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());
                            SaveInvoiceDiscountAmount();
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Company Bank Account Code"; Rec."Company Bank Account Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the bank account to use for bank information when the document is printed.';
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid();
                    end;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = IsPostingGroupEditable;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                    Visible = IsPaymentMethodCodeVisible;

                    trigger OnValidate()
                    begin
                        UpdatePaymentService();
                    end;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies if the transaction is related to trade with a third party within the EU.';
                }
                group(Control76)
                {
                    ShowCaption = false;
                    Visible = PaymentServiceVisible;
                    field(SelectedPayments; Rec.GetSelectedPaymentServicesText())
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Service';
                        Editable = false;
                        Enabled = PaymentServiceEnabled;
                        MultiLine = true;
                        ToolTip = 'Specifies the online payment service, such as PayPal, that customers can use to pay the sales document.';

                        trigger OnAssistEdit()
                        begin
                            Rec.ChangePaymentServiceSetting();
                        end;
                    }
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV();
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV();
                    end;
                }
            }
            group("Shipping and Billing")
            {
                Caption = 'Shipping and Billing';
                group(Control91)
                {
                    ShowCaption = false;
                    group(Control90)
                    {
                        ShowCaption = false;
                        field(ShippingOptions; ShipToOptions)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ship-to';
                            ToolTip = 'Specifies the address that the products on the sales document are shipped to. Default (Sell-to Address): The same as the customer''s sell-to address. Alternate Ship-to Address: One of the customer''s alternate ship-to addresses. Custom Address: Any ship-to address that you specify in the fields below.';

                            trigger OnValidate()
                            var
                                ShipToAddress: Record "Ship-to Address";
                                ShipToAddressList: Page "Ship-to Address List";
                            begin
                                case ShipToOptions of
                                    ShipToOptions::"Default (Sell-to Address)":
                                        begin
                                            Rec.Validate("Ship-to Code", '');
                                            Rec.CopySellToAddressToShipToAddress();
                                        end;
                                    ShipToOptions::"Alternate Shipping Address":
                                        begin
                                            ShipToAddress.SetRange("Customer No.", Rec."Sell-to Customer No.");
                                            ShipToAddressList.LookupMode := true;
                                            ShipToAddressList.SetTableView(ShipToAddress);

                                            if ShipToAddressList.RunModal() = ACTION::LookupOK then begin
                                                ShipToAddressList.GetRecord(ShipToAddress);
                                                Rec.Validate("Ship-to Code", ShipToAddress.Code);
                                                IsShipToCountyVisible := FormatAddress.UseCounty(ShipToAddress."Country/Region Code");
                                            end else
                                                ShipToOptions := ShipToOptions::"Custom Address";
                                        end;
                                    ShipToOptions::"Custom Address":
                                        begin
                                            Rec.Validate("Ship-to Code", '');
                                            IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
                                        end;
                                end;
                            end;
                        }
                        group(Control4)
                        {
                            ShowCaption = false;
                            Visible = not (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
                            field("Ship-to Code"; Rec."Ship-to Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Code';
                                Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
                                Importance = Promoted;
                                ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';

                                trigger OnValidate()
                                var
                                    ShipToAddress: Record "Ship-to Address";
                                begin
                                    if (xRec."Ship-to Code" <> '') and (Rec."Ship-to Code" = '') then
                                        Error(EmptyShipToCodeErr);
                                    if Rec."Ship-to Code" <> '' then begin
                                        ShipToAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code");
                                        IsShipToCountyVisible := FormatAddress.UseCounty(ShipToAddress."Country/Region Code");
                                    end else
                                        IsShipToCountyVisible := false;
                                end;
                            }
                            field("Ship-to Name"; Rec."Ship-to Name")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Name';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                            }
                            field("Ship-to Address"; Rec."Ship-to Address")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
                            }
                            field("Ship-to Address 2"; Rec."Ship-to Address 2")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address 2';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies additional address information.';
                            }
                            field("Ship-to City"; Rec."Ship-to City")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'City';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the city of the customer on the sales document.';
                            }
                            group(Control297)
                            {
                                ShowCaption = false;
                                Visible = IsShipToCountyVisible;
                                field("Ship-to County"; Rec."Ship-to County")
                                {
                                    ApplicationArea = Basic, Suite;
                                    Caption = 'County';
                                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                    QuickEntry = false;
                                    ToolTip = 'Specifies the state, province or county of the address.';
                                }
                            }
                            field("Ship-to Post Code"; Rec."Ship-to Post Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Post Code';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                QuickEntry = false;
                                ToolTip = 'Specifies the postal code.';
                            }
                            field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Country/Region';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the customer''s country/region.';

                                trigger OnValidate()
                                begin
                                    IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
                                end;
                            }
                        }
                        field("Ship-to Contact"; Rec."Ship-to Contact")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact';
                            ToolTip = 'Specifies the name of the contact person at the address that products on the sales document will be shipped to.';
                        }
                    }
                }
                group(Control85)
                {
                    ShowCaption = false;
                    field(BillToOptions; BillToOptions)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bill-to';
                        ToolTip = 'Specifies the customer that the sales invoice will be sent to. Default (Customer): The same as the customer on the sales invoice. Another Customer: Any customer that you specify in the fields below.';

                        trigger OnValidate()
                        begin
                            if BillToOptions = BillToOptions::"Default (Customer)" then begin
                                Rec.Validate("Bill-to Customer No.", Rec."Sell-to Customer No.");
                                Rec.RecallModifyAddressNotification(Rec.GetModifyBillToCustomerAddressNotificationId());
                            end;

                            Rec.CopySellToAddressToBillToAddress();
                        end;
                    }
                    group(Control82)
                    {
                        ShowCaption = false;
                        Visible = not (BillToOptions = BillToOptions::"Default (Customer)");
                        field("Bill-to Name"; Rec."Bill-to Name")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Name';
                            Editable = ((BillToOptions = BillToOptions::"Another Customer") or ((BillToOptions = BillToOptions::"Custom Address") and not ShouldSearchForCustByName));
                            Enabled = ((BillToOptions = BillToOptions::"Another Customer") or ((BillToOptions = BillToOptions::"Custom Address") and not ShouldSearchForCustByName));
                            Importance = Promoted;
                            ToolTip = 'Specifies the customer to whom you will send the sales invoice, when different from the customer that you are selling to.';

                            trigger OnValidate()
                            begin
                                if not ((BillToOptions = BillToOptions::"Custom Address") and not ShouldSearchForCustByName) then begin
                                    if Rec.GetFilter("Bill-to Customer No.") = xRec."Bill-to Customer No." then
                                        if Rec."Bill-to Customer No." <> xRec."Bill-to Customer No." then
                                            Rec.SetRange("Bill-to Customer No.");

                                    CurrPage.Update();
                                end;
                            end;
                        }
                        field("Bill-to Address"; Rec."Bill-to Address")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the address of the customer that you will send the invoice to.';
                        }
                        field("Bill-to Address 2"; Rec."Bill-to Address 2")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address 2';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies additional address information.';
                        }
                        field("Bill-to City"; Rec."Bill-to City")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'City';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the city of the customer on the sales document.';
                        }
                        group(Control130)
                        {
                            ShowCaption = false;
                            Visible = IsBillToCountyVisible;
                            field("Bill-to County"; Rec."Bill-to County")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'County';
                                Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                                Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                                Importance = Additional;
                                QuickEntry = false;
                                ToolTip = 'Specifies the state, province or county of the address.';
                            }
                        }
                        field("Bill-to Post Code"; Rec."Bill-to Post Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Post Code';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the postal code.';
                        }
                        field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Country/Region Code';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the country or region of the address.';

                            trigger OnValidate()
                            begin
                                IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");
                            end;
                        }
                        field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact No.';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Importance = Additional;
                            ToolTip = 'Specifies the number of the contact the invoice will be sent to.';
                        }
                        field("Bill-to Contact"; Rec."Bill-to Contact")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact';
                            Editable = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            Enabled = (BillToOptions = BillToOptions::"Custom Address") or (Rec."Bill-to Customer No." <> Rec."Sell-to Customer No.");
                            ToolTip = 'Specifies the name of the person you should contact at the customer who you are sending the invoice to.';
                        }
                        field(BillToContactPhoneNo; BillToContact."Phone No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Phone No.';
                            Editable = false;
                            Importance = Additional;
                            ExtendedDatatype = PhoneNo;
                            ToolTip = 'Specifies the telephone number of the person you should contact at the customer you are sending the invoice to.';
                        }
                        field(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Mobile Phone No.';
                            Editable = false;
                            Importance = Additional;
                            ExtendedDatatype = PhoneNo;
                            ToolTip = 'Specifies the mobile telephone number of the person you should contact at the customer you are sending the invoice to.';
                        }
                        field(BillToContactEmail; BillToContact."E-Mail")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Email';
                            Editable = false;
                            Importance = Additional;
                            ExtendedDatatype = EMail;
                            ToolTip = 'Specifies the email address of the person you should contact at the customer you are sending the invoice to.';
                        }
                    }
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
            }
        }
        area(factboxes)
        {
            // part(SalesDocCheckFactbox; "Sales Doc. Check Factbox")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Document Check';
            //     Visible = SalesDocCheckFactboxVisible;
            //     SubPageLink = "No." = field("No."),
            //                   "Document Type" = field("Document Type");
            // }
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Sales Header"),
                              "No." = field("No."),
                              "Document Type" = field("Document Type");
            }
            part(Control35; "Pending Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(36),
                              "Document Type" = field("Document Type"),
                              "Document No." = field("No."),
                              Status = const(Open);
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1903720907; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("Sell-to Customer No."),
                              "Date Filter" = field("Date Filter");
            }
            part(Control1902018507; "Customer Statistics FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("Bill-to Customer No."),
                              "Date Filter" = field("Date Filter");
                Visible = false;
            }
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("Sell-to Customer No."),
                              "Date Filter" = field("Date Filter");
            }
            part(Control1906127307; "Sales Line FactBox")
            {
                ApplicationArea = Suite;
                Provider = SalesLines;
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("Document No."),
                              "Line No." = field("Line No.");
            }
            part(Control1901314507; "Item Invoicing FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "No." = field("No.");
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
                Visible = false;
            }
            part(Control1907012907; "Resource Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "No." = field("No.");
                Visible = false;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "No." = field("No.");
                Visible = false;
            }
            part(Control1907234507; "Sales Hist. Bill-to FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field("Bill-to Customer No."),
                              "Date Filter" = field("Date Filter");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ontract")
            {
                Caption = 'C&ontract';
                Image = RefreshText;
                action(Customer)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Enabled = IsCustomerOrContactNotEmpty;
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = field("Sell-to Customer No."),
                                  "Date Filter" = field("Date Filter");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer on the sales document.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Enabled = Rec."No." <> '';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalsSales(Rec);
                    end;
                }
                action(DocAttach)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                // TODO add orders
                action("S&hipments")
                {
                    // TODO Fix
                    ApplicationArea = Basic, Suite;
                    Caption = 'S&hipments';
                    Image = Shipment;
                    RunObject = Page "Posted Sales Shipments";
                    RunPageLink = "Order No." = field("No.");
                    RunPageView = sorting("Order No.");
                    ToolTip = 'View related posted sales shipments.';
                }
                action(Invoices)
                {
                    // TODO Fix
                    ApplicationArea = Basic, Suite;
                    Caption = 'Invoices';
                    Image = Invoice;
                    ToolTip = 'View a list of ongoing sales invoices for the order.';

                    trigger OnAction()
                    var
                        TempSalesInvoiceHeader: Record "Sales Invoice Header" temporary;
                        SalesGetShipment: Codeunit "Sales-Get Shipment";
                    begin
                        SalesGetShipment.GetSalesOrderInvoices(TempSalesInvoiceHeader, Rec."No.");
                        Page.Run(Page::"Posted Sales Invoices", TempSalesInvoiceHeader);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Action21)
            {
                Caption = 'Status';
                Image = ReleaseDoc;
                action(Accept)
                {
                    ApplicationArea = Suite;
                    Caption = 'Accept';
                    Image = ReleaseDoc;
                    Enabled = ShowAccept;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Approves the contract, this action will create a sales document. Shipping the sales document will activate the contract.';

                    trigger OnAction()
                    begin
                        Rec.RedRegAccept();
                        CurrPage.Update();
                    end;
                }
                action(Activate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Activate';
                    Image = OpenJournal;
                    Enabled = ShowActivate;
                    ToolTip = 'Activates the contract.';

                    trigger OnAction()
                    begin
                        Rec.RedRegActivate();
                        CurrPage.Update();
                    end;
                }
                action(Close)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Close';
                    Enabled = ShowClose;
                    Image = CloseDocument;
                    ToolTip = 'Closes the contract, it can no longer be extended.';

                    trigger OnAction()
                    begin
                        Rec.RedRegClose();
                        CurrPage.Update();
                    end;
                }
                action(Cancel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Enabled = ShowCancel;
                    Image = Cancel;
                    ToolTip = 'Cancels the contract, it can no longer be extended.';

                    trigger OnAction()
                    begin
                        Rec.RedRegCancel();
                        CurrPage.Update();
                    end;
                }
                action(Renew)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Renew';
                    // Enabled = ShowRenew;
                    Image = Redo;
                    ToolTip = 'Renews the contract, it can be extended.';

                    trigger OnAction()
                    begin
                        Rec.RedRegRenew();
                        CurrPage.Update();
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = not OpenApprovalEntriesExist and CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckSalesApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Regenerate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Regenerate';
                    Ellipsis = true;
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    Enabled = ShowRegenerate;
                    ToolTip = 'Generates a new sales document based on this entry.';

                    trigger OnAction()
                    begin
                        Rec.RedRegenerate();
                    end;
                }
                action(RegenerateAndPost)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Regenerate and Post';
                    Ellipsis = true;
                    Image = PostMail;
                    Enabled = ShowRegenerate;
                    ToolTip = 'Generates a new sales document based on this entry and posts it.';

                    trigger OnAction()
                    begin
                        Rec.RedRegenerateAndPost();
                    end;
                }
                // action("Remove From Job Queue")
                // {
                //     ApplicationArea = All;
                //     Caption = 'Remove From Job Queue';
                //     Image = RemoveLine;
                //     ToolTip = 'Remove the scheduled processing of this record from the job queue.';
                //     Visible = JobQueueVisible;

                //     trigger OnAction()
                //     begin
                //         Rec.CancelBackgroundPosting();
                //     end;
                // }
            }
            group("&Contract Confirmation")
            {
                Caption = '&Contract Confirmation';
                Image = Email;
                action(SendEmailConfirmation)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Email Confirmation';
                    Ellipsis = true;
                    Image = Email;
                    ToolTip = 'Send a contract confirmation by email. The attachment is sent as a .pdf.';

                    trigger OnAction()
                    begin
                        Rec.RedRegSendContract();
                    end;
                }
                group(Action96)
                {
                    action("Print Confirmation")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Confirmation';
                        Ellipsis = true;
                        Image = Print;
                        ToolTip = 'Print a sales contract confirmation.';

                        trigger OnAction()
                        begin
                            Rec.RedRegPrintContract();
                        end;
                    }
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                group(Category_Category6)
                {
                    Caption = 'Posting', Comment = 'Generated from the PromotedActionCategories property index 5.';
                    ShowAs = SplitButton;

                    actionref(Regenerate_Promoted; Regenerate)
                    {
                    }
                    actionref(RegenerateAndPost_Promoted; RegenerateAndPost)
                    {
                    }
                }
                group(Category_Category5)
                {
                    Caption = 'Accept', Comment = 'Generated from the PromotedActionCategories property index 4.';
                    ShowAs = SplitButton;

                    actionref(Accept_Promoted; Accept)
                    {
                    }
                    actionref(Activate_Promoted; Activate)
                    {
                    }
                    actionref(Close_Promoted; Close)
                    {
                    }
                    actionref(Cancel_Promoted; Cancel)
                    {
                    }
                    actionref(renew_Promoted; Renew)
                    {
                    }
                }
                // actionref("Archive Document_Promoted"; "Archive Document")
                // {
                // }
            }
            group(Category_Category4)
            {
                Caption = 'Approve', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Comment_Promoted; Comment)
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
            }
            group(Category_Category11)
            {
                Caption = 'Print/Send', Comment = 'Generated from the PromotedActionCategories property index 10.';

                actionref(SendEmailConfirmation_Promoted; SendEmailConfirmation)
                {
                }
                actionref("Print Confirmation_Promoted"; "Print Confirmation")
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Request Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
            }
            group(Category_Category8)
            {
                Caption = 'Contract', Comment = 'Generated from the PromotedActionCategories property index 7.';

                actionref(Dimensions_Promoted; Dimensions)
                {
                }
                actionref(DocAttach_Promoted; DocAttach)
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
                separator(Navigate_Separator)
                {
                }
                actionref(Invoices_Promoted; Invoices)
                {
                }
                actionref(Customer_Promoted; Customer)
                {
                }
                actionref("S&hipments_Promoted"; "S&hipments")
                {
                }
            }
            group(Category_Category10)
            {
                Caption = 'History', Comment = 'Generated from the PromotedActionCategories property index 9.';
                // TODO add unposted and posted sales documents
            }
            group(Category_Category12)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 11.';
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        SalesHeader: Record "Sales Header";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit";
        IsHandled: Boolean;
    begin
        if GuiAllowed() then begin
            IsSalesLinesEditable := Rec.SalesLinesEditable();
            CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
            CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(Rec.RecordId);
        end;
        CRMIsCoupledToRecord := CRMIntegrationEnabled;
        if CRMIsCoupledToRecord then
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
        if GuiAllowed() then begin
            ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);
            UpdatePaymentService();
            if CallNotificationCheck then begin
                SalesHeader := Rec;
                SalesHeader.CalcFields("Amount Including VAT");
                ;
                CustCheckCrLimit.SalesHeaderCheck(SalesHeader);
                IsHandled := false;
                if not IsHandled then
                    Rec.CheckItemAvailabilityInLines();
                CallNotificationCheck := false;
            end;
            StatusStyleTxt := Rec.GetStatusStyleText();
            SetControlVisibility();
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        WorkDescription := Rec.GetWorkDescription();
        if GuiAllowed() then begin
            SetControlVisibility();
            UpdateShipToBillToGroupVisibility();
            BillToContact.GetOrClear(Rec."Bill-to Contact No.");
            SellToContact.GetOrClear(Rec."Sell-to Contact No.");
            CurrPage.IncomingDocAttachFactBox.Page.SetCurrentRecordID(Rec.RecordId);
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord();
        exit(Rec.ConfirmDeletion());
    end;

    trigger OnInit()
    var
    // Setup: Record "Red Reg Setup";
    begin
        // JobQueuesUsed := Setup.JobQueueSalesActive();
        SetExtDocNoMandatoryCondition();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if DocNoVisible then
            Rec.CheckCreditMaxBeforeInsert();

        if (Rec."Sell-to Customer No." = '') and (Rec.GetFilter("Sell-to Customer No.") <> '') then
            CurrPage.Update(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        xRec.Init();
        Rec."Responsibility Center" := UserMgt.GetSalesFilter();
        if (not DocNoVisible) and (Rec."No." = '') then
            Rec.SetSellToCustomerFromFilter();

        Rec.SetDefaultPaymentServices();
        UpdateShipToBillToGroupVisibility();
    end;

    trigger OnOpenPage()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        Rec.SetSecurityFilterOnRespCenter();

        Rec.SetRange("Date Filter", 0D, WorkDate());

        ActivateFields();

        SetDocNoVisible();

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled();

        if (Rec."No." <> '') and (Rec."Sell-to Customer No." = '') then
            DocumentIsPosted := (not Rec.Get(Rec."Document Type", Rec."No."));
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible();

        if GuiAllowed() then
            CheckShowBackgrValidationNotification();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
    end;

    var
        BillToContact: Record Contact;
        SellToContact: Record Contact;
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        // DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "User Setup Management";
        CustomerMgt: Codeunit "Customer Mgt.";
        FormatAddress: Codeunit "Format Address";
        ChangeExchangeRate: Page "Change Exchange Rate";
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        // JobQueueVisible: Boolean;
        // JobQueuesUsed: Boolean;
        PaymentServiceVisible: Boolean;
        PaymentServiceEnabled: Boolean;
        IsPostingGroupEditable: Boolean;
        EmptyShipToCodeErr: Label 'The Code field can only be empty if you select Custom Address in the Ship-to field.';
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        IsCustomerOrContactNotEmpty: Boolean;
        WorkDescription: Text;
        StatusStyleTxt: Text;
        IsBillToCountyVisible: Boolean;
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;
        IsPaymentMethodCodeVisible: Boolean;
        IsSalesLinesEditable: Boolean;
        ShouldSearchForCustByName: Boolean;
        ShowAccept: Boolean;
        ShowActivate: Boolean;
        ShowClose: Boolean;
        ShowCancel: Boolean;
        ShowRegenerate: Boolean;

    protected var
        ShipToOptions: Enum "Sales Ship-to Options";
        BillToOptions: Enum "Sales Bill-to Options";
        CallNotificationCheck: Boolean;
        DocumentIsPosted: Boolean;
        ShowQuoteNo: Boolean;

    local procedure ActivateFields()
    begin
        IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");
        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
        GLSetup.Get();
        IsPaymentMethodCodeVisible := not GLSetup."Hide Payment Method Code";
        IsSalesLinesEditable := Rec.SalesLinesEditable();
    end;

    local procedure SaveInvoiceDiscountAmount()
    var
        DocumentTotals: Codeunit "Document Totals";
    begin
        CurrPage.SaveRecord();
        DocumentTotals.SalesRedistributeInvoiceDiscountAmountsOnDocument(Rec);
        CurrPage.Update(false);
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(false);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update();
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update();
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.SalesLines.Page.ForceTotalsCalculation();
        CurrPage.Update();
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Order, Rec."No.");
    end;

    local procedure SetExtDocNoMandatoryCondition()
    begin
        SalesSetup.GetRecordOnce();
        ExternalDocNoMandatory := SalesSetup."Ext. Doc. No. Mandatory";
    end;

    local procedure SetControlVisibility()
    var
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        // JobQueueVisible := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        ShowQuoteNo := Rec."Quote No." <> '';
        SetExtDocNoMandatoryCondition();
        SetPostingGroupEditable();

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        IsCustomerOrContactNotEmpty := (Rec."Sell-to Customer No." <> '') or (Rec."Sell-to Contact No." <> '');
        ShouldSearchForCustByName := Rec.ShouldSearchForCustomerByName(Rec."Sell-to Customer No.");

        ShowAccept := Rec.RedRegShowAccept();
        ShowClose := Rec.RedRegShowClose();
        ShowCancel := Rec.RedRegShowCancel();
        ShowActivate := Rec.RedRegShowActivate();
        ShowRegenerate := Rec.RedRegShowRegenerate();
    end;

    protected procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
    begin
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible();
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;

    procedure UpdateShipToBillToGroupVisibility()
    begin
        // CustomerMgt.CalculateShipToBillToOptions(ShipToOptions, BillToOptions, Rec);
        CustomerMgt.CalculateShipBillToOptions(ShipToOptions, BillToOptions, Rec);
    end;

    procedure SetPostingGroupEditable()
    var
        BillToCustomer: Record Customer;
    begin
        if BillToCustomer.Get(Rec."Bill-to Customer No.") then
            IsPostingGroupEditable := BillToCustomer."Allow Multiple Posting Groups";
    end;

    local procedure CheckShowBackgrValidationNotification()
    var
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
    begin
        if DocumentErrorsMgt.CheckShowEnableBackgrValidationNotification() then
            SetControlVisibility();
    end;
}