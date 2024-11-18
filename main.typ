#import "template/lib.typ": *
#import "template/utils.typ": *

// SET TO false OR REMOVE LINE TO GET RID OF WORK IN PROGRESS CONTENT DEFINED WITH #wip_content() or #todo()
#wip_enabled.update(true)

#show: thesis(
  title: "Your fance thesis title",
  author: "Your name",
  research-group: "Research group",
  department: "Department",
  faculty: "Faculty",
  university: "Univerity",
  city:  "Location",
  degree: "Degree", // formal degree name, e.g. Master of Science (M.Sc.)
  thesis-type: "Master's Thesis", // this is displayed at the top of the front page
  course-of-study: "Informatics",
  student-registration-number: 123456,
  supervisor-label: "Supervisors:", // the German default supervisor label is the non-gendered "Betreuer", so you can override it here
  supervisors: ("Supervisor 1", "Supervisor 2"),
  date: datetime(year: 2055, month: 5, day: 25),
  bibliography: bibliography("bibliography.bib"),
  language: "en",
)

#include "glossaries.typ"

#include "chapters/abstract.typ"

#show: main-matter()

#todo-outline() // this is only shown if wip_enabled is set to true

#include "chapters/introduction.typ"

#include "chapters/related-work.typ"