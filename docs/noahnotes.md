# `noahnotes`

`noahnotes.cls` is intended for lecture notes.

See [`examples/noahnotes/main.tex`](../examples/noahnotes/main.tex) for the canonical complete example.

## Options

```tex
\documentclass[english,screen,oneside]{noahnotes}
```

Supported options:

- `english` / `danish`;
- `draft` / `final`;
- `print` / `screen`;
- `oneside` / `twoside`.

## Lecture headings

The main notes-specific structural command is:

```tex
\lecture[Short title]{identifier}{date}{Full title}
```

Example:

```tex
\lecture[State space]{5}{2026-10-08}{State-Space Representations}
\label{lec:state-space}
```

The optional short title is used in running navigation. Before the first lecture, ordinary section marks provide the running context.

## Running headers

One-sided notes show the current lecture/section and course context in the header, with the page number in the footer.

Two-sided notes use mirrored headers with course identity, lecture/section navigation, and page numbers.

## Ordinary headings

Use standard LaTeX sectioning:

```tex
\section{...}
\subsection{...}
\subsubsection{...}
```

English titles are automatically title-cased.

## Definition, example, and theorem boxes

Preferred environment names are:

```tex
\begin{definition}[Optional title]
...
\end{definition}

\begin{example}[Optional title]
...
\end{example}

\begin{theorem}[Optional title]
...
\end{theorem}
```

The historical aliases `exa` and `sæt` remain available for backwards compatibility. The preferred English names avoid requiring non-ASCII environment names.

Inside theorem-like material, `\proofpart` starts a proof section using the localized proof label.

## Numbering

Definitions, examples, and theorems are numbered within sections.

Figures and tables also follow the class's notes-oriented numbering conventions.

## Bibliography

`noahnotes` requests an author-year BibLaTeX style and installs the shared full-citation hyperlink behavior.

Add a bibliography database in the document as usual:

```tex
\addbibresource{references.bib}
```

and print it with standard BibLaTeX commands.
