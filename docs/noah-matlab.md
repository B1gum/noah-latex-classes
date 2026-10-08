# `noah-matlab`

`noah-matlab.sty` is a MATLAB compatibility and styling package that aims to reproduce the internal styling and coloring from MATLAB as much as possible in LaTeX-formatted MATLAB code. It is independent of the Noah document classes and can be loaded from an ordinary LaTeX document.

See [`examples/noah-matlab/main.tex`](../examples/noah-matlab/main.tex) for the canonical example.

## Purpose

The package preserves the command/environment names expected by MATLAB's LaTeX export while replacing global document-side effects with a contained, consistent visual style. This means most, if not all, styling should be applied automatically just by loading the package.

Loading:

```tex
\usepackage{noah-matlab}
```

is intended to make MATLAB-exported fragments usable without also inheriting MATLAB's historical global paragraph or hyperlink styling.

## MATLAB source code

Use:

```tex
\begin{matlabcode}
x = linspace(0, 2*pi, 200);
y = sin(x);
plot(x, y)
\end{matlabcode}
```

`matlabcode` uses the package's `NoahMatlab` listings style automatically.

The same style can also be used directly:

```tex
\begin{lstlisting}[style=NoahMatlab]
...
\end{lstlisting}
```

## Export-compatible environments

The package provides the MATLAB-oriented environments used by exported documents, including:

```tex
\begin{matlaboutput}
...
\end{matlaboutput}

\begin{matlabsymbolicoutput}
...
\end{matlabsymbolicoutput}

\begin{matlabtableoutput}{...}
...
\end{matlabtableoutput}
```

These are compatibility surfaces rather than general-purpose replacements for LaTeX mathematics or tables. In particular, `matlabsymbolicoutput` is text/verbatim-like output; do not treat it as a raw math-mode environment.

## Export-compatible headings

The package also provides:

```tex
\matlabtitle{...}
\matlabheading{...}
\matlabheadingtwo{...}
\matlabheadingthree{...}
\matlabtableofcontents{...}
```

plus the state commands expected by MATLAB export:

```tex
\matlabmultipletitles
\matlabhastoc
```

## Scope

`noah-matlab` deliberately does not set global page layout, paragraph indentation, or hyperlink colours. Those choices belong to the surrounding document class.
