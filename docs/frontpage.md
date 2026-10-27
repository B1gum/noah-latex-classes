# Front-page CLI

Generate a single-page PDF with the actual `rdproject` title-page layout.
Python 3.10+ and a full, recent TeX Live (2025+) or MacTeX installation are required.
The CLI has no Python runtime dependencies. LuaLaTeX is required only for PDF generation.

## Install

From a checkout containing this CLI:

```sh
uv tool install .
# Alternatively:
pipx install .
```

Once this change is merged, anyone can install directly:

```sh
uv tool install git+https://github.com/B1gum/noah-latex-classes.git
```

## Use

```sh
frontpage \
  --title 'Thermoforming of Foam Cores' \
  --member 'Noah Rahbek Bigum Hansen' 'AU761714' \
  --member 'Another Student' 'AU123456' \
  --course 'R&D Project' \
  --course-code 'MECH-PRJ' \
  --supervisor 'Supervisor Name' \
  --semester 'Autumn 2026' \
  --date '18 December 2026' \
  --output frontpage.pdf \
  --tex --open
```

Only `--title` and one or more `--member NAME STUDENT_ID` pairs are required.
Use an empty quoted ID (`''`) to omit it. Dates are literal text, without automatic
formatting. Omitted optional fields do not produce rows. Course code requires course.
`--department` and `--university` override the class's AU defaults.
`--logo FILE` uses a PDF/PNG/JPEG; `--no-logo` hides the bundled AU logo.
All text is escaped; do not pass LaTeX markup (write `R&D`, not `R\&D`).
The original class applies English title casing and uses English labels.
Its layout has no subtitle, group-number, or cover-image field.

`--tex` exports `frontpage.tex` and a companion `frontpage-assets-...` directory.
Keep them together. To compile the exported source manually on macOS/Linux:

```sh
TEXINPUTS="./frontpage-assets-<hash>:" lualatex -no-shell-escape frontpage.tex
```

Use the actual directory name printed beside the source. `--tex-only` exports without
requiring LuaLaTeX; it cannot be combined with `--open`. `--force` replaces outputs.
`--open` uses the platform's PDF viewer on macOS, Linux, or Windows.
PDF builds run in a temporary directory with shell escape disabled; auxiliary files
are removed. Compilation failures return a nonzero status and print the end of the
LaTeX output. Multi-page output is rejected rather than silently accepted.
Very long titles, names, or author lists may exceed the original fixed layout.

## Bundled styling

The class, shared style, and logo are fixed copies from commit
`39ab48c3a36a0b9e04cb772587ef43ae816a31a0`; CLI builds do not follow updates to the
root files automatically. Provenance is recorded in `src/noah_frontpage/assets/UPSTREAM.txt`.
Fonts follow the style's original fallback rules. Install New Computer Modern and
Libertinus for the intended typography. The AU logo does not imply endorsement.

## Checks

```sh
python -m unittest discover -s tests
python -m pip wheel --no-deps .
```

CI also compiles and checks a real one-page PDF using TeX Live 2025.
