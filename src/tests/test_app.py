import unittest
from unittest.mock import patch, MagicMock
import sys
import argparse
from application.application import Application

from src.app import main

class TestApp(unittest.TestCase):

    @patch('src.app.Application')
    @patch('argparse.ArgumentParser.parse_args')
    def test_main_with_empty_request(self, mock_parse_args, mock_application):
        mock_parse_args.return_value = argparse.Namespace(request=[])
        mock_app_instance = MagicMock()
        mock_application.return_value = mock_app_instance
        with patch.object(sys, 'argv', ['app.py']):
            main()
        mock_app_instance.run.assert_called_once_with('')

    @patch('src.app.Application')
    @patch('argparse.ArgumentParser.parse_args')
    def test_main_with_non_empty_request(self, mock_parse_args, mock_application):
        mock_parse_args.return_value = argparse.Namespace(request=['create', 'username=test', 'password=123'])
        mock_app_instance = MagicMock()
        mock_application.return_value = mock_app_instance
        with patch.object(sys, 'argv', ['app.py', 'create', 'username=test', 'password=123']):
            main()
        mock_app_instance.run.assert_called_once_with('create username=test password=123')

if __name__ == '__main__':
    unittest.main()
