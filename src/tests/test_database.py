import pytest
import json
from models.person import Person
from database.database import UserDatabase

def create_db_helper():
    test_user_data = {'testuser': 
    {
        'username': "testuser",
        'password': "testpass",
        'name': "testname",
        'status': "teststatus",
        'session_token': "testsession",
        'updated': "2024-08-28"
    }}
    db_path = 'src/database/users.json'
    with open(db_path, 'w') as file:
        json.dump(test_user_data, file, indent = 4)
    test_db = UserDatabase(db_path)
    return test_db

def create_person_helper():
    return Person(
        username="testuser",
        password="testpass",
        name="testname",
        status="teststatus",
        session_token="testsession",
        updated="2024-08-28"
    )

def test_add_person():
    test_db = create_db_helper()
    test_person = create_person_helper()
    assert test_db.add_person(test_person) == False
    test_person.username = "testuser2"
    assert test_db.add_person(test_person) == True

def test_authenticate_user():
    test_db = create_db_helper()
    test_username = "testuser"
    test_password = "testpass"
    test_db.data[test_username]['session_token'] = None
    actual = test_db.authenticate_user(test_username, test_password).to_dict()
    expected = create_person_helper().to_dict()
    assert actual['status'] == expected['status']
    test_password = "testpassword"
    actual = test_db.authenticate_user(test_username, test_password)
    expected = None
    assert actual == None
    actual = test_db.authenticate_user('invalide', 'invalid')
    assert actual == None

def test_delete_user():
    test_db = create_db_helper()
    actual = test_db.delete_user('testuser')
    expected = "[account deleted]\n"
    assert actual == expected

def test_update_user():
    test_db = create_db_helper()
    actual = test_db.update_user('testuser', 'updatedname', 'updatedstatus')
    expected = "[name and status updated]"
    assert actual == expected
    actual = test_db.update_user('testuser', '', 'updatedstatus2')
    expected = "[status updated]"
    assert actual == expected
    actual = test_db.update_user('testuser', 'updatedname2', '')
    expected = "[name updated]"
    assert actual == expected
    actual = test_db.update_user('testuser', '', '')
    expected = ""
    assert actual == expected

def test_logout_user():
    test_db = create_db_helper()
    actual = test_db.logout_user('testuser')
    expected = "[you are now logged out]\n"
    assert actual == expected

def test_validate_session_token():
    test_db = create_db_helper()
    actual = test_db.validate_session_token('testsession')
    expected = "testuser"
    assert actual['username'] == expected
    actual = test_db.validate_session_token('invalid')
    assert actual == None

def test_find_by_pattern():
    test_db = create_db_helper()
    pattern = "pattern"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    expected_str = "No one is here..."
    assert actual_str.startswith(expected_str)
    pattern = "username:def"
    expected_str = "No one is here..."
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_str == expected_str
    pattern = "username:testuser"
    expected_field = "username"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field
    pattern = "name:testuser"
    expected_field = "name"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field
    pattern = "name:testname"
    expected_field = "name"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field
    pattern = "status:testuser"
    expected_field = "status"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field
    pattern = "status:teststatus"
    expected_field = "status"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field
    pattern = "updated:testuser"
    expected_field = "updated"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field
    pattern = "updated:2024-08-28"
    expected_field = "updated"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field
    pattern = "testuser"
    expected_field = "any"
    actual_field, actual_value, actual_str = test_db.find_by_pattern(pattern)
    assert actual_field == expected_field

def test_get_person():
    test_db = create_db_helper()
    actual = test_db.get_person('invalid')
    assert actual == None

def test_show_people():
    test_db = create_db_helper()
    person = Person("testuser", "password123", "Test User", "active", "session", "active")
    actual = test_db.show_people([person], {'username': 'testuser', 'password': '12345', 'status': 'status', 'name': 'name', 
                         'session_token': 'session_token', 'updated': 'updated'})
    assert actual != None