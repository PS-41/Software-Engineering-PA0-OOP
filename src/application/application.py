from database.database import UserDatabase
from models.person import Person
import re
import uuid
from datetime import datetime

class Application:
    """ Main class for our application to manage all workflows """

    def __init__(self):
        self.database = UserDatabase("src/database/users.json")

    def run(self, request):
        try:
            output = self.process_request(request)
            self.display_output(output)
        except Exception as e:
            self.handle_exception(e)

    def handle_exception(self, e):
        self.display_output('Please check the input is valid and try again!')
        self.display_output('The following error occured:')
        self.display_output(e)

    def display_output(self, output):
        print(output)

    def process_request(self, request):
        if request == '' or request == 'home' or request.startswith("home "):
            return self.get_home_page_message()
        elif request.startswith("create"):
            return self.create_user(request)
        elif request.startswith("login"):
            return self.login(request)
        elif request.startswith("session"):
            return self.process_session_request(request)
        elif request.startswith("people"):
            return self.show_people(request)
        elif request.startswith("show"):
            return self.show_person(request)
        elif request.startswith("find"):
            return self.find(request)
        elif request.startswith("sort"):
            return self.sort(request)
        elif request.startswith("join"):
            return self.join(request)
        elif request == 'logout' or request == 'delete' or request == 'update' or request == 'edit':
            return(
                "invalid request: missing session token\n\n"
                "home: ./app\n"
                )
        else:
            return(
                "not found\n"
                "home: ./app\n"
                )

    def get_home_page_message(self):
        return (
            "Welcome to the App!\n\n"
            "login: ./app 'login <username> <password>'\n"
            "join: ./app 'join'\n"
            "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'\n"
            "show people: ./app 'people'\n"
            )

    def get_home_page_message_with_session_token(self, user_info):
        return (
            f"Welcome back to the App, {user_info.get('name')}!\n\n"
            f"{user_info.get('status')}\n\n"
            f"edit: ./app 'session {user_info.get('session_token')} edit'\n"
            f"update: ./app 'session {user_info.get('session_token')} update (name=\"<value>\"|status=\"<value>\")+'\n"
            f"logout: ./app 'session {user_info.get('session_token')} logout'\n"
            f"people: ./app '[session {user_info.get('session_token')} ]people'\n"
            )

    def get_updated_message(self, user_info):
        return (
            f"edit: ./app 'session {user_info.get('session_token')} edit'\n"
            f"update: ./app 'session {user_info.get('session_token')} update (name=\"<value>\"|status=\"<value>\")+'\n"
            f"delete: ./app 'session {user_info.get('session_token')} delete'\n"
            f"logout: ./app 'session {user_info.get('session_token')} logout'\n"
            f"people: ./app '[session {user_info.get('session_token')} ]people'\n"
            f"home: ./app ['session {user_info.get('session_token')}']\n"
            )

    def get_person_message(self, person):
        return(
            "Person\n"
            "------\n"
            f"name: {person.name}\n"
            f"username: {person.username}\n"
            f"status: {person.status}\n"
            f"updated: {person.updated}\n\n"
            )

    def get_people_message(self):
        return (
            f"find: ./app 'find <pattern>'\n"
            f"sort: ./app 'sort[ username|name|status|updated[ asc|desc]]'\n"
            f"people: ./app 'people'\n"
            f"join: ./app 'join'\n"
            f"create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'\n"
            f"home: ./app\n"
            )

    def get_people_message_with_session_token(self, user_info):
        return (
            f"find: ./app 'find <pattern>'\n"
            f"sort: ./app 'sort[ username|name|status|updated[ asc|desc]]'\n"
            f"update: ./app 'session {user_info.get('session_token')} update (name=\"<value>\"|status=\"<value>\")+'\n"
            f"home: ./app ['session {user_info.get('session_token')}']\n"
            )

    def create_user(self, request):
        if request == 'create':
            return(
                "failed to create: missing username\n\n"
                "home: ./app\n"
                )
        if request[len('create')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        request = request[len('create '):]
        required_keys = ['username', 'password', 'name', 'status']

        pattern = r'(\w+)\s*=\s*"(.*?)(?<!\\)"'
        matches = re.findall(pattern, request)        
        user_dict = {key: value for key, value in matches}

        for key in required_keys:
            if key not in user_dict:
                return(
                    f"failed to create: missing {key}\n\n"
                    "home: ./app\n"
                    )
        username = user_dict['username']
        password = user_dict['password']
        name = user_dict['name']
        status = user_dict['status']

        error_message = self.validate_user_name(username)
        if error_message != None:
            return "failed to create: " + error_message
        error_message = self.validate_password(password)
        if error_message != None:
            return "failed to create: " + error_message
        error_message = self.validate_name(name)
        if error_message != None:
            return "failed to create: " + error_message
        error_message = self.validate_status(status)
        if error_message != None:
            return "failed to create: " + error_message

        person = Person(username.lower(), password, name, status, session_token = uuid.uuid4().hex, 
            updated = datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

        if self.database.add_person(person):
            return (
                "[account created]\n"
                f"{self.get_person_message(person)}"
                f"{self.get_updated_message(person.to_dict())}"
                )

        return f"failed to create: {username} is already registered"

    def join(self, request):
        if len(request) > len('join') and request[len('join')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        print("New Person")
        print("----------")
        username = input("username: ")
        password = input("password: ")
        confirm_password = input("confirm password: ")
        name = input("name: ")
        status = input("status: ")
        if password != confirm_password:
            return(
                "failed to join: passwords do not match\n"
                "home: ./app\n"
                )
        error_message = self.validate_user_name(username)
        if error_message != None:
            return "failed to create: " + error_message
        error_message = self.validate_password(password)
        if error_message != None:
            return "failed to create: " + error_message
        error_message = self.validate_name(name)
        if error_message != None:
            return "failed to create: " + error_message
        error_message = self.validate_status(status)
        if error_message != None:
            return "failed to create: " + error_message

        person = Person(username.lower(), password, name, status, session_token = uuid.uuid4().hex, 
            updated = datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

        if self.database.add_person(person):
            return (
                "[account created]\n"
                f"{self.get_person_message(person)}"
                f"{self.get_updated_message(person.to_dict())}"
                )

        return f"failed to create: {username} is already registered"

    def validate_user_name(self, username):
        if len(username) < 3:
            return(
                "username is too short\n\n"
                "home: ./app\n"
                )
        if len(username) > 20:
            return(
                "username is too long\n\n"
                "home: ./app\n"
                )
        if not re.match(r'^\w+$', username):
            return(
                "invalid username\n\n"
                "home: ./app\n"
                )
        return None

    def validate_password(self, password):
        if '"' in password:
            return (
                'password contains double quote\n\n'
                "home: ./app\n"
                )
        if len(password) < 4:
            return(
                "password is too short\n\n"
                "home: ./app\n"
                )
        return None

    def validate_name(self, name):
        if '"' in name:
            return (
                'name contains double quote\n\n'
                "home: ./app\n"
                )
        if len(name) < 1:
            return (
                "name is too short\n\n"
                "home: ./app\n"
                )
        if len(name) > 30:
            return (
                "name is too long\n\n"
                "home: ./app\n"
                )
        return None

    def validate_status(self, status):
        if '"' in status:
            return (
                'status contains double quote\n\n'
                "home: ./app\n"
                )
        if len(status) < 1:
            return (
                "status is too short\n\n"
                "home: ./app\n"
                )
        if len(status) > 100:
            return (
                "status is too long\n\n"
                "home: ./app\n"
                )
        return None

    def login(self, request):
        if request == 'login':
            return(
                "invalid request: missing username and password\n\n"
                "home: ./app\n"
                )
        if request[len('login')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )

        request = request.split()
        if len(request) < 3:
            return(
                "incorrect username or password\n\n"
                "home: ./app\n"
                )
        username = request[1]
        password = ' '.join(request[2: ])

        person = self.database.authenticate_user(username, password)
        if person:
            return self.get_home_page_message_with_session_token(person.to_dict())
        return(
                "access denied: incorrect username or password\n\n"
                "home: ./app\n"
                )

    def process_session_request(self, request):
        if request == 'session':
            return(
                "access denied: missing session token\n\n"
                "home: ./app\n"
                )
        if request[len('session')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        request = request[len('session '):]
        parts = request.split()
        session_token = parts[0]
        user_info = self.database.validate_session_token(session_token)
        if user_info == None:
            return(
                "invalid request: invalid session token\n\n"
                "home: ./app\n"
                )
        
        request = request[len(session_token) + 1:]
        if request == '' or request == "home" or request.startswith("home "):
            return self.get_home_page_message_with_session_token(user_info)
        elif request.startswith("logout"):
            return self.logout(request, user_info.get('username'))
        elif request.startswith("update"):
            return self.update(request, user_info)
        elif request.startswith("delete"):
            return self.delete(request, user_info.get('username'))
        elif request.startswith('people'):
            return self.show_people(request, user_info)
        elif request.startswith('show'):
            return self.show_person(request, user_info)
        elif request.startswith('edit'):
            return self.edit(request, user_info)
        elif request.startswith('find'):
            return self.find(request, user_info)
        return(
            "not found\n\n"
            "home: ./app\n"
            )

    def logout(self, request, username):
        if request == 'logout' or request.startswith('logout '):
            return(
                f"{self.database.logout_user(username)}"
                f"{self.get_home_page_message()}"
                )
        return(
            "not found\n\n"
            "home: ./app\n"
            )

    def edit(self, request, user_info):
        if len(request) > len('edit') and request[len('edit')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        print("Edit Person")
        print("-----------")
        print("leave blank to keep [current value]")
        updated_name = input(f"name [{user_info['name']}]: ")
        updated_status = input(f"status [{user_info['status']}]: ")
        if updated_name:
            error_message = self.validate_name(updated_name)
            if error_message != None:
                return "failed to update: " + error_message
        if updated_status:
            error_message = self.validate_status(updated_status)
            if error_message != None:
                return "failed to update: " + error_message
        return(
            f"{self.database.update_user(user_info.get('username'), updated_name, updated_status)}\n"
            f"{self.get_person_message(self.database.get_person(user_info.get('username')))}"
            f"{self.get_updated_message(user_info)}"
            )


    def update(self, request, user_info):
        if request == 'update':
            return(
                "failed to update: missing name and status\n\n"
                "home: ./app\n"
                )
        if request[len('update')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        request = request[len('update '):]
        required_keys = ['name', 'status']
        pattern = r'(\w+)\s*=\s*"(.*?)(?<!\\)"'
        matches = re.findall(pattern, request)        
        args_dict = {key: value for key, value in matches}
        to_update_dict = {}
        for key in required_keys:
            if key in args_dict:
                to_update_dict[key] = args_dict[key]

        if len(to_update_dict) == 0:
            return(
                "failed to update: missing name and status\n\n"
                "home: ./app\n"
            )
        updated_name = None
        updated_status = None
        if 'name' in to_update_dict: updated_name = to_update_dict['name']
        if 'status' in to_update_dict: updated_status = to_update_dict['status']

        if updated_name != None:
            error_message = self.validate_name(updated_name)
            if error_message != None:
                return "failed to update: " + error_message
        if updated_status != None:
            error_message = self.validate_status(updated_status)
            if error_message != None:
                return "failed to update: " + error_message

        return(
            f"{self.database.update_user(user_info.get('username'), updated_name, updated_status)}\n"
            f"{self.get_person_message(self.database.get_person(user_info.get('username')))}"
            f"{self.get_updated_message(user_info)}"
            )

    def delete(self, request, username):
        if request == 'delete' or request.startswith('delete '):
            return (
                f"{self.database.delete_user(username)}"
                f"{self.get_home_page_message()}"
                )
        return(
            "not found\n\n"
            "home: ./app\n"
            )

    def show_people(self, request, user_info = None):
        if len(request) > len('people') and request[len('people')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        person_list = self.database.get_all_people()
        if len(person_list) == 0:
            return(
                "People\n"
                "------\n"
                "No one is here...\n\n"
                f"{self.get_people_message()}"
                )
        person_list = self.sort_helper(person_list, "updated", "desc")
        people = self.database.show_people(person_list, user_info)
        if user_info:
            return(
                "People\n"
                "------\n"
                f"{people}\n\n"
                f"{self.get_people_message_with_session_token(user_info)}"
            )
        else:
            return(
                "People\n"
                "------\n"
                f"{people}\n\n"
                f"{self.get_people_message()}"
            )

    def show_person(self, request, user_info = None):
        if request == 'show':
            return(
                "invalid request: missing username\n\n"
                "home: ./app\n"
                )
        if request[len('show')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        request = request.split()
        username = request[1]
        person = self.database.get_person(username)
        if person is None:
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        if user_info:
            if user_info['session_token'] == person.session_token:
                return(
                    f"{self.get_person_message(person)}"
                    f"{self.get_updated_message(user_info)}\n"
                    )
            else:
                return(
                    f"{self.get_person_message(person)}"
                    f"people: ./app '[session {user_info.get('session_token')} ]people'\n"
                    f"logout: ./app 'session {user_info.get('session_token')} logout'\n"
                    f"home: ./app ['session {user_info.get('session_token')}']\n"
                    )
        return(
            f"{self.get_person_message(person)}"
            f"people: ./app 'people'\n"
            f"home: ./app"
            )
    
    def find(self, request, user_info = None):
        if request == 'find':
            person_list = self.database.get_all_people()
            people = self.database.show_people(person_list)
            if user_info == None:
                return(
                    f"People (find all)\n"
                    "----------------------------\n"
                    f"{people}\n\n"
                    f"{self.get_people_message()}"
                    )
            else:
                return(
                    f"People (find all)\n"
                    "----------------------------\n"
                    f"{people}\n\n"
                    f"{self.get_people_message_with_session_token(user_info)}"
                    )
        if request[len('find')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        request = request[len('find '):]
        field, value, people = self.database.find_by_pattern(request)
        if user_info == None:
            return(
                f"People (find {value}{field})\n"
                "----------------------------\n"
                f"{people}\n\n"
                f"{self.get_people_message()}"
                )
        else:
            return(
                f"People (find {value}{field})\n"
                "----------------------------\n"
                f"{people}\n\n"
                f"{self.get_people_message_with_session_token(user_info)}"
                )

    def sort(self, request):
        if len(request) > len('sort') and request[len('sort')] != ' ':
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        attribute = 'updated' # default update value
        order = 'desc' # default criteria
        criteria = 'newest'
        request = request.split()
        if len(request) > 1:
            attribute = request[1]
            if attribute != 'updated':
                order = 'asc'
            if len(request) > 2:
                order = request[2]
        if order == 'asc':
            criteria = 'a-z'
            if attribute == 'updated':
                criteria = 'oldest'
        if order == 'desc':
            criteria = 'z-a'
            if attribute == 'updated':
                criteria = 'newest'

        allowed_attributes = ['username', 'name', 'status', 'updated']
        allowed_order = ['asc', 'desc']
        if attribute not in allowed_attributes or order not in allowed_order:
            return(
                "not found\n\n"
                "home: ./app\n"
                )
        person_list = self.database.get_all_people()
        person_list = self.sort_helper(person_list, attribute, order)
        people = self.database.show_people(person_list)
        return(
            f"People (sorted by {attribute}, {criteria})\n"
            "----------------------------\n"
            f"{people}\n\n"
            f"{self.get_people_message()}"
        )

    def sort_helper(self, person_list, attribute, order):
        reverse = False
        if order == 'desc':
            reverse = True
        def sort_key(person):
            if attribute == 'username':
                return person.username
            elif attribute == 'name':
                return person.name
            elif attribute == 'status':
                return person.status
            else:
                return person.updated
        key = sort_key
        person_list = sorted(person_list, key = key, reverse = reverse)
        return person_list
