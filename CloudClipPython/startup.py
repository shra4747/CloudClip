import sys


def initializeRootClipDirectory():
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

    root_folders = drive.ListFile(
        {'q': "'root' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false"}).GetList()

    folderInitialized = False
    for folder in root_folders:
        if folder['title'] == "CloudClipFiles" and folder['mimeType'] == 'application/vnd.google-apps.folder':
            folderInitialized = True
            # Folder Exists
        else:
            pass
            # This is not the folder

    # Folder Doesnt exist
    if (folderInitialized) == False:
        rootClipFolder = drive.CreateFile(
            {'title': "CloudClipFiles", "mimeType": "application/vnd.google-apps.folder"})
        rootClipFolder.Upload()
    print("0")


def authenticate():
    from pydrive.auth import GoogleAuth
    from pydrive.drive import GoogleDrive

    import os
    homeDirectory = str(os.path.expanduser("~"))

    gauth = GoogleAuth()
    gauth.LoadClientConfigFile(
        client_config_file=f"/Library/Application Support/CloudClipPython/client_secrets.json")

    gauth.LoadCredentialsFile(
        f"/Library/Application Support/CloudClipPython/credentials.json")

    if gauth.credentials is None:
        # Authenticate if they're not there
        gauth.LocalWebserverAuth()
    elif gauth.access_token_expired:
        # Refresh them if expired
        gauth.LocalWebserverAuth()
    else:
        # Initialize the saved creds
        gauth.Authorize()
    # Save the current credentials to a file
    gauth.SaveCredentialsFile(
        f"/Library/Application Support/CloudClipPython/credentials.json")
    print("0")


if __name__ == '__main__':
    globals()[sys.argv[1]]()
