class Person:
    def __init__(self, username, password, name, status, session_token = None, updated = None):
        self.username = username
        self.password = password
        self.name = name
        self.status = status
        self.session_token = session_token
        self.updated = updated


    def to_dict(self):
        return {
            'username': self.username,
            'password': self.password,
            'name': self.name,
            'status': self.status,
            'session_token': self.session_token,
            'updated': self.updated
        }