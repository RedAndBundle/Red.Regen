# Item Contracts

An Item Contract links a G/L Account, Item, or Resource to a contract template. When
someone adds that item (or account/resource) to a sales order or invoice line, Red
Regenerator offers to attach the matching contract line automatically — so the
recurring billing line never has to be added by hand.

## Setting up Item Contracts

1. Open **Sales Item Contracts**.
2. Add a line for each Type / No. that should offer a contract:
   - **Type** and **No.** — the G/L Account, Item, or Resource that triggers the offer.
   - **Template Type** and **Template No.** — the contract template to attach.
3. You can add more than one contract line for the same Type / No. — if several
   templates apply, the user picks which ones to attach when the line is added.

## What happens on the sales line

When a Type/No. with a matching Item Contract is added to a Sales Order or Invoice
line:

1. A **Choose Item Contract** window opens, listing the matching contract(s).
2. Enter the **Contract Quantity** to use (defaults to the original line's quantity)
   and select which contract(s) to attach, then confirm.
3. A new line is added directly under the original line for each selected contract,
   using the template's item/account/resource, description, and the chosen quantity.

If the sales line already has a contract line attached (or the document isn't an
Order or Invoice), the offer is skipped.
