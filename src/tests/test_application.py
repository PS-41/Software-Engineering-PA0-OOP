import pytest
from application.application import Application

@pytest.fixture
def app():
    app = Application()
    return app

def test_process_request_home(app):
    result = app.process_request('home')
    assert result == app.get_home_page_message()