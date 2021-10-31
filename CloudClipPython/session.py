import sys

def startSession(sessionName):
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

    folderName = "CloudClipFiles"  # Please set the folder name.

    folders = drive.ListFile(
        {'q': "title='" + folderName + "' and mimeType='application/vnd.google-apps.folder' and trashed=false"}).GetList()
    for folder in folders:
        if folder['title'] == folderName:
            sessionFolder = drive.CreateFile(
                {'title': sessionName, "mimeType": "application/vnd.google-apps.folder", 'parents': [{'id': folder['id']}]})
            sessionFolder.Upload()
    print("0")


def getSessionId(sessionName):
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

    folderName = "CloudClipFiles"  # Please set the folder name.

    folders = drive.ListFile(
        {'q': "title='" + folderName + "' and mimeType='application/vnd.google-apps.folder' and trashed=false"}).GetList()
    for folder in folders:
        if folder['title'] == folderName:
            # In Cloud Clip Folder

            sessionFolders = drive.ListFile(
                {'q': f"'{folder['id']}' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false"}).GetList()
            for session in sessionFolders:
                if session['title'] == sessionName:
                    print(str(session['id']))

if __name__ == '__main__':
    globals()[sys.argv[1]](sys.argv[2])