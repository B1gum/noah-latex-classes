# `rdproject`

`rdproject.cls` is intended for engineering semester projects, R&D projects, technical reports, and other chapter-based project documents. The `.cls`-file was made for use as part of the 5th semester R&D project at the Bachelor of Science in Mechanical Engineering at Aarhus University.

See [`examples/rdproject/main.tex`](../examples/rdproject/main.tex) for the canonical complete example.

## Options

```tex
\documentclass[oneside]{rdproject}
```

Supported options:

- `draft` / `final`;
- `print` / `screen`;
- `oneside` / `twoside`.

The class is English-only by design.

## Project metadata

`rdproject` extends `\documentsetup` with:

```tex
supervisor={Supervisor Name}
```

A typical project setup is:

```tex
\documentsetup{
  course={R\&D Project},
  course-code={MECH-PRJ},
  semester={Autumn 2026},
  supervisor={Supervisor Name},
  submission-date={18 December 2026}
}
```

The title page uses project-specific author/student-ID and course/course-code presentation while the underlying metadata remains shared.

## Front matter

The class provides project-specific `abstract` and `preface` environments:

```tex
\frontmatter
\maketitle

\begin{abstract}
...
\end{abstract}

\begin{preface}
...
\end{preface}

\tableofcontents
```

Use:

```tex
\printlistoffigures
\printlistoftables
```

when the corresponding lists are wanted in the contents.

## Nomenclature

`rdproject` loads `glossaries-extra` and defines a project-oriented nomenclature style with a custom `unit` field.

The complete example demonstrates symbols, abbreviations, units, glossary groups, and printing the nomenclature.

## Main matter

The document is chapter-based:

```tex
\mainmatter
\chapter{Introduction}
\section{Background}
\subsection{Method}
```

Chapters, sections, and subsections are numbered; deeper headings remain available through LaTeX but are not part of the default numbered hierarchy.

## Figures and tables

Project figure captions use IEEE-style `Fig.` labeling and period punctuation.

The class provides project-oriented TOC/LOF/LOT typography and running headers for one- and two-sided output.

## Units

`rdproject` selects symbolic per-unit rendering through `siunitx` while the shared package remains neutral.

## Bibliography

The class requests:

```text
style=ieee
sorting=none
```

and applies project-specific bibliography cleanup. It also supplies a custom `standard` bibliography driver suitable for ISO and similar standards.

Print the bibliography with:

```tex
\backmatter
\printreferences
```

## Appendices

Use standard LaTeX appendix mode:

```tex
\appendix
\chapter{Supplementary calculations}
```

The class configures appendix references so `\mref` / `\Mref` retain the expected appendix naming and hyperlinks.
