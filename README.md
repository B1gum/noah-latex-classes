# Noah LaTeX classes

This repository contains two opinionated LuaLaTeX classes for university work:

- `noahnotes.cls` for lecture notes and course notes;
- `noahassignment.cls` for assignments, problem sheets, and worked solutions.

A future `noahreport.cls` class is expected to be introduced at a later date.

Both classes share typography, metadata handling, title pages, AU colours, PDF metadata, units, figures, references, and personal defaults through `noah-common.sty`.

## Contents

- [Choosing a class](#choosing-a-class)
- [Requirements and installation](#requirements-and-installation)
- [Quick start](#quick-start)
- [Class options](#class-options)
- [Shared document configuration](#shared-document-configuration)
- [Authors and personal defaults](#authors-and-personal-defaults)
- [Title pages, front matter, and PDF metadata](#title-pages-front-matter-and-pdf-metadata)
- [`noahnotes` reference](#noahnotes-reference)
- [`noahassignment` reference](#noahassignment-reference)
- [Shared commands and conventions](#shared-commands-and-conventions)
- [Built-in visual defaults](#built-in-visual-defaults)
- [Complete examples](#complete-examples)
- [Warnings, errors, and common pitfalls](#warnings-errors-and-common-pitfalls)

## Choosing a class

| Class | Intended use | Main structure | Page mode |
|---|---|---|---|
| `noahnotes` | Lecture notes, course notes, reference notes | Lectures, ordinary headings, definitions, examples, theorems | One-sided by default; optional two-sided layout |
| `noahassignment` | Homework, assignments, problem sheets, worked solutions | Problems, subproblems, assumptions, givens, derivations, results | Always one-sided |

Both classes are based on `article` with A4 paper and 11 pt text.

## Requirements and installation

### Engine

The classes require **LuaLaTeX**. Compilation with pdfLaTeX or XeLaTeX is not supported.

Recommended command:

```sh
latexmk -lualatex main.tex
```

Clean generated files with:

```sh
latexmk -C main.tex
```

### TeX packages

A reasonably complete current TeX Live or MacTeX installation is recommended. The classes load, among others:

- `babel`, `fontspec`, `unicode-math`, `microtype`, and `siunitx`;
- `geometry`, `setspace`, `fancyhdr`, `titlesec`, and `tocloft`;
- `graphicx`, `import`, `transparent`, `caption`, and `subcaption`;
- `mathtools`, `cleveref`, `hyperref`, `nameref`, and `refcount`;
- `enumitem`, `tabularx`, `booktabs`, and `array`;
- `tcolorbox`; plus `needspace` in `noahnotes` and `lastpage` in `noahassignment`.

### Fonts and fallbacks

The shared package selects the first available font in each row:

| Role | Preferred | First fallback | Final fallback |
|---|---|---|---|
| Serif text | Libertinus Serif | — | Latin Modern Roman |
| Sans serif | Source Sans 3 | Source Sans Pro | Latin Modern Sans |
| Monospace | JuliaMono | Inconsolata | Latin Modern Mono |
| Mathematics | Libertinus Math | — | Latin Modern Math |

The documents therefore compile without the preferred fonts, but their appearance may differ.

### Project-local installation

The simplest arrangement is to keep the class files beside the main document:

```text
course-project/
├── main.tex
├── noahnotes.cls          # or noahassignment.cls
├── noah-common.sty
├── noah-private.cfg       # optional and normally private
└── figures/
    ├── AU.pdf
    └── ...
```

The default logo and `\incfig` both expect a project-level `figures/` directory.

### User-wide installation

To make the classes available to every project, determine your personal TeX tree:

```sh
kpsewhich -var-value=TEXMFHOME
```

On macOS with MacTeX this is commonly `~/Library/texmf`. A suitable installation directory is:

```text
$TEXMFHOME/tex/latex/noah/
├── noahnotes.cls
├── noahassignment.cls
├── noah-common.sty
└── noah-private.cfg       # optional
```

After copying the files, verify discovery with:

```sh
kpsewhich noahnotes.cls
kpsewhich noahassignment.cls
kpsewhich noah-common.sty
```

The default `logo={figures/AU.pdf}` remains relative to the document project. Each project should therefore contain that file, or set another path with the `logo` key.

## Quick start

### Notes

```tex
\documentclass[english,screen,oneside]{noahnotes}

\title{Control Systems Notes}
\author{Noah Rahbek Bigum Hansen}
\studentid{202405538}
\date{4 August 2026}

\documentsetup{
  course={Advanced Control and Mechanical Systems},
  course-code={MECH-500},
  course-short={Advanced Control},
  instructor={Ada Lovelace},
  semester={Autumn 2026}
}

\begin{document}
\frontmatter
\maketitle
\tableofcontents

\mainmatter
\lecture[State space]{1}{2026-08-04}{State-space models}
\label{lec:state-space}

\section{Continuous-time systems}
Text.

\begin{definition}[State vector]
A state vector contains enough information to determine the future response.
\end{definition}

\end{document}
```

### Assignment

```tex
\documentclass[english,screen,final]{noahassignment}

\title{Assignment 1}
\author{Noah Rahbek Bigum Hansen}
\studentid{202405538}

\documentsetup{
  course={Advanced Control and Mechanical Systems},
  course-code={MECH-500},
  course-short={Advanced Control},
  running-title={Assignment 1},
  semester={Autumn 2026},
  submission-date={11 August 2026},
  submission-date-iso={2026-08-11},
  problem-numbering=automatic,
  subproblem-numbering=letters,
  toc-subproblems=true
}

\begin{document}
\frontmatter
\maketitle
\tableofcontents

\mainmatter
\begin{problem}
Determine the response of the system.

\begin{subproblems}
  \subproblem Derive the governing equation.\label{prob:response:derive}
  \subproblem Evaluate the limiting case.\label{prob:response:limit}
\end{subproblems}
\end{problem}

\begin{assumptions}
  \item Small deformations.
\end{assumptions}

\begin{givens}
  m &= \qty{2}{\kilogram} \\
  k &= \qty{10}{\newton\per\meter}
\end{givens}

\begin{derivation}
\begin{align}
  m\ddot{x}+kx &= 0.
\end{align}
\end{derivation}

\begin{finalresult}
The natural frequency is
\[
  \omega_n=\sqrt{\frac{k}{m}}.
\]
\end{finalresult}

\end{document}
```

## Class options

Options are supplied in the ordinary `\documentclass[...]` list. The last option in a mutually exclusive group wins.

### Options shared by both classes

| Option | Effect | Default |
|---|---|---|
| `english` | Loads English `babel` conventions, English generated labels, decimal point, and automatic English title casing | Yes |
| `danish` | Loads Danish `babel` conventions, Danish generated labels, decimal comma, and leaves typed heading capitalisation unchanged | No |
| `draft` | Adds a pale diagonal `DRAFT` watermark behind page content and a 5 pt overfull-box rule | No |
| `final` | Disables draft watermark and overfull-box rule | Yes |
| `print` | Hides hyperlink borders and colours with `hidelinks` | No |
| `screen` | Uses coloured hyperlinks chosen by the class | Yes |
| `oneside` | Selects a one-sided document layout | Yes |

`graphicx` is deliberately loaded with `final`, so the `draft` class option does **not** suppress figures.

### `noahnotes`-only option

| Option | Effect | Default |
|---|---|---|
| `twoside` | Loads `article` in two-sided mode and uses mirrored running heads with page numbers in the header | No |

In one-sided notes, the page number is centred in the footer. In two-sided notes, page number, abbreviated author, and short course name are mirrored across the spread.

### `noahassignment`-only option

| Option | Effect | Default |
|---|---|---|
| `anonymous` | Replaces author information with the candidate number on the title page and in the header; removes the PDF author metadata | No |

`noahassignment` is always one-sided. Supplying `twoside` produces a class error.

### Unknown options

The classes do not forward unknown options to `article`. A misspelled or unsupported option produces a class error listing the allowed options.

## Shared document configuration

Use `\documentsetup{...}` in the preamble. It accepts a comma-separated key-value list:

```tex
\documentsetup{
  course={Continuum Mechanics},
  course-code={MECH-301},
  course-short={Continuum},
  instructor={Instructor Name},
  semester={Autumn 2026}
}
```

Braces are recommended around values containing commas or other punctuation.

### Shared keys

| Key | Value | Default or fallback | Used for |
|---|---|---|---|
| `course` | Text | Empty | Full course name on title pages and in generated PDF subject metadata |
| `course-code` | Text | Empty | Official course number; shown right-aligned across from the course name on title pages |
| `course-short` | Text | Full `course` value | Short course name in notes headers and assignment footer |
| `short-course` | Text | Alias of `course-short` | Backwards-compatible alias |
| `running-title` | Text | Document `\title` | Assignment centre header and internal running-title fallback |
| `short-title` | Text | Alias of `running-title` | Backwards-compatible alias |
| `instructor` | Text | Empty | Optional title-page row |
| `semester` | Text | Empty | Optional title-page row |
| `department` | Text | Language-dependent AU department name | Title page |
| `university` | Text | Language-dependent AU university name | Title page |
| `logo` | File path | `figures/AU.pdf` | Title-page logo |
| `pdf-subject` | Text | Generated from class type and course | PDF metadata |
| `document-date-iso` | `YYYY-MM-DD` text | Compilation date | General ISO date and assignment-header fallback |
| `submission-date` | Display text | Empty | Assignment title page |
| `submission-date-iso` | Usually `YYYY-MM-DD` | `document-date-iso` | Assignment right header |
| `candidate-number` | Text | Empty | Anonymous assignment title page and header |
| `toc-depth` | Integer | `2` in both classes | Sets the standard `tocdepth` counter |

The class-specific assignment keys accepted by the same command are documented under [Assignment setup keys](#assignment-setup-keys).

### Default department and university

With `english`:

```text
Department of Mechanical and Production Engineering
Aarhus University
```

With `danish`:

```text
Institut for Mekanik og Produktion
Aarhus Universitet
```

Override either value when writing for another department or institution:

```tex
\documentsetup{
  department={Department of Civil and Architectural Engineering},
  university={Aarhus University},
  logo={figures/custom-logo.pdf}
}
```

### Course-name fallbacks

The related course values are intentionally used differently:

- title pages use the full `course`, with `course-code` aligned at the right when present;
- notes headers use `course-short`, falling back to the full `course`;
- assignment footers use `course-short`; if it is absent, they use `course-code`; if both are absent, they use the full `course`;
- generated PDF subjects use the full course followed by the code in parentheses.

### Recommended timing

Place `\documentsetup` in the preamble. In particular, assignment subproblem numbering is installed at `\begin{document}`, so `subproblem-numbering` should not be changed later in the document.

## Authors and personal defaults

### Standard author commands

```tex
\author{Primary Author}
\studentid{123456789}
\addauthor{Second Author}{987654321}
\addauthor{Third Author}{112233445}
```

- `\author{...}` sets or replaces the primary author.
- `\studentid{...}` sets or replaces the primary author's student ID.
- `\addauthor{name}{student ID}` appends an additional author.
- Each author and student ID share a title-page row, with the ID aligned at the right.
- Assignment running heads use the final space-separated element of each author's name as the surname.
- Notes running heads use an abbreviated form of the primary author's name. A name with at least three parts is formatted as first name, middle initials, surname; for example, `Noah Rahbek Bigum Hansen` becomes `Noah R. B. Hansen`.

### Personal defaults with `noah-private.cfg`

If `noah-private.cfg` is discoverable by TeX, `noah-common.sty` loads it automatically. A minimal file is:

```tex
\ProvidesFile{noah-private.cfg}[Personal defaults for the Noah classes]
\NoahDefaultAuthor{Noah Rahbek Bigum Hansen}{202405538}
```

Document-level `\author` and `\studentid` calls override the first default author and ID. Additional authors can still be appended with `\addauthor`.

### Anonymous assignments

Use both the class option and a candidate number:

```tex
\documentclass[anonymous]{noahassignment}
\documentsetup{candidate-number={ABC-1234}}
```

The convenience command below sets the same value:

```tex
\candidatenumber{ABC-1234}
```

In anonymous mode:

- the title page shows the candidate number instead of author rows;
- the left header shows the candidate number;
- PDF author metadata is empty;
- author data may still exist internally but is not displayed by the class.

## Title pages, front matter, and PDF metadata

### `\title`, `\date`, and `\maketitle`

Both classes use the standard `\title{...}` command and redefine `\maketitle`.

`noahnotes` additionally displays the standard `\date{...}` value. If `\date` is omitted, the standard LaTeX default is `\today`.

`noahassignment` does not display `\date`; use `submission-date` instead.

### Front matter and main matter

Although the underlying class is `article`, the shared package provides book-like commands:

```tex
\frontmatter  % clears the page and switches to lower-case Roman numbering
\mainmatter   % clears the page and switches to Arabic numbering
```

A typical notes document uses:

```tex
\frontmatter
\maketitle
\tableofcontents
\mainmatter
```

If `\maketitle` is called while front matter is active, the next front-matter page is numbered ii.

Assignments may omit `\frontmatter` and `\mainmatter`. When the title page is created outside front matter, the class delays the Arabic page-number reset until the first `problem` begins, so the first problem starts at page 1.

When an assignment includes a table of contents, the recommended structure is `\frontmatter`, title page, contents, then `\mainmatter`. This avoids reusing an Arabic page number and therefore avoids duplicate PDF page-anchor warnings.

### Title-page fields

`noahnotes` displays, when available:

1. department and university;
2. title;
3. authors and student IDs;
4. course and course code;
5. instructor;
6. semester;
7. date;
8. logo.

`noahassignment` displays, when available:

1. department and university;
2. title;
3. authors and student IDs, or candidate number in anonymous mode;
4. course and course code;
5. instructor;
6. semester;
7. submission date;
8. logo.

Blank optional metadata rows are omitted. A missing logo produces a package warning and leaves the title page without a logo.

### PDF metadata

At the beginning of the document, the classes set:

- PDF title from `\title`, with English title casing when applicable;
- PDF author from all authors separated by semicolons, except in anonymous mode;
- PDF subject from `pdf-subject`, or an automatically generated description;
- PDF creator to `LuaLaTeX with the Noah classes`.

Default generated subjects are equivalent to:

```text
Lecture notes for Full Course Name (COURSE-CODE)
Assignment for Full Course Name (COURSE-CODE)
```

The wording is localised in Danish mode.

## `noahnotes` reference

### Notes options and layout

Default declaration:

```tex
\documentclass[english,final,screen,oneside]{noahnotes}
```

The notes layout uses:

- A4 paper, 11 pt;
- 23 mm top, 24 mm bottom, and 24 mm side margins;
- 1.15 line spacing;
- paragraph spacing of roughly `0.48\baselineskip` and no paragraph indentation;
- section numbering through subsubsections;
- table of contents depth 2 by default.

### Running heads

One-sided notes show:

- short course name at the left of the header;
- abbreviated primary author at the right;
- page number centred in the footer.

Two-sided notes mirror the same information:

- even pages: page number, abbreviated author, short course name;
- odd pages: short course name, abbreviated author, page number.

The header blocks use fixed-width minipages, allowing long values to wrap instead of overlapping.

### Lecture command

Syntax:

```tex
\lecture[short title]{identifier}{date}{title}
```

Arguments:

| Argument | Meaning |
|---|---|
| Optional `short title` | A shorter navigation form retained for custom running styles; defaults to the full lecture title |
| `identifier` | Visible manual lecture identifier, such as `1`, `2A`, or `Week 3` |
| `date` | Displayed at the right in AU blue; no date format is enforced |
| `title` | Full lecture title, displayed in black and written to the table of contents |

Example:

```tex
\lecture[State space]{L03}{2026-08-18}{State-space representations}
\label{lec:state-space}
```

Important behaviour:

- `\lecture` advances an internal lecture counter only to create unique anchors;
- the visible identifier is exactly the supplied identifier;
- it does **not** advance or reset the section counter;
- it creates a lecture-level table-of-contents entry without dotted leaders;
- the title is automatically title-cased in English and left unchanged in Danish;
- the command reserves enough vertical room to avoid leaving a lecture heading stranded at the bottom of a page;
- place `\label` immediately after the command to reference it reliably.

References use the localised lecture name:

```tex
See \cref{lec:state-space}.
See \mref{lec:state-space}.
```

### Ordinary headings

The class retains the standard interfaces:

```tex
\section{heading}
\section[short TOC heading]{long heading}
\section*{unnumbered heading}
```

The same applies to `\subsection` and `\subsubsection`.

In English mode, all three heading levels are automatically title-cased, including optional table-of-contents titles. In Danish mode, typed capitalisation is preserved.

The visual hierarchy is:

| Level | Main-text appearance | TOC appearance |
|---|---|---|
| Section | Large bold sans serif, dark AU blue | Bold sans serif, dark AU blue |
| Subsection | Large-ish bold sans serif, AU blue | Sans serif, AU blue |
| Subsubsection | Normal-size bold sans serif, dark AU blue | Sans serif, dark AU blue |
| Lecture | Normal black sans serif with blue date | Slightly larger black sans serif, vertically separated, no dotted leader |

### Definition environment

Syntax:

```tex
\begin{definition}[optional title]
Content.
\end{definition}
```

Example:

```tex
\begin{definition}[Controllability]\label{def:controllability}
A system is controllable when every state can be reached in finite time.
\end{definition}
```

Definitions:

- are numbered within sections as `section.definition`;
- use the green box family;
- are deliberately not breakable across pages;
- reserve approximately seven lines before starting;
- use the optional title as both displayed subtitle and reference name.

### Example environment

The environment is named `exa` to avoid collisions with other packages:

```tex
\begin{exa}[optional title]
Content.
\end{exa}
```

Examples:

- are numbered within sections as `section.example`;
- use the orange box family;
- may break across pages;
- use the optional title as both displayed subtitle and reference name.

### Theorem and proof environment

The theorem environment is named `sæt`:

```tex
\begin{sæt}[optional title]\label{thm:stability}
The theorem statement.

\proofpart
The proof.
\end{sæt}
```

The ASCII-safe invocation `\begin{s\ae t}` is **not** defined; the environment name is the literal Unicode name `sæt` and is supported by LuaLaTeX.

Theorems:

- are numbered within sections as `section.theorem`;
- use the purple box family;
- may break across pages;
- use the optional title as both displayed subtitle and reference name.

`\proofpart` switches to the lower tcolorbox section, inserts a separator line, and prints the localised proof label. It is intended for use inside `sæt`.

### Figure and table numbering

In `noahnotes`, figures and tables are numbered within sections:

```text
Figure 2.1, Figure 2.2, ...
Table 2.1, Table 2.2, ...
```

### Notes warnings

The class warns when `\title` is missing. Shared author warnings also apply.

## `noahassignment` reference

### Assignment options and layout

Default declaration:

```tex
\documentclass[english,final,screen,oneside]{noahassignment}
```

The assignment layout uses:

- A4 paper, 11 pt, always one-sided;
- 27 mm top and bottom margins and 28 mm side margins;
- 1.25 line spacing;
- paragraph spacing of roughly `0.62\baselineskip` and no paragraph indentation;
- section numbering through subsections (`secnumdepth=2`);
- table of contents depth 2 by default.

### Assignment setup keys

These keys extend the shared `\documentsetup` interface.

| Key | Accepted values | Default | Effect |
|---|---|---|---|
| `problem-numbering` | `automatic`, `manual` | `automatic` | Chooses whether the class generates problem numbers or requires an explicit identifier |
| `subproblem-numbering` | `letters`, `decimal`, `compact` | `letters` | Selects subproblem labels and reference forms |
| `toc-subproblems` | `true`, `false` | `true` | Enables or disables automatic subproblem table-of-contents entries |

Example:

```tex
\documentsetup{
  problem-numbering=manual,
  subproblem-numbering=compact,
  toc-subproblems=false
}
```

### Running head and footer

The assignment header contains:

- authors' surnames at the left, or candidate number in anonymous mode;
- `running-title` at the centre, falling back to the document title;
- `submission-date-iso` at the right, falling back to `document-date-iso`.

The footer contains:

- compact course name at the left;
- localised `p. current of total` text at the right.

The total page count comes from `lastpage`, so a second compilation may be required.

### Problem environment

Syntax:

```tex
\begin{problem}[problem options]
Statement.
\end{problem}
```

In manual-numbering mode:

```tex
\begin{problem}[problem options]{identifier}
Statement.
\end{problem}
```

Every problem:

- begins on a new page through `\clearpage`;
- creates a table-of-contents entry;
- creates a reference anchor;
- ends with a dark blue closing rule by default.

#### Automatic numbering

```tex
\documentsetup{problem-numbering=automatic}

\begin{problem}\label{prob:first}
Statement.
\end{problem}
```

The class generates `1`, `2`, `3`, and so on. Supplying an identifier in automatic mode is an error.

#### Manual numbering

```tex
\documentsetup{problem-numbering=manual}

\begin{problem}{A3}\label{prob:a3}
Statement.
\end{problem}
```

The supplied identifier is displayed exactly as written. Omitting it in manual mode is an error.

#### Problem option: `closing-rule`

The optional problem key controls the rule after the problem statement:

```tex
\begin{problem}[closing-rule=false]
Statement without a closing rule.
\end{problem}
```

Accepted values are `true` and `false`; the default is `true` for every problem.

The intended document structure is to place only the statement and its subproblems inside `problem`. Assumptions, givens, derivation, and results normally follow after `\end{problem}` so the closing rule separates the supplied problem from the solution.

### Subproblems

Use the `subproblems` list together with `\subproblem`:

```tex
\begin{subproblems}
  \subproblem First part.\label{prob:1:a}
  \subproblem Second part.\label{prob:1:b}
\end{subproblems}
```

Do not use plain `\item` when you want the class to create a subproblem table-of-contents entry.

The numbering schemes are:

| `subproblem-numbering` | Printed label | Reference form | Typical sequence |
|---|---|---|---|
| `letters` | Bold `(a)` | `1(a)` | `(a)`, `(b)`, `(c)` |
| `decimal` | Bold `1.1` | `1.1` | `1.1`, `1.2`, `1.3` |
| `compact` | Bold `1a` | `1a` | `1a`, `1b`, `1c` |

Place a `\label` after `\subproblem` to reference that item.

#### Omitting one subproblem from the contents

The starred form creates the item and number but suppresses its table-of-contents entry:

```tex
\subproblem* Administrative or minor part.
```

The global `toc-subproblems=false` key suppresses all automatic subproblem entries.

### `problemwithimage`

This environment places a short problem statement beside an ordinary image.

Syntax:

```tex
\begin{problemwithimage}[image width]{image file}
Statement.
\end{problemwithimage}
```

Manual-numbering mode additionally accepts an identifier:

```tex
\begin{problemwithimage}[0.38\linewidth]{figures/mechanism.pdf}{B2}
Determine the mechanism's mobility.
\end{problemwithimage}
```

Arguments:

| Argument | Meaning | Default |
|---|---|---|
| Optional image width | Width of the right minipage | `0.42\linewidth` |
| Image file | Passed to `\includegraphics` | Required |
| Optional manual identifier | Passed to `problem` | Absent |

The horizontal gap is controlled by the public length `\pbfigsep`, whose default is 6 mm:

```tex
\setlength{\pbfigsep}{8mm}
```

The text minipage receives the remaining width. `problemwithimage` does not expose the `problem` environment's `closing-rule` key.

### Assumptions

```tex
\begin{assumptions}
  \item Small deformations.
  \item Linear material response.
\end{assumptions}
```

The optional argument replaces the localised heading:

```tex
\begin{assumptions}[Modelling assumptions]
  \item ...
\end{assumptions}
```

### Givens

`givens` produces a centred two-column table with a vertical AU-blue separator. The left column is automatically in mathematics mode; the right column is ordinary text mode.

```tex
\begin{givens}
  m &= \qty{2}{\kilogram} \\
  k &= \qty{10}{\newton\per\meter} \\
  x_0 &= Initial displacement
\end{givens}
```

Its optional argument replaces the localised heading:

```tex
\begin{givens}[Known quantities]
...
\end{givens}
```

### Derivation

```tex
\begin{derivation}
\begin{align}
  F &= ma,\\
  a &= \frac{F}{m}.
\end{align}
\end{derivation}
```

The environment:

- prints a localised heading;
- permits page breaks inside multi-line displays;
- uses compact display-math spacing;
- accepts an optional replacement heading.

### Exercise heading

`\exercise{identifier}` inserts an unnumbered assignment-style exercise heading:

```tex
\exercise{4.7}
```

It does not create a counter, table-of-contents entry, or reference anchor.

### Generic AU heading

`\AUheading{text}` creates the same small bold dark-blue sans-serif heading used by `assumptions`, `givens`, and `derivation`:

```tex
\AUheading{Verification}
```

### Result environments

#### Intermediate result

```tex
\begin{result}
The reaction force is \(R=\qty{4.2}{\kilo\newton}\).
\end{result}
```

`result` is a white, breakable box with a 2 pt AU-blue rule at the left and the localised title `Result` or `Resultat`.

#### Final result

```tex
\begin{finalresult}
The design satisfies the stated requirement.
\end{finalresult}
```

`finalresult` is a breakable pale-blue box with a 4 pt dark-blue rule and the localised title `Final result` or `Endeligt resultat`.

Both are `tcolorbox` environments and accept per-instance tcolorbox options:

```tex
\begin{result}[title={Subproblem result}]
...
\end{result}
```

A useful pattern for multiple subresults and one summarising result is:

```tex
\begin{result}[title={Result for 1(a)}]
...
\end{result}

\begin{result}[title={Result for 1(b)}]
...
\end{result}

\begin{finalresult}[title={Combined result}]
...
\end{finalresult}
```

### Figure and table numbering

In `noahassignment`, figures and tables are numbered continuously across the document rather than within sections.

### Assignment warnings

At the beginning of the document, the class warns when:

- `\title` is missing;
- `course` is missing;
- `submission-date` is missing;
- anonymous mode is active but `candidate-number` is missing.

## Shared commands and conventions

### Mathematics

| Command | Output or purpose |
|---|---|
| `\Vec{x}` | Bold italic mathematical vector |
| `\Mat{A}` | Bold upright mathematical matrix |
| `\Re` | Upright `Re` operator |
| `\Im` | Upright `Im` operator |
| `\grad` | Upright `grad` operator |

Examples:

```tex
\[
  \Vec{x}=\Mat{A}\Vec{u},
  \qquad \Re(z)>0,
  \qquad \grad T=\Vec{0}.
\]
```

These definitions intentionally replace LaTeX's traditional Fraktur-style `\Re` and `\Im` glyphs.

### Units and numbers

The classes preload `siunitx` with:

- decimal comma in Danish and decimal point in English;
- thin-space digit grouping for numbers with at least five digits;
- `\cdot` as the exponent product;
- fraction-style per units by default;
- font detection enabled.

Standard `siunitx` commands are available:

```tex
\num{12345.67}
\qty{9.81}{\meter\per\second\squared}
\si{\newton\per\meter}
```

Two convenience commands use positive powers instead of fractions for compound units:

```tex
\iqty[siunitx options]{number}{unit}
\isi[siunitx options]{unit}
```

Examples:

```tex
\iqty{9.81}{\meter\per\second\squared}
\isi{\newton\per\meter}
```

The optional argument is forwarded to `siunitx`:

```tex
\iqty[round-mode=places,round-precision=2]{9.80665}{\meter\per\second\squared}
```

### Figures

`graphicx` is preloaded and searches `./figures/` by default:

```tex
\includegraphics[width=0.7\linewidth]{diagram.pdf}
```

The classes also load `caption` and `subcaption`.

#### Inkscape PDF+LaTeX figures

Use:

```tex
\incfig[scale]{filename}
```

Example:

```tex
\begin{figure}
  \centering
  \incfig[0.8]{free-body-diagram}
  \caption{Free-body diagram.}
\end{figure}
```

This command expects:

```text
figures/free-body-diagram.pdf
figures/free-body-diagram.pdf_tex
```

and internally imports `figures/free-body-diagram.pdf_tex`. The optional scale multiplies `\columnwidth`; its default is `1`.

A typical Inkscape export uses “PDF” with “Omit text in PDF and create LaTeX file” enabled.

### References

The classes preload `cleveref` with `nameinlink` and `noabbrev`, so ordinary references are available:

```tex
\cref{fig:response}
\Cref{fig:response}
```

The custom commands append the referenced object's stored title when one exists:

```tex
\mref{label}
\Mref{label}
```

Example output can resemble:

```text
definition 2.1: Controllability
Definition 2.1: Controllability
```

Use `\mref` for lower-case reference names and `\Mref` at the start of a sentence. These commands create one hyperlink containing both number and title.

For named formal boxes, place the label after the environment begins:

```tex
\begin{definition}[Controllability]\label{def:controllability}
...
\end{definition}
```

In Danish mode, equation, lecture, problem, subproblem, definition, example, and theorem reference names are localised by the classes.

### Title casing

In English mode:

- the document title is title-cased on the title page and in PDF metadata;
- ordinary section, subsection, and subsubsection titles are title-cased;
- lecture titles and optional short lecture titles are title-cased;
- common short English words such as `a`, `an`, `the`, `and`, `for`, `in`, `of`, and `to` remain lower-case where appropriate.

In Danish mode, no automatic title casing is performed.

When exact English capitalisation matters, protect material using normal LaTeX grouping or commands that `titlecaps` preserves, and inspect the result. Acronyms and specialised notation may otherwise require adjustment.

### Public AU colours

The shared package defines these `xcolor` names:

```text
AUblue          AUblueDark
AUpurple        AUpurpleDark
AUcyan          AUcyanDark
AUturquoise     AUturquoiseDark
AUgreen         AUgreenDark
AUyellow        AUyellowDark
AUorange        AUorangeDark
AUred           AUredDark
AUmagenta       AUmagentaDark
AUgray
NoahPaperGray
```

They can be used anywhere an `xcolor` colour is accepted:

```tex
\textcolor{AUblueDark}{Text}
```

### Standard packages already available

The class preamble already provides common interfaces for:

- `align`, `gather`, and related `mathtools` environments;
- `tabularx`, `booktabs`, and custom column specifications;
- `enumerate` and `itemize` customisation with `enumitem`;
- `figure`, `table`, `subfigure`, and captions;
- hyperlinks, URLs, labels, and clever references.

Loading the same package again is usually unnecessary. Additional package options should be tested for compatibility with the class's existing setup.

## Built-in visual defaults

These values are design defaults rather than document-level keys.

### Shared typography

- no paragraph indentation;
- serif body text, sans-serif headings and metadata, Unicode mathematics;
- subtle microtype kerning immediately inside text parentheses and square brackets;
- A4 paper and 11 pt base size;
- AU blue title-page stripe at the lower-left edge;
- title-page logo at the lower right;
- hanging, ragged-right captions with bold labels;
- list margins automatically fit the surrounding text width.

### Screen link colours

`noahnotes` uses dark AU blue for internal links, URLs, and citations.

`noahassignment` uses dark AU blue for internal links and URLs, while citations are black.

`print` replaces these with hidden links.

### Heading and contents consistency

Each class deliberately makes table-of-contents typography echo the corresponding in-text heading hierarchy. Lectures are the exception: they remain visually subdued and black, while their dates are blue in the main text.

### Draft behaviour

`draft` adds:

- a pale grey `DRAFT` watermark behind all page content;
- visible 5 pt rules for overfull boxes.

It does not remove figures.

## Complete examples

### Complete notes example

```tex
\documentclass[english,screen,twoside]{noahnotes}

\title{Advanced Control Systems}
\author{Noah Rahbek Bigum Hansen}
\studentid{202405538}
\date{Autumn 2026}

\documentsetup{
  course={Advanced Control and Mechanical Systems},
  course-code={MECH-500},
  course-short={Advanced Control},
  instructor={Ada Lovelace},
  semester={Autumn 2026},
  toc-depth=2
}

\begin{document}

\frontmatter
\maketitle
\tableofcontents

\mainmatter

\lecture[State models]{1}{4 August 2026}{State-space models}
\label{lec:state-models}

\section{Definitions and notation}

Let \(\Vec{x}\) denote the state vector and \(\Mat{A}\) the state matrix.

\begin{definition}[State]\label{def:state}
The state is the smallest collection of variables that determines the future
behaviour of the system given its future input.
\end{definition}

\begin{exa}[Second-order model]\label{ex:second-order}
A mass-spring system can be written as
\[
  \dot{\Vec{x}}=\Mat{A}\Vec{x}+\Mat{B}\Vec{u}.
\]
\end{exa}

\begin{sæt}[Existence of a state transition matrix]\label{thm:stm}
For a continuous matrix \(\Mat{A}(t)\), a state transition matrix exists.

\proofpart
The result follows from the existence and uniqueness theorem for linear
ordinary differential equations.
\end{sæt}

As stated in \Mref{def:state}, the selected variables must determine the future
response. See also \cref{thm:stm}.

\begin{figure}
  \centering
  \fbox{\rule{0pt}{35mm}\rule{0.65\linewidth}{0pt}}
  \caption{Example placeholder figure.}
  \label{fig:example}
\end{figure}

\end{document}
```

### Complete assignment example

```tex
\documentclass[english,screen,final]{noahassignment}

\title{Assignment 2: Vibrations}
\author{Noah Rahbek Bigum Hansen}
\studentid{202405538}

\documentsetup{
  course={Mechanical Vibrations},
  course-code={MECH-402},
  course-short={Vibrations},
  running-title={Assignment 2},
  instructor={Instructor Name},
  semester={Autumn 2026},
  submission-date={18 August 2026},
  submission-date-iso={2026-08-18},
  problem-numbering=automatic,
  subproblem-numbering=letters,
  toc-subproblems=true
}

\begin{document}

\frontmatter
\maketitle
\tableofcontents

\mainmatter
\begin{problem}\label{prob:oscillator}
A mass is connected to a linear spring. Neglect damping.

\begin{subproblems}
  \subproblem Derive the governing equation.\label{prob:oscillator:equation}
  \subproblem Determine the natural frequency.\label{prob:oscillator:frequency}
  \subproblem* Comment on the limiting case \(m\to0\).
\end{subproblems}
\end{problem}

\begin{assumptions}
  \item The spring is linear.
  \item Motion is one-dimensional.
\end{assumptions}

\begin{givens}
  m &= \qty{2}{\kilogram} \\
  k &= \qty{18}{\newton\per\meter}
\end{givens}

\begin{derivation}[Subproblem 1(a)]
\begin{align}
  \sum F &= m\ddot{x},\\
  -kx &= m\ddot{x},\\
  m\ddot{x}+kx &= 0.
\end{align}
\end{derivation}

\begin{result}[title={Result for 1(a)}]
The governing equation is
\[
  m\ddot{x}+kx=0.
\]
\end{result}

\begin{derivation}[Subproblem 1(b)]
Assuming \(x(t)=X\mathrm{e}^{st}\) gives
\[
  ms^2+k=0.
\]
\end{derivation}

\begin{result}[title={Result for 1(b)}]
\[
  \omega_n=\sqrt{\frac{k}{m}}=\qty{3}{\radian\per\second}.
\]
\end{result}

\begin{finalresult}[title={Combined result}]
The undamped response satisfies
\[
  m\ddot{x}+kx=0,
  \qquad
  \omega_n=\sqrt{\frac{k}{m}}.
\]
\end{finalresult}

\end{document}
```

## Warnings, errors, and common pitfalls

### Compile with LuaLaTeX

Symptom:

```text
The Noah classes require LuaLaTeX
```

Fix:

```sh
latexmk -lualatex main.tex
```

### Missing class or shared package

Use `kpsewhich` to verify the installation:

```sh
kpsewhich noahnotes.cls
kpsewhich noah-common.sty
```

For a project-local setup, confirm that the `.cls` and `.sty` files are beside the main `.tex` file.

### Missing logo

The default is:

```tex
logo={figures/AU.pdf}
```

Either create that path in the document project or override it:

```tex
\documentsetup{logo={assets/university-logo.pdf}}
```

A missing logo is non-fatal and produces a warning.

### Missing author

Create `noah-private.cfg` or add:

```tex
\author{Your Name}
\studentid{Your ID}
```

### Missing assignment metadata

Assignments warn about missing `course` and `submission-date`. Supply both in `\documentsetup`.

Remember that `submission-date` is the human-readable title-page value, while `submission-date-iso` controls the compact header value.

### Anonymous mode without candidate number

Use:

```tex
\documentclass[anonymous]{noahassignment}
\documentsetup{candidate-number={...}}
```

### Manual problem-numbering errors

With:

```tex
\documentsetup{problem-numbering=manual}
```

every problem needs an identifier:

```tex
\begin{problem}{A1}
```

With automatic numbering, remove the identifier:

```tex
\begin{problem}
```

### Missing subproblem TOC entries

Use `\subproblem`, not plain `\item`, and ensure:

```tex
\documentsetup{toc-subproblems=true}
```

A starred `\subproblem*` is intentionally omitted from the contents.

### Duplicate `page.1` destination warning

Use explicit front and main matter when a table of contents precedes the first problem:

```tex
\frontmatter
\maketitle
\tableofcontents
\mainmatter
```

This gives the contents Roman page numbers and begins the first problem at Arabic page 1 without reusing a PDF page anchor.

### Total page count is unresolved

Compile the assignment again. `lastpage` needs an auxiliary-file pass to resolve the final page reference.

### Inkscape figure not found

For:

```tex
\incfig{diagram}
```

both files must exist:

```text
figures/diagram.pdf
figures/diagram.pdf_tex
```

The filename argument should not include `.pdf_tex`.

### Table of contents is stale

Heading, lecture, problem, and subproblem entries normally require at least two compilations before the table of contents and page numbers are current.

### English title casing changes an acronym

Automatic casing is intentional in English mode. Protect or explicitly format specialised text and inspect the compiled result. Danish mode never changes typed capitalisation.

---

The supported public interface consists of the class options, `\documentsetup` keys, commands, environments, lengths, and colour names documented above. Internal commands containing `@` and implementation-level `\Noah...` helpers are not intended as stable document APIs unless explicitly described in this README.
