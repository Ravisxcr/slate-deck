// A short technical talk deck on MongoDB for a dev-team presentation, built with the typeset
// package's public API. ~10 slides, meant to actually be presented, not a single info card.
#import "../src/lib.typ": *
#import "../src/theme.typ": typeset-theme

#show: deck.with(title: "MongoDB", author: "Ravi", accent: rgb("#1d178b"), progress: true)

#slide(
  kind: "title",
  eyebrow: [Database deep dive],
  eyebrow-icon: "database",
  title: [MongoDB],
  subtitle: [A document-oriented database built for how we already model data in code — and where it does and doesn't fit our stack.],
  byline: ([Ravi], [Engineering], [Jul 2026]),
)

#slide(
  kind: "section",
  label: [Section 01],
  title: [What it is, and why documents instead of rows],
  blurb: [The data model first — everything else follows from it.],
  progress: false,
)

#slide(kicker: [The data model], title: [Every record is a BSON document, not a row])[
  #v(spacing.sm)
  #context {
    let t = typeset-theme.get()
    grid(
      columns: (1fr, 1fr),
      column-gutter: spacing.xl,
      align: (top, top),
      stack(
        spacing: spacing.lg,
        ..(
          (
            "layers",
            [A document is a JSON-like object (stored as binary BSON) — nested fields, arrays, and mixed types are native, not bolted on with join tables.],
          ),
          (
            "database-zap",
            [Schema is flexible per-collection: fields can be added or changed without an ALTER TABLE-style migration blocking writes.],
          ),
          (
            "git-branch",
            [Related data is often embedded in one document instead of normalized across tables — fewer joins, one round-trip to read an object.],
          ),
        ).map(((name, label)) => grid(
          columns: (auto, 1fr),
          column-gutter: spacing.md,
          align: top,
          icon(name, size: 15pt), text(font: fonts.body, size: 12pt, fill: t.ink-muted)[#label],
        )),
      ),
      code-block(
        theme: "light",
        highlight: (2, (4, 5)),
      )[
        ```js
        {
          _id: ObjectId("64f1..."),
          user: "jsmith",
          status: "active",
          roles: ["admin", "billing"],
          address: {
            city: "Austin",
            zip: "78701"
          },
          lastLogin: ISODate("2026-07-01")
        }
        ```],
    )
  }
]

#slide(
  kind: "compare",
  kicker: [Data model tradeoffs],
  title: [Documents vs. rows: what actually changes],
  left: (
    label: [Relational],
    title: [Tables + foreign keys],
    items: (
      [Fixed schema, enforced by the database],
      [Joins across normalized tables],
      [Multi-row transactions are the default mode],
      [Vertical scaling is the common path],
    ),
  ),
  right: (
    label: [MongoDB — when it fits],
    title: [Documents + embedding],
    items: (
      [Schema enforced by the app, or optionally by JSON Schema validators],
      [Related data embedded; joins via \$lookup when you need them],
      [Single-document writes are atomic; multi-document transactions exist but cost more],
      [Horizontal scaling via sharding is built in],
    ),
    recommended: true,
  ),
)

#slide(
  kind: "code",
  kicker: [Querying],
  kicker-icon: "terminal",
  title: [The aggregation pipeline: filter, reshape, group — in one call],
)[
  ```js
  db.orders.aggregate([
    { $match: { status: "paid" } },
    { $group: {
        _id: "$customerId",
        total: { $sum: "$amount" }
    }},
    { $sort: { total: -1 } },
    { $limit: 10 }
  ])
  ```
]

#slide(kicker: [Scaling], title: [Replica sets and sharding cover different problems])[
  #v(spacing.sm)
  #numbered-grid((
    (
      [Replica sets],
      [3+ copies of the same data. One primary takes writes, secondaries replicate and take over automatically if the primary goes down. This is for availability, not capacity.],
    ),
    (
      [Sharding],
      [Data is partitioned across many replica sets by a shard key. This is for capacity — write throughput and storage that outgrow one machine.],
    ),
    (
      [Shard key choice],
      [Picked once, hard to change later. A bad key (e.g. a monotonically increasing \_id) creates a hot shard instead of spreading load.],
    ),
    (
      [Read scaling],
      [Secondaries can serve reads with `readPreference`, trading strict consistency for lower load on the primary.],
    ),
  ))
]

#let fit-card(label, items) = context {
  let t = typeset-theme.get()
  block(width: 100%, height: 200pt, breakable: false, stroke: 1pt + t.border, radius: 2pt, inset: spacing.lg)[
    #text(font: fonts.display, weight: 700, size: 15pt, fill: t.ink)[#label]
    #v(spacing.sm)
    #line(length: 100%, stroke: 0.5pt + t.border)
    #v(spacing.sm)
    #stack(
      spacing: 10pt,
      ..items.map(i => text(font: fonts.body, size: 11pt, fill: t.ink-muted)[#i]),
    )
  ]
}

#slide(kicker: [When to reach for it], title: [Fit the tool to the access pattern, not the hype])[
  #v(spacing.sm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: spacing.xl,
    fit-card(
      [Good fit],
      (
        [Read-heavy, document-shaped data: profiles, catalogs, event/log payloads],
        [Schema that evolves fast, per feature branch],
        [Write/storage volume that will outgrow one primary],
      ),
    ),
    fit-card(
      [Poor fit],
      (
        [Heavy multi-row transactional integrity across many entities],
        [Ad-hoc reporting joins across dozens of normalized tables],
        [Team already deep in a well-tuned relational schema with no scaling pain],
      ),
    ),
  )
]

#slide(
  kind: "stat",
  kicker: [Maturity & Scale],
  stats: (
    ([17], [years in production since MongoDB's 2009 launch]),
    ([10M+], [active database deployments globally]),
  ),
  columns: 1,
  note: [Not a new bet — GA'd out of 10gen in 2009, now on major version 8.x with decades of combined operational experience behind it.],
)

#slide(kicker: [If we adopt it], title: [What actually changes for this team])[
  #v(spacing.sm)
  #numbered-grid((
    (
      [Model access patterns first],
      [Design documents around how the app reads data, not around third-normal-form. Embed what you read together.],
    ),
    (
      [Pick the shard key early],
      [If sharding is even a possibility later, choose a key that spreads write load now — it's expensive to change.],
    ),
    (
      [Add schema validation],
      [Flexible schema isn't "no schema" — use JSON Schema validators on collections that need guarantees.],
    ),
    (
      [Index like you mean it],
      [No query planner will save you from a missing index; `explain()` before shipping any new access pattern.],
    ),
  ))
]

#slide(
  kind: "closing",
  title: [Questions?],
  subtitle: [Docs at mongodb.com/docs — happy to pair on a schema design for anything on our roadmap.],
  footer: [Engineering · MongoDB deep dive · Jul 2026],
)
