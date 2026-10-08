# `noahassignment`

`noahassignment.cls` is intended for homework, problem sheets, worked solutions, and technical assignments based on "problem-solving" workflows.

See [`examples/noahassignment/main.tex`](../examples/noahassignment/main.tex) for the canonical complete example.

## Options

```tex
\documentclass[english,screen,final]{noahassignment}
```

Supported options:

- `english` / `danish`;
- `anonymous`;
- `draft` / `final`;
- `print` / `screen`;
- `oneside`.

The class is deliberately one-sided. `twoside` is rejected.

## Assignment setup keys

The class extends `\documentsetup` with assignment-specific keys, including problem numbering, subproblem numbering, and whether subproblems appear in the table of contents.

A typical setup is:

```tex
\documentsetup{
  course={Mechanics},
  course-code={MECH-201},
  semester={Autumn 2026},
  submission-date={15 October 2026},
  submission-date-iso={2026-10-15},
  problem-numbering=automatic,
  subproblem-numbering=letters,
  toc-subproblems=true
}
```

## Problems

```tex
\begin{problem}
Problem statement.
\end{problem}
```

Problems can be numbered automatically or manually according to the configured mode.

The problem environment also supports class-specific options such as a closing rule.

## Subproblems

Use:

```tex
\begin{subproblems}
  \subproblem First task.\label{prob:first}
  \subproblem Second task.\label{prob:second}
\end{subproblems}
```

A starred `\subproblem*` can be used where an entry should be omitted from the contents.

## Assumptions

```tex
\begin{assumptions}
  \item Small deformations.
  \item Linear material response.
\end{assumptions}
```

An optional heading may be supplied.

## Givens

```tex
\begin{givens}
  m & \qty{2}{\kilogram} \\
  E & Young's modulus of the homogenised composite material
\end{givens}
```

The right-hand column wraps automatically.

## Derivations and collected results

A derivation can be divided into parts:

```tex
\begin{derivation}
  \derivationpart[prob:first]
  First derivation step.
  \begin{subresult}
    First result.
  \end{subresult}

  \derivationpart[prob:second]
  Second derivation step.
\end{derivation}
```

The optional label supplied to `\derivationpart` links the corresponding marker in the collected summary back to the source subproblem.

A derivation part without a `subresult` is not inserted into the final summary, and later results retain their true part markers.

## Result environments

The class provides two result boxes:

```tex
\begin{result}
Intermediate result.
\end{result}

\begin{finalresult}
Final result.
\end{finalresult}
```

`subresult` uses `result` in place and the enclosing `derivation` automatically collects those values into a `finalresult`.

## Assignment headings

Use:

```tex
\NoahAssignmentHeading{Verification}
```

The historical `\AUheading` command remains as a compatibility alias.

## Problem with image

`problemwithimage` provides a compact problem/image layout for assignments that need an accompanying figure.
Use:

```tex
\begin{problemwithimage}{path-to-image-file}{problem number}
  problem-text.
\end{problemwithimage}
```

## Exercise headings

For exercise-style sections that are not full assignment problems, use:

```tex
\exercise{Exercise title}
```

## Anonymous assignments

Use the `anonymous` class option and provide a candidate number through `\candidatenumber` or `candidate-number` in `\documentsetup`.

Anonymous mode suppresses author identity in the relevant title/PDF metadata paths. This conforms with Aarhus University's required level of anonymity for certain exams – In such cases the `\candidatenumber` corresponds to the "kandidatnummer"-field from Wiseflow.

## Bibliography

Assignments use the shared author-year BibLaTeX setup.
