#import "libs.typ": linguify, _set_database

/// *Internal function.* Initializes Linguify with the template's translation file.
///
/// -> content
#let set-database() = _set_database(toml("l10n.toml"))

#let thesis = linguify("thesis")
#let master-thesis = linguify("master-thesis")
#let bachelor-thesis = linguify("bachelor-thesis")
#let dissertation = linguify("dissertation")
#let supervisor = linguify("supervisor")
#let performed-in-year = linguify("performed-in-year")
#let submission-note = linguify("submission-note")
#let approved = linguify("approved")

#let declaration-title = linguify("declaration-title")
#let declaration-text = linguify("declaration-text")
//#let declaration-ai-clause = linguify("declaration-ai-clause")
#let location-date = linguify("location-date")

#let chapter = linguify("chapter")
#let section = linguify("section")
#let abstract = linguify("abstract")

#let figure = linguify("figure")
#let table = linguify("table")
#let listing = linguify("listing")

#let contents = linguify("contents")
#let bibliography = linguify("bibliography")
#let list-of-figures = linguify("list-of-figures")
#let list-of-tables = linguify("list-of-tables")
#let list-of-listings = linguify("list-of-listings")
#let glossary = linguify("glossary")

#let declaration-text-de = "Hiermit versichere ich an Eides statt, dass ich die vorliegende Arbeit im Masterstudiengang Informatik selbstständig verfasst und keine anderen als die angegebenen Hilfsmittel – insbesondere keine im Quellenverzeichnis nicht benannten Internet-Quellen – benutzt habe. Alle Stellen, die wörtlich oder sinngemäß aus Veröffentlichungen entnommen wurden, sind als solche kenntlich gemacht. Ich versichere weiterhin, dass ich die Arbeit vorher nicht in einem anderen Prüfungsverfahren eingereicht habe. Sofern im Zuge der Erstellung der vorliegenden Abschlussarbeit generative Künstliche Intelligenz (gKI) basierte elektronische Hilfsmittel verwendet wurden, versichere ich, dass meine eigene Leistung im Vordergrund stand und dass eine vollständige Dokumentation aller verwendeten Hilfsmittel gemäß der Guten Wissenschaftlichen Praxis vorliegt. Ich trage die Verantwortung für eventuell durch die gKI generierte fehlerhafte oder verzerrte Inhalte, fehlerhafte Referenzen, Verstöße gegen das Datenschutz- und Urheberrecht oder Plagiate."