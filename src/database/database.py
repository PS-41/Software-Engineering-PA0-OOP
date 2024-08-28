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

    def update_session_token(self, username):
        self.data[username]['session_token'] = uuid.uuid4().hex
        self.save_data()

    def get_person(self, username):
        if username in self.data.keys():
            return Person(username = username, password = self.data[username]['password'], 
                name = self.data[username]['name'], status = self.data[username]['status'],
                session_token = self.data[username]['session_token'], 
                updated = self.data[username]['updated'])
        return None

    def add_person(self, person):
        if person.username in self.data:
            return False
        self.data[person.username] = person.to_dict()
        self.save_data()
        return True

    def authenticate_user(self, username, password):
        if username in self.data:
            if self.data[username]['password'] == password:
                if not self.data[username]['session_token']:
                    self.update_session_token(username)
                return Person(**(self.data[username]))
            else:
                return None
        return None

    def validate_session_token(self, session_token):
        for user_info in self.data.values():
            if user_info.get('session_token') == session_token:
                return user_info
        return None

    def logout_user(self, username):
        self.data[username]['session_token'] = None
        self.save_data()
        return "[you are now logged out]\n"

    def update_user(self, username, updated_name, updated_status):
        flag_update_name = False
        flag_update_status = False
        return_value = ""
        if updated_name and self.data[username]['name'] != updated_name:
            flag_update_name = True
            self.data[username]['name'] = updated_name
        if updated_status and self.data[username]['status'] != updated_status:
            flag_update_status = True
            self.data[username]['status'] = updated_status
        if flag_update_name or flag_update_status:
            self.data[username]['updated'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        self.save_data()
        if flag_update_name:
            if flag_update_status:
                return_value = "[name and status updated]"
            else:
                return_value = "[name updated]"
        elif flag_update_status:
            return_value = "[status updated]"
        return return_value

    def delete_user(self, username):
        del self.data[username]
        self.save_data()
        return "[account deleted]\n"

    def get_all_people(self):
        person_list = []
        for key in self.data:
            person_list.append(self.get_person(key))
        return person_list

    def show_people(self, person_list, user_info = None):
        return_value = ""
        for person in person_list:
            return_value += person.name
            return_value += " @"
            return_value += person.username
            return_value += f" (./app 'show {person.username}')\n"
            return_value += f"  {person.status}\n"
            return_value += f"  @ {person.updated}\n"
            if user_info and person.username == user_info['username']:
                return_value += f"  edit: ./app 'session {user_info['session_token']} edit'\n"
        return return_value

    def find_by_pattern(self, pattern):
        person_list = self.get_all_people()
        field = "any"
        value = pattern        
        if ':' in pattern:
            field, value = pattern.split(':', 1)
            field = field.strip()
            value = value.strip()
        matching_persons_list = []
        for person in person_list:
            if field == 'username':
                if value in person.username:
                    matching_persons_list.append(person)
            elif field == 'name':
                if value in person.name:
                    matching_persons_list.append(person)
            elif field == 'status':
                if value in person.status:
                    matching_persons_list.append(person)
            elif field == 'updated':
                if value in person.updated:
                    matching_persons_list.append(person)
            else:
                if value in person.username or value in person.name or value in person.status or value in person.updated:
                    matching_persons_list.append(person)
        value = f'"{value}" in '
        if len(matching_persons_list) == 0:
            return field, value, "No one is here..."
        return field, value, self.show_people(matching_persons_list)
