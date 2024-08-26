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
        if request == '' or request == 'home':
            return self.get_home_page_message()
        elif request.startswith("create "):
            return self.create_user(request)
        elif request.startswith("login "):
            return self.login(request)
        elif request.startswith("session "):
            return self.process_session_request(request)
        else:
            return 'Weird request!'

    def get_home_page_message(self):
        return (
            "Welcome to the App!\n\n"
            "Available commands:\n"
            "login: ./app 'login <username> <password>'\n"
            "join: ./app 'join'\n"
            "create: ./app 'create username=\"<value>\" password=\"<value>\" name=\"<value>\" status=\"<value>\"'\n"
            "show people: ./app 'people'\n"
            )

    def create_user(self, request):
        request = request[len('create '):]
        required_keys = ['username', 'password', 'name', 'status']

        pattern = r'(\w+)\s*=\s*"([^"]*)"'
        matches = re.findall(pattern, request)        
        user_dict = {key: value for key, value in matches}

        for key in required_keys:
            if key not in user_dict:
                return f"Missing required argument: {key} not present in prompt, try again with correct input!"

        person = Person(username = user_dict['username'], password = user_dict['password'], 
            name = user_dict['name'], status = user_dict['status'], 
            session_token = uuid.uuid4().hex, updated = datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

        if self.database.add_person(person):
            return (
                "[account created]\n\n"
                "Person\n"
                "--------\n"
                f"name: {person.name}\n"
                f"username: {person.username}\n"
                f"status: {person.status}\n"
                f"updated: {person.updated}\n\n"
                )

        return 'User not added, try again!'

    def login(self, request):
        request = request.split()
        if len(request) < 3:
            return "Username or password not provided, please try again!\n"
        username = request[1]
        password = ' '.join(request[2: ])

        login_status, person = self.database.authenticate_user(username, password)
        if person:
            return (
                f"{login_status}"
                f"{person.status}\n\n"
                )
        return "Invalid username or password. Try again!\n"

    def process_session_request(self, request):
        request = request.split()
        if len(request) == 1:
            return "Session token not provided, please try again!\n"
        session_token = request[1]
        user_info = self.database.validate_session_token(session_token)
        if user_info == None:
            return "Invalid session token, please try again!\n"
        if len(request) == 2:
            return "wip"
        if len(request) == 3:
            if request[2] == "logout":
                self.logout(user_info.get('username'))
                return(
                    "[you are now logged out]\n"
                    f"{self.get_home_page_message()}"
                    )


    def logout(self, username):
        self.database.logout_user(username)