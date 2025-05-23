#import "@preview/glossarium:0.5.6" as glossarium: make-glossary, gls, agls, glspl

#let _glossary_entries = state("thesis-glossary-entries")

#let register-glossary(..entries) = {
  assert.eq(entries.named(), (:), message: "no named arguments allowed")
  let entries = entries.pos()
  glossarium.register-glossary(entries)
  _glossary_entries.update(entries)
}

/// Stores a glossary entry for this thesis. One call to this function is equivalent to one array
/// entry in Glossarium's ```typc print-glossary()```'s main parameter.
///
/// - key (string): The key with which the glossary entry can be referenced; must be unique.
/// - short (string): Mandatory; the short form of the entry shown after the term has been first
///   defined.
/// - long (string): The long form of the entry.
/// - long (string, content): The long form of the term, displayed in the glossary and on the first
///   citation of the term.
/// - desc (string, content): The description of the term.
/// - plural (string, content): The pluralized short form of the term.
/// - longplural (string, content): The pluralized long form of the term.
/// - group (string): The group the term belongs to. The terms are displayed by groups in the glossary.
/// -> content
#let glossary-entry(
  key,
  short: none,
  long: none,
  description: none,
  plural: none,
  longplural: none,
  group: none,
) = {
  assert(short != none, message: "short form of glossary-entry is mandatory")

  let entry = (
    key: key,
    short: short,
    long: long,
    description: description,
    plural: plural,
    longplural: longplural,
    group: group,
  )
  let entry = for (k, v) in entry {
    if v != none {
      ((k): v)
    }
  }

  entry
}

/// Displays a glossary of the entries added via @@glossary-entry().
///
/// - title (content): A (level 1) heading that titles this glossary. If the glossary is empty, the
///   title is not shown.
/// - ..args (arguments): Any extra parameters to the glossarium function of the same name.
#let print-glossary(title: none, ..args) = context {
  let entries = _glossary_entries.get()

  // let any-references = entries.any(e => {
  //   let count = glossarium.__query_labels_with_key(here(), e.key).len()
  //   count > 0
  // })

  // TODO
  let any-references = true

  if any-references or args.named().at("show-all", default: false) {
    title
  }
  glossarium.print-glossary(entries, ..args)
}
