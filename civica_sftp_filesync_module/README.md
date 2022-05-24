# CivicaPay SFTP File Sync Module
This module creates the following infrastructural resources:

 - S3 Bucket
	 - contains a folder named cashfiles/
	 - Lifecycle policy to expire objects older than 30 days
 - SFTP server endpoint for the S3 
	 - User with SSH access (note that the username and public key are stored in Parameter store)
 - IAM Role and attached Permission Policy
	 - Write to the S3 bucket - for the SFTP client
	 - Read (GetObject) - for the Cashfile Lambda function
 - Lambda Trigger event to respond to PUT events on the S3 bucket

## Apply the module
Use the following module block to use the module:

    module "civica_sftp_filesync" {
	    source = "./civica_sftp_filesync_module"
	    environment = var.environment_name
	    statemachine_lambda_name = var.statemachine_lambda_name
	    statemachine_lambda_role = var.statemachine_lambda_role
	    sftp_user_name = module.civica_sftp_filesync.civica_sftp_username
	    sftp_ssh_public_key = module.civica_sftp_filesync.civica_sftp_public_key
    }

**source** = relative path to the module

**environment** = development/staging/production

**statemachine_lambda_name** = the name of the HFCashFileStateMachine lambda

> dev = "housing-finance-interim-api-development-check-cash-files"
> 
> staging = "housing-finance-interim-api-staging-cash-file-trans"
> 
> prod = "housing-finance-interim-api-production-cash-file"

**statemachine_lambda_role** = the name of the IAM role of the above lambda function

> dev = "housing-finance-interim-api-development-eu-west-2-lambdaRole"
> 
> staging = "housing-finance-interim-api-lambdaExecutionRole"
> 
> prod = "housing-finance-interim-api-lambdaExecutionRole"

**sftp_user_name** = the username is stored in Parameter Store under the key: 

    /housing-finance/development/civica-sftp-username

**sftp_ssh_public_key** = the public key string is stored in Parameter Store under the key:

    /housing-finance/development/civica-sftp-ssh-public-key

