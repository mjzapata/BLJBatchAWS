#!/bin/bash

print_help() {
	echo "this script installs AWS Batch Deployer to your computer."
	echo "it creates a required file ~/.batchawsdeploy/config"
	echo "Usage: ./installBatchDeployer pwd    (installs using to current directory)"
}

if [ $# -eq 1 ]; then
	ARGUMENT=$1
	
	if [ $ARGUMENT == "pwd" ]; then
		mkdir -p ~/.batchawsdeploy/
		#rm ~/.batchawsdeploy/config
		touch ~/.batchawsdeploy/config
		chmod a+x ~/.batchawsdeploy/config
		
		BATCHAWSDEPLOY_HOME=$(pwd)
		#add trailing / if missing
		[[ "${BATCHAWSDEPLOY_HOME}" != */ ]] && BATCHAWSDEPLOY_HOME="${BATCHAWSDEPLOY_HOME}/"

		echo "#!/bin/sh" > ~/.batchawsdeploy/config
		echo "export BATCHAWSDEPLOY_HOME=$BATCHAWSDEPLOY_HOME" >> ~/.batchawsdeploy/config
		echo 'export PATH=$PATH'":${BATCHAWSDEPLOY_HOME}:${BATCHAWSDEPLOY_HOME}support" >> ~/.batchawsdeploy/config
		
	else
		print_help
	fi

else
	print_help

fi

