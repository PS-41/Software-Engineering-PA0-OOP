import pytest
from models.person import Person

def test_person_initialization():
    person = Person(
        username="testuser",
        password="testpass",
        name="testname",
        status="teststatus",
        session_token="testsession",
        updated="2024-08-28"
    )
    assert person.username == "testuser"
    assert person.password == "testpass"
    assert person.name == "testname"
    assert person.status == "teststatus"
    assert person.session_token == "testsession"
    assert person.updated == "2024-08-28"

def test_person_to_dict():
    person = Person(
        username="testuser",
        password="testpass",
        name="testname",
        status="teststatus",
        session_token="testsession",
        updated="2024-08-28"
    )
    person_dict = person.to_dict()
    expected_dict = {
        'username': "testuser",
        'password': "testpass",
        'name': "testname",
        'status': "teststatus",
        'session_token': "testsession",
        'updated': "2024-08-28"
    }
    assert person_dict == expected_dict
