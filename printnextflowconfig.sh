#!/bin/bash
#usage: 
#printnextflowconfig BATCHAWSCONFIGFILE
#https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash

if [ $# -eq 1 ]; then
STACKNAME=$1
BATCHAWSCONFIGFILE=~/.batchawsdeploy/stack_${STACKNAME}.sh
source $BATCHAWSCONFIGFILE

echo ""
echo "
executor {
    name = 'awsbatch'
    //awscli = '/home/ec2-user/miniconda/bin/aws'
}
process {"
images=$(grep "image_" $BATCHAWSCONFIGFILE)
	echo "    queue = '$QUEUENAME'"
while read -r line; do
	IFS='=' read -d '' -ra array < <(printf '%s\0' "$line")
	echo "    withLabel: ${array[0]} {"
	echo "        container = '${array[1]}'"
	echo "    }"
done <<< "$images"

echo "}
aws {
    region = '$REGION'
}
"
echo ""

else
    echo "error, usage: printnextflowconfig STACKNAME"
fi

