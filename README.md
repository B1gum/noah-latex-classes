# Noah LaTeX classes

Opinionated LuaLaTeX classes and packages for engineering notes, assignments, and project reports.

The repository contains three document classes and two shared packages:

| File | Purpose |
|---|---|
| `noahnotes.cls` | Lecture notes, course notes, and reference notes |
| `noahassignment.cls` | Assignments, problem sheets, and worked solutions |
| `rdproject.cls` | Engineering project and report documents |
| `noah-common.sty` | Shared typography, metadata, references, units, figures, and document infrastructure |
| `noah-matlab.sty` | Optional MATLAB-export compatibility and source-code styling |

All classes require **LuaLaTeX**.

## Quick start

A complete, compiling example and its associated pdf is provided for every public class/package:

```text
examples/
├── noahnotes/main.tex
├── noahassignment/main.tex
├── rdproject/main.tex
└── noah-matlab/main.tex
```

Compile all examples from the repository root with:

```sh
./scripts/compile-examples.sh
```

or compile one example from its directory with `latexmk` and the repository `latexmkrc`.

## Choosing a class

| Class | Best for | Main structure | Page mode |
|---|---|---|---|
| `noahnotes` | Lecture/course notes | Lectures, headings, definitions, examples, theorems | One-sided by default; optional two-sided |
| `noahassignment` | Homework and worked solutions | Problems, subproblems, givens, derivations, results | One-sided |
| `rdproject` | Engineering reports and semester projects | Chapters, front matter, nomenclature, bibliography, appendices | One- or two-sided |

`noah-matlab.sty` is not a document class per se although a document using it is shown in the associated `examples/noah-matlab/main.tex`-file. Load it when a document contains MATLAB-exported LaTeX or MATLAB source code.

## Minimal examples

### Notes

```tex
\documentclass[english,screen,oneside]{noahnotes}

\title{Control Systems Notes}
\author{Your Name}
\studentid{123456789}

\documentsetup{
  course={Control Systems},
  course-code={MECH-500},
  course-short={Control},
  semester={Autumn 2026}
}

\begin{document}
\frontmatter
\maketitle
\tableofcontents

\mainmatter
\lecture[State space]{1}{2026-10-08}{State-Space Models}
\section{Continuous-time systems}

\begin{definition}[State vector]
A state vector contains sufficient information to determine the future state.
\end{definition}
\end{document}
```

### Assignment

```tex
\documentclass[english,screen,final]{noahassignment}

\title{Assignment 1}
\author{Your Name}
\studentid{123456789}

\documentsetup{
  course={Mechanics},
  course-code={MECH-201},
  semester={Autumn 2026},
  submission-date={15 October 2026},
  problem-numbering=automatic,
  subproblem-numbering=letters
}

\begin{document}
\maketitle

\begin{problem}
Determine the natural frequency.
\end{problem}

\begin{givens}
  m & \qty{2}{\kilogram} \\
  k & \qty{10}{\newton\per\meter}
\end{givens}
\end{document}
```

### Project report

```tex
\documentclass[oneside]{rdproject}

\title{Thermoforming Foam Cores}
\author{Your Name}
\studentid{123456789}

\documentsetup{
  course={R\&D Project},
  course-code={MECH-PRJ},
  semester={Autumn 2026},
  supervisor={Supervisor Name},
  submission-date={18 December 2026}
}

\begin{document}
\frontmatter
\maketitle
\begin{abstract}
Short project abstract.
\end{abstract}
\tableofcontents

\mainmatter
\chapter{Introduction}
Project text.

\backmatter
\printreferences
\end{document}
```

### MATLAB support

```tex
\documentclass{article}
\usepackage{noah-matlab}

\begin{document}
\begin{matlabcode}
x = linspace(0, 2*pi, 200);
y = sin(x);
plot(x, y)
\end{matlabcode}
\end{document}
```

## Installation

### Project-local

Place the required class/package files where TeX can find them, for example beside the document:

```text
project/
├── main.tex
├── noah-common.sty
├── noahnotes.cls          # or noahassignment.cls / rdproject.cls
├── noah-matlab.sty        # only when needed
└── figures/
    └── AU.pdf
```

### User-wide

Install the repository files under your personal TeX tree, for example on macOS:

```text
~/Library/texmf/tex/latex/noah/
```

You can inspect the configured location with:

```sh
kpsewhich -var-value=TEXMFHOME
```

Then verify discovery with, for example:

```sh
kpsewhich noahnotes.cls
kpsewhich noah-common.sty
```

## Personal defaults

The repository ships `noah-private.example.cfg`. Copy it to:

```text
noah-private.cfg
```

and replace the placeholder values. The real file is intentionally ignored by Git.

This allows author details to remain local while the public classes stay reusable.

## Documentation

- [Shared infrastructure and commands](docs/shared.md)
- [`noahnotes`](docs/noahnotes.md)
- [`noahassignment`](docs/noahassignment.md)
- [`rdproject`](docs/rdproject.md)
- [`noah-matlab`](docs/noah-matlab.md)

The `examples/` directory is the canonical source for complete working documents.

## Development

The repository examples are also regression tests. Run:

```sh
./scripts/compile-examples.sh
```

before committing class/package changes.

GitHub Actions compiles the same examples on pushes and pull requests.

## Status

These classes are intentionally opinionated and primarily developed for my personal engineering work at Aarhus University. Their public APIs aim to remain backwards-compatible where practical, but the project is still evolving.

## License

This project is licensed under the MIT License. See [`LICENSE`](LICENSE).
