# Archiving Contracts

Contracts archive into the same kind of document archive Business Central uses
for regular sales/purchase documents, so an archived contract's full header and
lines are preserved even after the live contract is closed, canceled, or deleted.

## Archive reason codes

Before a contract can be archived — manually or automatically — it must have an
**Archive Reason Code** set. Set up the codes you want to use on **Contract
Archive Reason Codes**, separately for Sales and Purchase, then set the
**Archive Reason Code** field on the contract itself before archiving it.

## Archiving manually

On a contract's card, use **Archive Document** to send it to the archive at any
time without changing its status.

## Archiving automatically

Archiving also happens automatically as a side effect of other actions, based on
[Regenerator Setup](contract-groups-and-setup.md#setup):

- **Close** and **Cancel** archive the contract if **Action on Close** /
  **Action on Cancel** is set to Archive, or archive-and-delete it if set to
  Archive and delete.
- **Renew** archives the contract first if **Action on Renew** is set to Archive.
- Deleting a contract archives it first if **Archive Sales Contracts** /
  **Archive Purchase Contracts** is enabled.

## Viewing archived contracts

Archived contracts are listed separately from live contracts, on **Sales
Contract Archives** / **Purchase Contract Archives**. Each archived version keeps
its own copy of the header and lines as they were at the time it was archived —
a contract archived more than once (for example, on every Renew) keeps one entry
per archive.

## Related

- [Contracts](contracts.md)
- [Contract Groups and Setup](contract-groups-and-setup.md)
