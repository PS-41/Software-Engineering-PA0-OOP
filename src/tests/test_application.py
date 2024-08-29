import pytest
from application.application import Application
from models.person import Person
from database.database import UserDatabase
from unittest.mock import patch, MagicMock
import builtins

@pytest.fixture
def mock_database():
    """Fixture to initialize a mock database."""
    with patch('application.application.UserDatabase') as MockDatabase:
        db_instance = MockDatabase.return_value
        db_instance.get_all_people.return_value = []
        db_instance.add_person.return_value = True
        db_instance.authenticate_user.return_value = Person("testuser", "password123", "Test User", "active", "session", "active")
        db_instance.get_person.return_value = None
        db_instance.find_by_pattern.return_value = ("any", "", "No one is here...")
        yield db_instance

@pytest.fixture
def app(mock_database):
    """Fixture to initialize the application instance with the mocked database."""
    app_instance = Application()
    app_instance.database = mock_database  # Assign the mocked database
    return app_instance


def test_get_home_page_message(app):
    result = app.get_home_page_message()
    assert "Welcome to the App!" in result
    assert "login: ./app 'login <username> <password>'" in result
    assert "join: ./app 'join'" in result
    assert "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'" in result
    assert "show people: ./app 'people'" in result

def test_create_user_success(app, mock_database):
    result = app.create_user('create username="newuser" password="password123" name="New User" status="active"')
    assert "[account created]" in result

def test_create_user_missing_username(app):
    result = app.create_user('create password="password" name="User" status="active"')
    assert "failed to create: missing username" in result

def test_create_user_invalid_username(app):
    result = app.create_user('create username="ab" password="password" name="User" status="active"')
    assert "username is too short" in result

def test_create_user_invalid_password(app):
    result = app.create_user('create username="validuser" password="pas" name="User" status="active"')
    assert "password is too short" in result

def test_create_user_invalid_name(app):
    result = app.create_user('create username="validuser" password="password" name="" status="active"')
    assert "name is too short" in result

def test_create_user_invalid_status(app):
    result = app.create_user('create username="validuser" password="password" name="User" status=""')
    assert "status is too short" in result

def test_login_success(app, mock_database):
    mock_database.authenticate_user.return_value = Person("testuser", "password123", "Test User", "active", "session", "active")
    result = app.login('login testuser password123')
    assert "Welcome back to the App" in result

def test_login_missing_credentials(app):
    result = app.login('login')
    assert "invalid request: missing username and password" in result

def test_login_invalid_credentials(app, mock_database):
    mock_database.authenticate_user.return_value = None
    result = app.login('login invaliduser invalidpassword')
    assert "access denied: incorrect username or password" in result

def test_session_request_invalid_token(app, mock_database):
    mock_database.validate_session_token.return_value = None
    result = app.process_session_request('session invalidtoken')
    assert "invalid request: invalid session token" in result

def test_session_request_missing_token(app):
    result = app.process_session_request('session')
    assert "access denied: missing session token" in result

def test_show_people_no_users(app, mock_database):
    mock_database.get_all_people.return_value = []
    mock_database.show_people.return_value = "No users found."
    result = app.show_people('people')
    assert "No one is here..." in result

def test_find_no_results(app, mock_database):
    mock_database.find_by_pattern.return_value = ("any", "", "No one is here...")
    result = app.find('find nonexistingpattern')
    assert "No one is here..." in result

def test_sort_people(app, mock_database):
    mock_database.get_all_people.return_value = [
        Person("user1", "pass1", "User One", "active"),
        Person("user2", "pass2", "User Two", "inactive")
    ]
    result = app.sort('sort username')
    assert "People (sorted by username, a-z)" in result

def test_join_user_creation(app):
    with patch('builtins.input', side_effect=['newuser', 'password123', 'password123', 'New User', 'active']):
        result = app.join('join')
        assert "[account created]" in result

def test_logout_user(app, mock_database):
    mock_database.logout_user.return_value = "[you are now logged out]\n"
    result = app.logout('logout', 'testuser')
    assert "[you are now logged out]" in result

def test_delete_user(app, mock_database):
    mock_database.delete_user.return_value = "[account deleted]\n"
    result = app.delete('delete', 'testuser')
    assert "[account deleted]" in result

def test_update_user(app, mock_database):
    mock_database.get_person.return_value = Person("testuser", "password123", "Test User", "active", "session", "active")
    mock_database.update_user.return_value = "[name and status updated]"
    result = app.update('update name="Updated Name" status="Updated Status"', 
                        {'username': 'testuser', 'password': '12345', 'status': 'status', 'name': 'name', 
                         'session_token': 'session_token', 'updated': 'updated'})
    assert "[name and status updated]" in result

def test_edit_user(app, mock_database):
    mock_database.get_person.return_value = Person("testuser", "password", "Old Name", "Old Status")
    mock_database.update_user.return_value = "[name and status updated]"
    with patch('builtins.input', side_effect=['New Name', 'New Status']):
        result = app.edit('edit', {'username': 'testuser', 'name': 'Old Name', 'status': 'Old Status'})
        assert "[name and status updated]" in result

def test_invalid_request(app):
    result = app.process_request('invalidcommand')
    assert "not found" in result

def test_process_request(app):
    result = app.process_request('')
    result = app.process_request('home')
    result = app.process_request('create')
    result = app.process_request('login')
    result = app.process_request('session')
    result = app.process_request('people')
    result = app.process_request('show')
    result = app.process_request('find')
    result = app.process_request('sort')
    result = app.process_request('joinn')

def test_process_session_request(app):
    result = app.process_session_request('sessioncool')
    result = app.process_session_request('session home')
    result = app.process_session_request('session home xyz')
    result = app.process_session_request('session logout')
    result = app.process_session_request('session update')
    result = app.process_session_request('session delete')
    result = app.process_session_request('session people')
    result = app.process_session_request('session show')
    result = app.process_session_request('session find')
    result = app.process_session_request('session prakhar')

def test_show_person(app, mock_database):
    result = app.show_person('showcool')
    result = app.show_person('show ps41')
    mock_database.get_person.return_value = Person("testuser", "password", "Old Name", "Old Status", "session", "updated")
    result = app.show_person('show ps41',
        {'username': 'testuser', 'password': '12345', 'status': 'status', 'name': 'name', 
                         'session_token': 'session_token', 'updated': 'updated'})

def test_sort(app):
    result = app.sort('sort updated desc')
    result = app.sort('sort updated asc')

def test_sort_helper(app):
    result = app.sort_helper([], 'name', 'asc')