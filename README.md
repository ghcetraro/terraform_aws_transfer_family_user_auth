# README

This repository is used to install AWS SFTP (Transfer Family) in aws with user and password login, with terraform

## Type of authentication 

	- User and password saver in Aws Secret Manager

## Components

	AWS Transfer Family
	AWS Api Gateway
	AWS Lambda ( code in python )
	AWS Secret Manager
	AWS Policies and Roles

## Secret Format

-- secret name

	aws/transfer/<server id/<user name>

-- example

	aws/transfer/s-b6e291cee92741e19/netadmin

-- secret content to use Standard directories

	Password              sftp1234
	Role                  arn:aws:iam::<account>:role/sftp_ro-sandbox
	HomeDirectory         /sftp-apigateway-lambda-test/netadmin

-- secret content to use  Logical directories

	Password              sftp1234
	Role                  arn:aws:iam::<account>:role/sftp_ro-sandbox
	HomeDirectory         /sftp-apigateway-lambda-test/netadmin
	HomeDirectoryDetails  [{"Entry": "/", "Target": "/sftp-apigateway-lambda-test/netadmin"}]

## Policies

-- Read Only

	arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

-- Read and Write

	arn:aws:iam::aws:policy/AmazonS3FullAccess

## Roles

-- Read Only

	arn:aws:iam::<account>:role/sftp_ro-sandbox

-- Read and Write

	arn:aws:iam::<account>:role/sftp_rw-sandbox

## Resources

Resources that are going to be deployed  
```
	AWS  
		aws transfer family  
		roles  
		polices  
		secret manager  
		route53 records  
		api gateway  
		lambda  
		elastic ip  
		cloudwatch  
		secutiry groups

	External Local Resources

		acm
		route53 domain
		vpc
```