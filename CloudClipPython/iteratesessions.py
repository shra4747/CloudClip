import sys

def iterateSessions():
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
        print([])
    drive = GoogleDrive(gauth)

    root_folders = drive.ListFile(
        {'q': "'root' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false"}).GetList()

    for folder in root_folders:
        if folder['title'] == "CloudClipFiles" and folder['mimeType'] == 'application/vnd.google-apps.folder':
            fid = folder['id']
            ccf = drive.ListFile(
                {'q': f"'{fid}' in parents and trashed=false"}).GetList()
            # Folder Exists

            sessionFolderIDS = ""
            for item in ccf:
                if 'folder' in str(item['mimeType']):
                    
                    title = item["title"]
                    id = item["id"]
                    sessionFolderIDS += f"{title} | {id} -+-+-+ " 

            print(sessionFolderIDS)
        else:
            pass


if __name__ == '__main__':
    globals()[sys.argv[1]]()