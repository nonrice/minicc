def greet(name, excited=False):
    msg = f"Hello, {name}!"
    return msg.upper() if excited else msg

def farewell(name):
    return f"Goodbye, {name}!"

def shout(name):
    return greet(name, excited=True)

if __name__ == "__main__":
    print(greet("world"))
    print(shout("world"))
    print(farewell("world"))
