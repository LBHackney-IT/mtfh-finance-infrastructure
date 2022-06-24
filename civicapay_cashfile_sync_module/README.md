# CivicaPay SFTP File Sync Module
This module creates the following infrastructural resources:

 - S3 Bucket
	 - contains a folder named cashfiles/
	 - Lifecycle policy to expire objects older than 30 days
 - Local lambda function - reads and processes the cashfile when file is created in the *cashfiles* folder of the S3 bucket
	 - housing-finance-interim-api-[environment]-check-cash-files
 - Remote lambda function - writes the cashfile to the S3 bucket
	 - civica-prod-file-sync-source-lambda
 - IAM Role and attached Permission Policy - S3 Bucket
	 - Write to the S3 bucket - remote Lambda
	 - Read (GetObject) - for the local lambda function
 - Lambda Trigger event to respond to the `CreateObject` event on the S3 bucket

## Apply the module
Use the following block to invoke the module (in main.tf):

    module "civicapay_cashfile_sync" {
	    source 						= "./civica_sftp_filesync_module"
	    environment 				= var.environment_name
		remote_lambda_role_arn    	= var.remote_lambda_role_arn
	    statemachine_lambda_name 	= var.statemachine_lambda_name
	    statemachine_lambda_role 	= var.statemachine_lambda_role
    }

**source** = relative path to the module

**environment** = development | staging | production

**remote_lambda_role_arn** = This is the ARN of the role of the CivicaPay Lambda function which will access the S3

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
