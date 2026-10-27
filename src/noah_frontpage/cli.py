"""Build a title page using an isolated, pinned LaTeX bundle."""
import argparse
from importlib.resources import files
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ESCAPES = dict(zip('\\{}$&#%_^~', (
    r'\textbackslash{}', r'\{', r'\}', r'\$', r'\&', r'\#',
    r'\%', r'\_', r'\textasciicircum{}', r'\textasciitilde{}')))


def escape(text):
    return ''.join(ESCAPES.get(c, ' ' if c.isspace() else c) for c in text)


def parser():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--version', action='version', version='%(prog)s 0.1.0')
    p.add_argument('--title', required=True)
    p.add_argument('--member', nargs=2, action='append', required=True,
                   metavar=('NAME', 'STUDENT_ID'), help='Repeat for each author; use "" for no ID')
    for name in ('course', 'course-code', 'supervisor', 'semester', 'department', 'university'):
        p.add_argument('--' + name)
    p.add_argument('--date', help='Submission date as literal text; omitted when unspecified')
    logos = p.add_mutually_exclusive_group()
    logos.add_argument('--logo', type=Path, help='Custom PDF, PNG, or JPEG logo')
    logos.add_argument('--no-logo', action='store_true')
    p.add_argument('-o', '--output', type=Path, default=Path('frontpage.pdf'))
    p.add_argument('--tex', action='store_true', help='Also export .tex and a companion asset directory')
    p.add_argument('--tex-only', action='store_true', help='Export source without compiling')
    p.add_argument('--open', action='store_true', dest='open_pdf')
    p.add_argument('--force', action='store_true', help='Replace existing outputs')
    return p


def source(a, asset_dir):
    lines = [r'\documentclass{rdproject}', r'\title{' + escape(a.title) + '}']
    for name, student_id in a.member:
        lines.append(r'\addauthor{' + escape(name) + '}{' + escape(student_id) + '}')
    metadata = {k: getattr(a, k.replace('-', '_')) for k in
                ('course', 'course-code', 'supervisor', 'semester', 'department', 'university')}
    metadata['submission-date'] = a.date
    metadata['logo'] = asset_dir + '/figures/logo' + (a.logo.suffix.lower() if a.logo else '.pdf')
    lines.append('\\documentsetup{\n' + ',\n'.join(
        '  ' + k + '={' + (v if k == 'logo' else escape(v)) + '}'
        for k, v in metadata.items() if v is not None) + '\n}')
    if a.no_logo:
        lines.append(r'\renewcommand{\NoahIncludeLogo}[1]{}')
    lines.extend((r'\begin{document}', r'\maketitle', r'\end{document}', ''))
    return '\n'.join(lines)


def main(argv=None):
    p = parser()
    a = p.parse_args(argv)
    if not a.title.strip() or any(not n.strip() for n, _ in a.member):
        p.error('title and member names must not be blank')
    if a.course_code and not a.course:
        p.error('--course-code requires --course')
    if a.open_pdf and a.tex_only:
        p.error('--open cannot be combined with --tex-only')
    if a.logo and (not a.logo.is_file() or a.logo.suffix.lower() not in ('.pdf', '.png', '.jpg', '.jpeg')):
        p.error('--logo must be an existing PDF, PNG, or JPEG')
    out = a.output.expanduser().absolute()
    if out.suffix.lower() != '.pdf':
        p.error('--output must end in .pdf')
    tex = out.with_suffix('.tex')
    # Constant alphabet avoids putting user-controlled filename characters in TeX paths.
    import hashlib
    asset_name = 'frontpage-assets-' + hashlib.sha256(out.name.encode()).hexdigest()[:12]
    assets_out = out.parent / asset_name
    export = a.tex or a.tex_only
    targets = ([out] if not a.tex_only else []) + ([tex, assets_out] if export else [])
    if not a.force and any(t.exists() for t in targets):
        p.error('an output already exists; use --force to replace it')
    engine = shutil.which('lualatex')
    if not a.tex_only and not engine:
        p.error('LuaLaTeX not found. Install MacTeX or a full TeX Live distribution, or use --tex-only.')
    try:
        with tempfile.TemporaryDirectory(prefix='frontpage-') as tmp:
            root = Path(tmp)
            assets = root / asset_name
            shutil.copytree(str(files('noah_frontpage').joinpath('assets')), assets)
            logo = assets / 'figures' / ('logo' + (a.logo.suffix.lower() if a.logo else '.pdf'))
            shutil.copyfile(a.logo if a.logo else assets / 'figures/AU.pdf', logo)
            document = source(a, asset_name)
            (root / 'frontpage.tex').write_text(document, encoding='utf-8')
            env = os.environ.copy()
            # Do not inherit a user's local class files or private configuration.
            env['TEXINPUTS'] = str(assets) + os.pathsep
            env['TEXMFHOME'] = str(root / 'empty-texmf')
            if not a.tex_only:
                result = subprocess.run([engine, '-no-shell-escape', '-interaction=nonstopmode',
                    '-halt-on-error', '-file-line-error', 'frontpage.tex'], cwd=root,
                    env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=120)
                if result.returncode or not (root / 'frontpage.pdf').exists():
                    print('LuaLaTeX failed:\n' + result.stdout[-7000:], file=sys.stderr)
                    return 1
                if 'Output written on frontpage.pdf (1 page,' not in result.stdout:
                    print('Front page overflowed onto multiple pages. Shorten the text or reduce authors.', file=sys.stderr)
                    return 1
            out.parent.mkdir(parents=True, exist_ok=True)
            if export:
                if assets_out.exists():
                    shutil.rmtree(assets_out)
                shutil.copytree(assets, assets_out)
                tex.write_text(document, encoding='utf-8')
                print(tex)
            if not a.tex_only:
                shutil.copyfile(root / 'frontpage.pdf', out)
                print(out)
        if a.open_pdf:
            if sys.platform == 'win32':
                os.startfile(out)
            else:
                subprocess.run(['open' if sys.platform == 'darwin' else 'xdg-open', str(out)], check=True)
        return 0
    except (OSError, subprocess.SubprocessError) as exc:
        print(f'frontpage: {exc}', file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
