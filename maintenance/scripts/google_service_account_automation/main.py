from DriveServiceAccountClient import DriveServiceAccountClient
from config import FOLDERS, FILES

service_account = DriveServiceAccountClient()

if __name__ == '__main__':
    
    # Replace this and write your code below
    # Example: Gets a file by its ID defined in the config file
    file_id = FILES["My Cool File"]
    file = service_account.get_file_or_folder(file_id)
