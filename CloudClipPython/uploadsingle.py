import sys

def upload(fileLocation, fileName):
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
            file1 = drive.CreateFile({'title': fileName, 'parents': [{'id': folder['id']}]})
            
            file1.SetContentFile(fileLocation)
            file1.Upload()  # Upload the file.

    print("0")


if __name__ == '__main__':
    globals()[sys.argv[1]](sys.argv[2], sys.argv[3])