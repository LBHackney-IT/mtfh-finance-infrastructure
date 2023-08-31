This is an instance module which references the module: [AWS ECS Fargate Task module](https://github.com/LBHackney-IT/mtfh-finance-infrastructure/tree/main/aws_ecs_fargate_task_module).
This will create the 12 resources that are necessary for running ECS-managed Containers using the Fargate launch method.

In addition to the above, the following resources are also created by this module:
 1. SNS Topic - (email subscriptions will need to be added manually)
 2. A custom Security Group for the ECS container
 3. Security Group Rule (MSSQL Inbound traffic)

Please note: For any further Nightly Processes created in the future, should reuse the SNS Topic created above for sending email notifications.
