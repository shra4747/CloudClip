import sys


def fileInDirectory(folderID):
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
        print("")
    drive = GoogleDrive(gauth)

    file_list = drive.ListFile(
        {'q': f"'{folderID}' in parents and trashed=false"}).GetList()

    sessionFolderIDS = ""
    for item in file_list:
        try:
            title = item["title"]
            id = item["id"]
            thumbnailLink = item["thumbnailLink"]
            sessionFolderIDS += f"{title} | {id} ! {thumbnailLink} -+-+-+ "
        except:
            continue
    print(sessionFolderIDS)


if __name__ == '__main__':
    globals()[sys.argv[1]](sys.argv[2])
