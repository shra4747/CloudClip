import sys

def logOutGoogleAccount():
    import os
    homeDirectory = str(os.path.expanduser("~"))
    try:
        with open(f'/Library/Application Support/CloudClipPython/credentials.json', 'w') as credentials:
            credentials.write("")
            credentials.close()
            print(False)
    except:
        print(True)

def checkLoggedStatus():
    import os
    homeDirectory = str(os.path.expanduser("~"))
    with open(f'/Library/Application Support/CloudClipPython/credentials.json', 'r') as credentials:
        r = credentials.read()
        if r == '':
            print(False)
        else:
            print(True)


if __name__ == '__main__':
    globals()[sys.argv[1]]()