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
Use the following block to invoke the module (in main.tf):

    module "civica_sftp_filesync" {
	    source = "./civica_sftp_filesync_module"
	    environment = var.environment_name
	    statemachine_lambda_name = var.statemachine_lambda_name
	    statemachine_lambda_role = var.statemachine_lambda_role
    }

**source** = relative path to the module

**environment** = development/staging/production

**statemachine_lambda_name** = the name of the HFCashFileStateMachine lambda

|Environment|statemachine_lambda_name value  |
|--|--|
|  develop| housing-finance-interim-api-development-check-cash-files|
|  staging| housing-finance-interim-api-staging-cash-file-trans|
|  production| housing-finance-interim-api-production-cash-file|


**statemachine_lambda_role** = the name of the IAM role of the above lambda function

| Environment | statemachine_lambda_role IAM Role |
|--|--|
| develop | housing-finance-interim-api-development-eu-west-2-lambdaRole |
| staging | housing-finance-interim-api-lambdaExecutionRole |
| production | housing-finance-interim-api-lambdaExecutionRole |

## Notes

**SFTP username**
the username is stored in Parameter Store under the key: 

    /housing-finance/development/civica-sftp-username

**SFTP public key**
the public key string is stored in Parameter Store under the key:

    /housing-finance/development/civica-sftp-ssh-public-key

