# Creating Contracts

There are two ways a Sales or Purchase Contract comes into existence.

## Manually

Go to **Sales Contracts** or **Purchase Contracts** and choose **New**. This gives
you a blank contract in **Concept** status — fill in the customer/vendor, Group,
Start Date, Duration, and Billing Period, add lines, then **Accept** it. See
[Contracts](contracts.md) for the field descriptions and full lifecycle.

## Automatic contracts from templates

You can also have a contract created automatically the first time a particular
item, G/L account, or resource is shipped (sales) or received (purchase) on a
regular Order or Invoice — no manual contract entry needed.

1. Open **Sales Contract Templates** or **Purchase Contract Templates**.
2. Add a line for each Type / No. that should spin off a contract when it ships
   or is received:
   - **Type** and **No.** — the G/L Account, Item, or Resource.
   - **Contract Group** — which [Contract Group](contract-groups-and-setup.md#contract-groups)
     the generated contract belongs to.
   - **Duration** — how long the generated contract runs. If you leave this blank,
     the contract is still created, but you'll need to set its Duration and
     Billing Period by hand before it can be accepted/activated.
   - **Billing Period** — how often it's billed. Defaults to Duration if blank.

   On the sales side, you can set this up for many items at once instead of one
   line at a time, using **Create Contract Templates** on the Sales Contract
   Templates page: filter the items it applies to (by No., Item Category Code, or
   Type), enter the Contract Group / Duration / Billing Period / Show On
   Documents to use, and run it. It creates one template per matching item and
   reports back how many templates were created, how many items already had a
   template (skipped, not overwritten), and how many items couldn't be sold
   (blocked, sales-blocked, or missing required setup) and were skipped. There's
   no equivalent bulk tool for Purchase Contract Templates yet — add those lines
   one at a time.
3. Sell or purchase the item/account/resource normally, on a regular Order or
   Invoice, and post it so that a shipment (sales) or receipt (purchase) is
   created — this is what triggers contract generation, not the invoice posting
   itself.

When that document posts, a contract is created automatically in **Auto
Generated** status, one per originating document / Contract Group / Duration
combination — so if a single order ships several lines that map to the same
template settings, they land as lines on the same generated contract, while lines
mapping to a different Contract Group or Duration get their own contract. You
then activate the generated contract (or set it up further first, if Duration was
left blank on the template) to start regeneration.

The contract's card shows an **Original Document** action back to the sales/
purchase document (or its posted shipment/receipt) that generated it.

This only applies to regular Orders and Invoices — Blanket Orders, Credit Memos,
Quotes, and Return Orders never generate contracts this way.

## Item Contracts — offering a contract line while entering an order

A related but separate feature lets you offer to attach a contract line
*directly to the sales line itself*, while you're still entering a Sales Order or
Invoice — rather than spinning off a separate contract after posting. See [Item
Contracts](item-contracts.md) for how to set that up.

## Related

- [Contracts](contracts.md) — lifecycle and actions once a contract exists.
- [Contract Groups and Setup](contract-groups-and-setup.md)
- [Item Contracts](item-contracts.md)
