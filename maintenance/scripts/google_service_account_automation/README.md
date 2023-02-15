# Google Account Client
This tool is designed to assist with controlling a Google service account in Google Drive.

## Setup
1) Ensure you have a recent version of Python 3 installed as well as the Pip package manager
2) Create a venv or similar as needed e.g. with `python3 -m venv venv`
3) Activate the environment e.g. with `source venv/bin/activate` (Linux/Mac) or `\env\Scripts\activate.bat` (Windows)
4) Run `pip install -r requirements.txt` to install dependencies within the venv
5) Go to e.g. Parameter Store to get the Service Account credentials, and save them in a file named `credentials.json` (gitignored) in the project root directory
6) Copy `config_sample.py` and rename to `config.py`
7) Modify the dictionaries in `config.py` (gitignored) to have the file IDs of any files or folders you want to work with

## Use
1) Open `main.py`
2) Use the `service_account` instance's methods inside the `if __name__ == "__main__":` clause

## Note
See `data_samples` for relevant data schemas.

## Examples
Get CSV files in a folder in the config named "Project Files" which aren't in the trash and have a name containing "2022", then write these to a json file
```python
if __name__ == "__main__": 
    folder_id = FOLDERS["Project Files"]
    query_lines = [
        f"'{folder_id}' in parents",
        "trashed=false",
        "mimeType = 'text/csv'",
        f"name contains '2022'",
    ]

    files = service_account.query_files(query_lines)
    service_account.write_data_to_json(files)
```

___

Uploads a CSV file in the current directory named "test.csv" to the same parent folder of a file defined in `config.py` `FILES`

You could also specify the path to the file under the `filename` like `./files_to_upload/test.csv`
```python
if __name__ == "__main__":
    parent_directory = service_account.get_file_parent_folder(FILES["My Test File"])
    service_account.upload(filename="test.csv", mimetype="text/csv", folder_id=parent_directory)
```

___

Deletes all files in a folder stored in Config FOLDERS under key "Folder To Clean" which match the regex (Start with BadFile, have csv in name) and which are greater than 1000000 bytes (1GB) in size

This will ask for user confirmation
```python
if __name__ == "__main__":
    delete_matching_files_in_folder(FOLDERS["Folder To Clean"], file_regex="^BadFile.*csv", file_size_minimum=1000000)
```