import sys

def uploadToSession(sessionID, fileLocation, fileName):
    from pydrive.auth import GoogleAuth
    from pydrive.drive import GoogleDrive
    
    import os
    homeDirectory = str(os.path.expanduser("~"))

    try:
        gauth = GoogleAuth()
        gauth.LoadClientConfigFile(
            client_config_file=f"/Library/Application Support/CloudClipPython/client_secrets.json")
        gauth.LoadCredentialsFile(
            f"/Library/Application Support/CloudClipPython/credentials.json")
        gauth.Authorize()
    except:
        print("1")

    drive = GoogleDrive(gauth)

    file = drive.CreateFile(
        {'title': fileName, 'parents': [{'id': sessionID}]})

    file.SetContentFile(fileLocation)
    file.Upload()  # Upload the file.
    print("0")


if __name__ == '__main__':
    globals()[sys.argv[1]](sys.argv[2], sys.argv[3], sys.argv[4])