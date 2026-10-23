import importlib.util
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('vps_host', Path(__file__).with_name('vps-host.py'))
host = importlib.util.module_from_spec(spec)
spec.loader.exec_module(host)


class EnvironmentInputTest(unittest.TestCase):
    def test_restore_retains_data_and_rejects_unknown_extensions(self):
        source = '1; 1 1 SCHEMA - tiger owner\n2; 2 2 TABLE DATA public synthetic_history owner\n'
        selected = host.restore_toc(source)
        self.assertTrue(selected.startswith(';1;'))
        self.assertIn('2; 2 2 TABLE DATA public synthetic_history owner', selected)
        with self.assertRaises(ValueError):
            host.extension_sql({'extensions': [{'extname': 'unreviewed_extension'}]})

    def test_values_are_data_and_public_inline_comments_are_supported(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'fixture'
            path.write_text('VPS_API_HOST=fixture.duckdns.org # public\nDATA=$(never-execute)\nQUOTED="literal # value"\n')
            actual = host.environment(path)
            self.assertEqual(actual['VPS_API_HOST'], 'fixture.duckdns.org')
            self.assertEqual(actual['DATA'], '$(never-execute)')
            self.assertEqual(actual['QUOTED'], 'literal # value')

    def test_duplicate_or_multiline_inputs_fail_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'fixture'
            for contents in ['KEY=value\nKEY=second\n', 'KEY="unterminated\n']:
                path.write_text(contents)
                with self.assertRaises(ValueError):
                    host.environment(path)

    def test_raw_secret_inputs_match_compose_without_interpolation(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'fixture'
            path.write_text('PASSWORD=literal$UNDEFINED #suffix\nQUOTED="literal"\n')
            actual = host.environment(path, raw=True)
            self.assertEqual(actual['PASSWORD'], 'literal$UNDEFINED #suffix')
            self.assertEqual(actual['QUOTED'], '"literal"')


if __name__ == '__main__':
    unittest.main()
