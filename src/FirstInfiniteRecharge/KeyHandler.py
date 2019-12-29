keys = []

# store the currently pressed keys in the keys list
def keyPressed():
    if key not in keys:
        keys.append(key)

# remove the released key in the keys list
def keyReleased():
    if type(key) == unicode:
        if key.upper() in keys:
            keys.remove(key.upper())
        if key.lower() in keys:
            keys.remove(key.lower())
    else:
        if key in keys:
            keys.remove(key)

# check if the given key is pressed or not
# if capitalization is set to True, then capitalization will be checked
def getKey(check_key, capitalization = False):
    if type(check_key) == unicode and not capitalization:
        return check_key.lower() in keys or check_key.upper() in keys
    else:
        return check_key in keys
