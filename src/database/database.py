import json
import os
from models.person import Person
import uuid
from datetime import datetime

class UserDatabase:
    def __init__(self, db_name):
        self.db_name = db_name
        self.load_data()

    def load_data(self):
        if os.path.exists(self.db_name):
            with open(self.db_name, 'r') as file:
                self.data = json.load(file)
        else:
            self.data = {}

    def save_data(self):
        with open(self.db_name, 'w') as file:
            json.dump(self.data, file, indent = 4)

    def add_person(self, person):
        if person.username in self.data:
            print('Username already present')
            return False
        self.data[person.username] = person.to_dict()
        self.save_data()
        return True

    def authenticate_user(self, username, password):
        if username in self.data:
            if self.data[username]['session_token']:
                return f"User {self.data[username]['name']} already logged in!\n\n", Person(**(self.data[username]))
            if self.data[username]['password'] == password:
                self.data[username]['session_token'] = uuid.uuid4().hex
                self.data[username]['updated'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                self.save_data()
                return f"Welcome back to the App, {self.data[username]['name']}!\n\n", Person(**(self.data[username]))
        return None, None

    def validate_session_token(self, session_token):
        for user_info in self.data.values():
            if user_info.get('session_token') == session_token:
                return user_info
        return None

    def logout_user(self, username):
        self.data[username]['session_token'] = None
        self.save_data()
