keys = []

def keyPressed():
    if key not in keys:
        keys.append(key)

def keyReleased():
    if type(key) == unicode:
        if key.upper() in keys:
            keys.remove(key.upper())
        if key.lower() in keys:
            keys.remove(key.lower())
    else:
        if key in keys:
            keys.remove(key)

def getKey(check_key):
    if type(check_key) == unicode:
        return check_key.lower() in keys or check_key.upper() in keys
    else:
        return check_key in keys
