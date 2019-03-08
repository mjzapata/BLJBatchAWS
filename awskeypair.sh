#!/bin/bash

#Purpose:  The purpose of this script is to create a keypair and also remove it after the creation of an AMI
print_error() {
	echo "Usage: 
	awskeypair create MyKeyName
	awskeypair delete MyKeyName
	awskeypair list MyKeyName
	awskeypair list"
}

ARGUMENT=$1

if [ $# -eq 2 ]; then
	KEYNAME=$2
	KEYPATH=~/.batchawsdeploy/key_${KEYNAME}.pem
	
	if [ "$ARGUMENT" == "create" ] && [ ! -f $KEYPATH ]; then
	#if [ "$ARGUMENT" == "create" ]; then
		#TODO: what if the output file is empty
		# if a key by that name does not exist in the described key-pairs, create it.  Otherwise, do nothing
		keydescription=$(aws ec2 describe-key-pairs)
		keystatus=$(echo "$keydescription" | grep -c "$KEYNAME")
		if [ $keystatus -eq 0 ]; then
			aws ec2 create-key-pair --key-name $KEYNAME --query 'KeyMaterial' --output text > $KEYPATH
			#this is a security requirement for keypairs to be used
			chmod 400 $KEYPATH
		else
			echo "key with name: $KEYNAME  already exists!"
		fi

	elif [ "$ARGUMENT" == "list" ]; then
		aws ec2 describe-key-pairs --key-name $KEYNAME

	elif [ "$ARGUMENT" == "delete" ]; then
		chmod 777 $KEYPATH
		echo "deleting Key File: $KEYPATH"
		rm $KEYPATH
		echo "deleting KeyPair: $KEYNAME"
		aws ec2 delete-key-pair --key-name $KEYNAME

	else
		print_error
	fi


elif [ $# -eq 1 ]; then
	if [ "$ARGUMENT" == "list" ]; then
		echo "list"
		aws ec2 describe-key-pairs
	else
		print_error
	fi
else

	print_error
fi

