import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
from noah_frontpage.cli import escape, main


class FrontpageTests(unittest.TestCase):
    def test_plain_text(self):
        self.assertEqual(escape('R&D_50% {x}'), r'R\&D\_50\% \{x\}')
        self.assertEqual(escape('a\nb'), 'a b')
        self.assertEqual(escape('\\input{x}'), r'\textbackslash{}input\{x\}')

    def test_export_and_overwrite(self):
        with tempfile.TemporaryDirectory() as d:
            args = ['--title', 'R&D', '--member', 'Søren Æ', '', '--tex-only',
                    '-o', str(Path(d) / 'test.pdf')]
            self.assertEqual(main(args), 0)
            tex = (Path(d) / 'test.tex').read_text()
            self.assertIn(r'\title{R\&D}', tex)
            self.assertIn(r'\addauthor{Søren Æ}{}', tex)
            self.assertEqual(len(list(Path(d).glob('*/rdproject.cls'))), 1)
            with self.assertRaises(SystemExit):
                main(args)

    def test_compiler_contract(self):
        with tempfile.TemporaryDirectory() as d:
            output = Path(d) / 'result.pdf'
            def run(command, **kwargs):
                self.assertIn('-no-shell-escape', command)
                self.assertNotIn('shell', kwargs)
                root = Path(kwargs['cwd'])
                self.assertTrue((root / 'frontpage.tex').is_file())
                (root / 'frontpage.pdf').write_bytes(b'%PDF-test')
                return subprocess.CompletedProcess(command, 0, 'Output written on frontpage.pdf (1 page, 123 bytes).')
            with patch('noah_frontpage.cli.shutil.which', return_value='/bin/lualatex'), patch('noah_frontpage.cli.subprocess.run', side_effect=run):
                self.assertEqual(main(['--title', 'Test', '--member', 'A', '1', '-o', str(output)]), 0)
            self.assertEqual(output.read_bytes(), b'%PDF-test')

    def test_failed_compile_does_not_publish(self):
        with tempfile.TemporaryDirectory() as d:
            output = Path(d) / 'result.pdf'
            with patch('noah_frontpage.cli.shutil.which', return_value='/bin/lualatex'), patch('noah_frontpage.cli.subprocess.run', return_value=subprocess.CompletedProcess([], 1, 'missing package')):
                self.assertEqual(main(['--title', 'Test', '--member', 'A', '1', '-o', str(output)]), 1)
            self.assertFalse(output.exists())

    def test_invalid_combinations(self):
        for extra in (['--course-code', 'X'], ['--tex-only', '--open']):
            with self.assertRaises(SystemExit):
                main(['--title', 'Test', '--member', 'A', '1', *extra])
