# Contract Groups and Setup

## Setup

Open **Regenerator Setup** to configure company-wide behavior:

- **No. Series Sales** / **No. Series Purchase** — the number series used when
  posting the Orders/Invoices that contracts regenerate. Required before you can
  post any sales/purchase document that will generate a contract, or accept any
  contract.
- **Suppress Sales Post Commit** / **Suppress Purchase Post Commit** — when
  enabled (the default), posting a document that's about to generate a contract
  won't commit to the database until the contract has actually been created, so a
  failure partway through won't leave you with a posted document and no contract.
- **Action on Close** / **Action on Cancel** — whether closing or canceling a
  contract automatically archives it, or archives and then deletes it.
- **Action on Renew** — whether renewing a contract archives it first (there's no
  "archive and delete" option here, since the contract keeps going after renew).
- **Archive Sales Contracts** / **Archive Purchase Contracts** — whether deleting
  a contract archives it first. See [Archiving Contracts](archiving.md).

## Contract Groups

**Contract Groups** determine what kind of document a contract regenerates into.
Every contract must have a Group before it can be accepted or regenerated.

- **Code** / **Description** — identify the group.
- **Regenerate Type** — **Order** or **Invoice**: the document type that Accept
  and Regenerate create.
- **Generate Purchase Document** — reserved for automatically creating a linked
  purchase contract alongside a sales contract in this group. This isn't wired up
  yet; to link a purchase contract to a sales contract today, do it manually — see
  [Linking Sales and Purchase Contracts](linking-sales-and-purchase-contracts.md).

## Related

- [Contracts](contracts.md)
- [Creating Contracts](creating-contracts.md)
- [Archiving Contracts](archiving.md)
