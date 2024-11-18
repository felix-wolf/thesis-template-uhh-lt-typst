#import "assets.typ"
#import "l10n.typ"
#import "glossary.typ"
#import "utils.typ"
#import "@preview/big-todo:0.2.0" // todos

#import glossary: register-glossary, glossary-entry, gls, glspl

#let _builtin_bibliography = bibliography

// helper function to quickly remove parts of the document only meant for development
#let wip_enabled = state("dir", false)

#let wip_content(body) = {
  context {
    if wip_enabled.get() {
      text(style: "italic")[#body]
    }
  }
}

#let todo(body) = {
  context {
    if wip_enabled.get() {
      big-todo.todo(body, inline:true)
    }
  }
}

#let todo-outline() = {
  context {
    if wip_enabled.get() {
      big-todo.todo_outline
    }
  }
}


/// The statutory declaration that the thesis was written without improper help. The text is not
/// part of the template so that it can be adapted according to one's needs. Example texts are given
/// in the template. Heading and signature lines for each author are inserted automatically.
///
/// - signature-height (length): The height of the signature line. The default should be able to fit
///   up to seven authors on one page; for larger teams, the height can be decreased.
/// - body (content): The actual declaration.
/// -> content
#let declaration(
  author-name,
  signature-height: 1.1cm,
  body,
) = [

  #let caption-spacing = -0.2cm
  
  #body

  #v(0.2cm)

  #context {
    show: block.with(breakable: false)
    set text(0.9em)
    grid(
      columns: (4fr, 6fr),
      align: center,
      [
        #v(signature-height)
        #line(length: 80%)
        #v(caption-spacing)
        #l10n.location-date
      ],
      [
        #v(signature-height)
        #line(length: 80%)
        #v(caption-spacing)
        #author-name
      ],
    )
  }
]


