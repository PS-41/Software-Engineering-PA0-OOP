import unittest
from unittest.mock import patch, MagicMock
import sys
import argparse
from application.application import Application

# Import the main function from the app module
from src.app import main

class TestApp(unittest.TestCase):

    @patch('src.app.Application')
    @patch('argparse.ArgumentParser.parse_args')
    def test_main_with_empty_request(self, mock_parse_args, mock_application):
        """
        Test case for main() when no arguments are passed (empty request).
        """
        # Simulate no arguments passed
        mock_parse_args.return_value = argparse.Namespace(request=[])
        
        # Create a mock Application instance
        mock_app_instance = MagicMock()
        mock_application.return_value = mock_app_instance
        
        # Call the main function
        with patch.object(sys, 'argv', ['app.py']):
            main()
        
        # Verify that Application.run() was called with an empty string
        mock_app_instance.run.assert_called_once_with('')

    @patch('src.app.Application')
    @patch('argparse.ArgumentParser.parse_args')
    def test_main_with_non_empty_request(self, mock_parse_args, mock_application):
        """
        Test case for main() when arguments are passed (non-empty request).
        """
        # Simulate command-line arguments
        mock_parse_args.return_value = argparse.Namespace(request=['create', 'username=test', 'password=123'])

        # Create a mock Application instance
        mock_app_instance = MagicMock()
        mock_application.return_value = mock_app_instance
        
        # Call the main function
        with patch.object(sys, 'argv', ['app.py', 'create', 'username=test', 'password=123']):
            main()

        # Verify that Application.run() was called with the correct joined request string
        mock_app_instance.run.assert_called_once_with('create username=test password=123')

if __name__ == '__main__':
    unittest.main()
