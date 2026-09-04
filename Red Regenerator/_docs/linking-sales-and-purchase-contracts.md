# Linking Sales and Purchase Contracts

For back-to-back or drop-ship scenarios — where you bill a customer on a sales
contract and, in turn, get billed by a vendor on a matching purchase contract —
a Purchase Contract can carry a reference back to the Sales Contract it belongs
to.

## Setting up the link

On the Purchase Contract, set **Sales Contract No.** to the Sales Contract this
purchase contract is billed against. Once set, the Sales Contract's card shows
**Has Purchase Contract**, so you can see at a glance that a matching purchase
side exists.

## What the link does

The link itself is informational — it doesn't automatically create a purchase
contract for you. But once it's set, it's preserved automatically:

- Every time the linked Purchase Contract regenerates into a new Order or
  Invoice, that document carries the Sales Contract No. forward.
- Purchase Contract lines that reference a specific sales contract line (**Sales
  Contract No.** / **Sales Contract Ln. No.** on the line) carry that reference
  forward to each regenerated purchase document line too.

This keeps the two sides traceable to each other through every regeneration
cycle, even though each side is regenerated and billed independently on its own
schedule.

## Related

- [Contracts](contracts.md)
- [Contract Groups and Setup](contract-groups-and-setup.md)
