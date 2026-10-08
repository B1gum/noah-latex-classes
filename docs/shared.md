# Shared infrastructure

`noah-common.sty` contains infrastructure shared by `noahnotes`, `noahassignment`, and `rdproject`. It is normally loaded by the classes rather than directly.

## Engine and typography

The classes require LuaLaTeX. The shared typography stack prefers:

- New Computer Modern Book for body text;
- Libertinus Sans for sans-serif text and headings;
- JuliaMono, then Inconsolata, for monospace text;
- Libertinus Math for mathematics;
- STIX Two Math for `\intercal` when available.

Fallbacks are provided when a preferred font is unavailable.

## Shared document setup

Use `\documentsetup{...}` for document metadata and shared configuration.

Common keys include:

```tex
\documentsetup{
  course={Course name},
  course-code={COURSE-101},
  course-short={Short name},
  running-title={Short running title},
  instructor={Instructor Name},
  semester={Autumn 2026},
  department={Department name},
  university={University name},
  logo={figures/AU.pdf},
  pdf-subject={PDF subject},
  submission-date={15 October 2026},
  submission-date-iso={2026-10-15},
  candidate-number={12345},
  toc-depth=2
}
```

Classes may extend this key family with class-specific options.

## Authors

The shared author API is:

```tex
\author{Primary Author}
\studentid{123456789}
\addauthor{Second Author}{987654321}
```

For local defaults, copy `noah-private.example.cfg` to `noah-private.cfg` and edit the values.

## Front, main, and back matter

All classes have shared matter commands:

```tex
\frontmatter
\mainmatter
\backmatter
```

`\frontmatter` switches to Roman page numbering, `\mainmatter` switches to Arabic numbering, and `\backmatter` leaves the current numbering unchanged while marking the document as outside front matter.

## Mathematics

Vectors and matrices use bold mathematical forms:

```tex
\Vec{x}
\Mat{A}
```

The shared package also defines `\grad` and conventional real/imaginary-part operators.

## Units and numbers

`siunitx` is loaded centrally. The shared configuration is deliberately neutral about ordinary per-unit rendering so each class can impose a document convention where necessary.

Two inline helpers force powers instead of fractions:

```tex
\iqty{12}{\meter\per\second}
\isi{\newton\per\meter}
```

Optional `siunitx` options may be passed as the first argument.

## Figures

Ordinary figures use standard LaTeX commands. The default figure search path includes `./figures/`.

For Inkscape PDF+LaTeX exports:

```tex
\incfig[0.8]{diagram}
```

loads `figures/diagram.pdf_tex` with an `\svgwidth` of `0.8\columnwidth`.

An optional caption can be supplied:

```tex
\incfig[0.8]{diagram}[System geometry]
```

## References

The shared reference API includes:

```tex
\mref{fig:model}
\Mref{fig:model}
```

Use `\Mref` at the beginning of a sentence and `\mref` in running prose. Structural references may include their referenced title; equation references retain equation-style parentheses and support multiple labels.

Citation helpers include:

```tex
\cite{key}
\citepage{key}{p. 12}
\textcitepage{key}{pp. 12--14}
```

The classes choose the BibLaTeX style. Notes and assignments use author-year citations; `rdproject` uses IEEE-style numeric references.

## Title casing

English headings are automatically title-cased by the class infrastructure. Danish headings are left unchanged.

## AU colours

The shared package exposes the official AU palette through names such as:

```text
AUblue       AUblueDark
AUpurple     AUpurpleDark
AUcyan       AUcyanDark
AUturquoise  AUturquoiseDark
AUgreen      AUgreenDark
AUyellow     AUyellowDark
AUorange     AUorangeDark
AUred        AUredDark
AUmagenta    AUmagentaDark
AUgray
```

## Draft and print modes

Classes provide `draft`/`final` and `print`/`screen` options.

Draft mode adds an overfull-box marker and a `DRAFT` watermark. Print mode uses hidden hyperlink styling where appropriate.