/// The main template function. Your document will generally start with ```typ #show: thesis(...)```,
/// which it already does after initializing the template. Although all parameters are named, most
/// of them are really mandatory. Parameters that are not given may result in missing content in
/// places where it is not actually optional.
///
/// - title (content, string): The title of the thesis, displayed on the title page and used for PDF
///   metadata.
/// - subtitle (content, string): A descriptive one-liner that gives the reader an immediate idea
///   about the thesis' topic.
/// - author (content, string): The thesis' author.
/// - research-group: name of the research group
/// - faculty: name of the faculty
/// - department: name of the department
/// - university (content, string): Name of the university, appears on the cover.
/// - city (content, string): City of the university, appears on the cover.
/// - supervisor-label (content, string, auto): The term with which to label the supervisor name;
///   if not given or `auto`, this defaults to a language-dependent text. In German, this text is
///   gender-specific and can be overridden with this parameter.
/// - supervisors (array): Names of the supervisors.
/// - degree: Name of the degree, e.g. Master of Science
/// - thesis-type: Type of thesis, e.g. Master's Thesis / Dissertation
/// - course-of-study: Name of the course of study, such as Master Informatik / Wirtschaftsinformatik etc.
/// - student-registration-number: Number of student, 'Matrikelnummer'
/// - date (datetime): The date of submission of the thesis.
/// - bibliography (content): The bibliography (```typc bibliography()```) to use for the thesis.
/// - language (string): The language in which the thesis is written. `"de"` and `"en"` are
///   supported. The choice of language influences certain texts on the title page and in headings,
///   as well as the date format used on the title page.
/// - paper (string): Changes the paper format of the thesis. Use this option with care, as it will
///   shift various contents around.
/// -> function
#let thesis(
  title: none,
  subtitle: none,
  author: none,
  research-group: none,
  faculty: none,
  department: none,
  university: none,
  city: none,
  supervisor-label: auto,
  supervisors: (),
  degree: none,
  thesis-type: none,
  course-of-study: none,
  student-registration-number: none,
  date: none,
  bibliography: none,
  language: "en",
  paper: "a4",
) = body => {
  import "@preview/codly:1.0.0": codly, codly-init
  import "@preview/datify:0.1.2"
  import "@preview/hydra:0.5.1": hydra, anchor
  import "@preview/i-figured:0.2.4"
  import "@preview/outrageous:0.3.0"

  
  // basic document & typesetting setup
  set document(
    title: title,
    author: author,
    date: date,
  )
  set page(paper: paper)
  set text(lang: language)
    set par(
    justify: true,
    spacing: 1em
  )

  // title page settings - must come before the first content (e.g. state update)
  set page(margin: (x: 1in, top: 1in, bottom: 0.75in))

  // make properties accessible as state

  // setup linguify
  l10n.set-database()  
  
  // setup glossarium
  show: glossary.make-glossary

  // setup codly & listing styles
  show: codly-init.with()
  show figure.where(kind: raw): block.with(width: 95%)

  // outline style
  set outline(indent: auto, depth: 2)
  show outline.entry: outrageous.show-entry.with(
    font: (auto,),
  )

  // general styles

  // figure supplements
  show figure.where(kind: image): set figure(supplement: l10n.figure)
  show figure.where(kind: table): set figure(supplement: l10n.table)
  show figure.where(kind: raw): set figure(supplement: l10n.listing)

  // table & line styles
  set line(stroke: 0.1mm)
  set table(stroke: (x, y) => if y == 0 {
    (bottom: 0.1mm)
  })

  // references to non-numbered headings
  show ref: it => {
    if type(it.element) != content { return it }
    if it.element.func() != heading { return it }
    if it.element.numbering != none { return it }

    link(it.target, it.element.body)
  }
  
  // title page

  {
    // header
    grid(
      columns: (auto, 1fr, auto),
      align: center+bottom,
      assets.uhh_logo(width: 5.5cm),
      assets.uhh-text(width: 5cm),
      assets.lt_logo(width: 1cm),
    )

    v(30mm)

    // title & subtitle
    align(center, {
      text(1.44em, weight: "extrabold", tracking:1pt, fill: red)[#thesis-type]
      v(35mm)
      layout(size => {
        let w = 0.76 * size.width
        box(width: w)[#text(2.49em, weight: "bold")[#title]]
      })

      if subtitle != none {
        v(-0.7em)
        text(1.44em)[#subtitle]
      }
    })

    v(30mm)

    // author & institution
    align(center, {
      text(1.44em)[#author]
      v(0.5em)
      text(1.2em)[#research-group\ #department\ #faculty]
      v(0.5em)
      text(1.2em)[#university\ #city]
    })

    // footer
    let date-formats = (
      "en": "Month DD, YYYY",
      "de": "DD. Month YYYY",
    )
    align(center, {
      v(1fr)
      text(1.2em)[A thesis submitted for the degree of]
      parbreak()
      text(1.2em, style: "italic")[#degree]
      parbreak()
      context if text.lang in date-formats {
        datify.custom-date-format(date, date-formats.at(text.lang))
      } else {
        date.display()
      }
    })
    
    pagebreak()
    
    // details
    if subtitle != none {
      text(font: "TeX Gyre Heros")[#title - #subtitle]
    } else {
      text(font: "TeX Gyre Heros")[#title]
    }
    
    parbreak()
    if course-of-study != none and student-registration-number != none {
      text(font: "TeX Gyre Heros")[#l10n.thesis submitted by: #author, #course-of-study, #student-registration-number]
    } else if course-of-study != none {
      text(font: "TeX Gyre Heros")[#l10n.thesis submitted by: #author, #course-of-study]
    } else {
      text(font: "TeX Gyre Heros")[#l10n.thesis submitted by: #author]
    }
    
    v(1em)
    text(font: "TeX Gyre Heros")[Date of Submission: #datify.custom-date-format(date, "Month DD, YYYY")]
    v(1em)
    text(font: "TeX Gyre Heros")[#supervisor-label]
    v(0em)
    text(font: "TeX Gyre Heros")[#supervisors.map(author => author).join("\n")]

    v(1fr)
    
    text(font: "TeX Gyre Heros")[
      #university, #city\
      #faculty\
      #department]
      v(1em)
      text(font: "TeX Gyre Heros")[
      #research-group
    ]
    
    
  }

  // regular page setup

  // show header & footer on "content" pages, show only page number in chapter title pages
  set page(
    margin: (left: 3.1cm, right: 3.1cm, top: 1.5in, bottom: 2.4cm),
    header-ascent: 35%,
    footer-descent: 15%,
    header: context {
      if utils.is-chapter-page() {
        // no header
      } else if utils.is-empty-page() {
        // no header
      } else {
        hydra(
          1,
          prev-filter: (ctx, candidates) => candidates.primary.prev.outlined == true,
          display: (ctx, candidate) => {
            grid(
              columns: (auto, 1fr),
              column-gutter: 3em,
              align: (left+top, right+top),
              {
                set par(justify: false)
                if candidate.has("numbering") and candidate.numbering != none {
                  numbering(candidate.numbering, ..counter(heading).at(candidate.location()))
                  [. ]
                }
                text(style: "italic")[#candidate.body]
              },
              text(style: "italic")[#counter(page).display("1", both: false)],
            )
          },
        )
        anchor()
      }
    },
    footer: context {
      if utils.is-chapter-page() {
        align(center)[
          #counter(page).display("1")
        ]
      } else if utils.is-empty-page() {
        // no footer
      } else {
        // no footer
      }
    },
  )

    set par(
    justify: true,
    first-line-indent: 1em,
    spacing: 1em
  )
  
  show: utils.mark-empty-pages()
  // front matter headings are not outlined
  set heading(outlined: false)
  // Heading supplements are section or chapter, depending on level
  show heading: set heading(supplement: l10n.section)
  show heading.where(level: 1): set heading(supplement: l10n.chapter)
  // chapters start on a right page and have very big, fancy headings
  show heading.where(level: 1): it => {
    set text(1.3em)
    pagebreak(to: "odd")
    v(12%)
    if it.numbering != none [
      #align(right, { 
        text(6em, fill: gray, style: "normal", { 
          counter(heading).display()
        })
      })
      #parbreak()
    ]
    set text(1.3em)
    v(-4cm)
    align(right)[#text(1cm, weight: "regular")[#it.body]]
    v(0.5cm)
  }
    
  // setup i-figured
  show heading: i-figured.reset-counters
  show figure: i-figured.show-figure
  show math.equation: i-figured.show-equation

  /*
  // the first section of a chapter starts on the next page
  show heading.where(level: 2): it => {
    if utils.is-first-section() {
      pagebreak()
    }
    it
  }
  */

  // the body contains abstracts and then the main matter

  body

  // back matter

  // glossary is outlined
  {
    set heading(outlined: true)

    glossary.print-glossary(title: [= #l10n.glossary <glossary>])
  }

  // bibliography is outlined, and we use our own header for the label
  {
    set _builtin_bibliography(title: none)
    set heading(outlined: true)

    [= #l10n.bibliography <bibliography>]
    bibliography
  }

  // List of {Figures, Tables, Listings} only shown if there are any such elements
  context if query(figure.where(kind: image)).len() != 0 {
    [= #l10n.list-of-figures <list-of-figures>]
    i-figured.outline(
      title: none,
      target-kind: image,
    )
  }

  context if query(figure.where(kind: table)).len() != 0 {
    [= #l10n.list-of-tables <list-of-tables>]
    i-figured.outline(
      title: none,
      target-kind: table,
    )
  }

  context if query(figure.where(kind: raw)).len() != 0 {
    [= #l10n.list-of-listings <list-of-listings>]
    i-figured.outline(
      title: none,
      target-kind: raw,
    )
  }

  // display statutory declaration
  set heading(outlined: true)
  [= #l10n.declaration-title <declaration>]
  declaration(author, l10n.declaration-text)

}

/// An abstract section. This should appear twice in the thesis regardless of language; first for
/// the German _Kurzfassung_, then for the English abstract.
///
/// - lang (string): The language of this abstract. Although it defaults to ```typc auto```, in
///   which case the document's language is used, it's preferable to always set the language
///   explicitly.
/// - body (content): The abstract text.
#let abstract(lang: auto, body) = [
  #set text(lang: lang) if lang != auto

  #context [
    #[= #l10n.abstract] #label("abstract-" + text.lang)
  ]

  #body
]

/// Starts the main matter of the thesis. This should be called as a show rule (```typ #show: main-matter()```) after the abstracts and will insert
/// the table of contents. All subsequent top level headings will be treated as chapters and thus be
/// numbered and outlined.
///
/// -> function
#let main-matter() = body => {
  [= #l10n.contents <contents>]
  outline(title: none)

  set heading(outlined: true, numbering: "1.1")

  text(12pt)[#body]
}
