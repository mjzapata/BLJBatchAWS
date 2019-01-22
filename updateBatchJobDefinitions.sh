#!/bin/bash

# This script searches the biolockj docker repository for all available images 
# and creates a PRIVELEDGED job definition for each one.  The priveledged flag
# is not setable by nextflow, so it needs a seperate job definition for each
# docker image.
# In the main nextflow pipeline file, the job definition should be specified 
# for each container as:
# container container 'job-definition://${JOBDEFPREFIX}${STACKNAME}_${JOBIMAGENOSPECIAL}

# NOTE: each job definition can be used more than once, but I THINK each nextflow
# process name must be unique.

# OUTPUT: echo the image name and the 
#TODO: test on single docker image

if [[ $# -gt 5 ]]; then
	DOCKERREPOSEARCHSTRING=$1
	DOCKERRREPOVERSION=$2
	JOBROLEARN=$3
	JOBVCPUS=$4
	JOBMEMORY=$5
	STACKNAME=$6
	#JOBDEFPREFIX=$6

	dockersearchoutput=$(docker search $DOCKERREPOSEARCHSTRING | grep $DOCKERREPOSEARCHSTRING) #| grep $DOCKERREPOSEARCHSTRING)
	IFS=$'\t' #necessary to get tabs to parse correctly
	repoimagelist=$(echo $dockersearchoutput | awk '//{print $1}')
	#DEPLOYJOBDEFINITIONSOUTPUT='STACKNAME=$STACKNAME'
	#DEPLOYJOBDEFINITIONSOUTPUT=""
	while read -r line; do
	    #echo "Image: $JOBIMAGE"
	    # a lot of bash trickery to get the job output format to work with Nextflow.
		# IFS=$'\t' #necessary to get tabs to parse correctly
	    JOBIMAGE=${line}:${DOCKERRREPOVERSION}
	    JOBIMAGENOSPECIAL=$(tr -s /: _ <<< "$JOBIMAGE")
	    #JOBDEFINITIONNAME=${JOBDEFPREFIX}${STACKNAME}_${JOBIMAGENOSPECIAL}
	   	JOBDEFINITIONNAME=${STACKNAME}_${JOBIMAGENOSPECIAL}


	    JOBROLEARN=$JOBROLEARN
	    JobDefoutput=$(./createBatchJobDefinition.sh $JOBDEFINITIONNAME $JOBIMAGE $JOBROLEARN $JOBVCPUS $JOBMEMORY)

		IFS=$'\t'
		OFS=$'\t'
		JobLine=$(echo $JobDefoutput | grep job-definition)
		JobLineTrimmed=$(echo $JobLine | sed 's/^.*job-definition/job-definition:\//')
		JOBDEFINITIONNAMEFULL=$(echo $JobLineTrimmed | awk '//{print $1}')

		DEPLOYJOBDEFINITIONSOUTPUT=$(echo -e $DEPLOYJOBDEFINITIONSOUTPUT)'\n'$(echo -e ${JOBIMAGE}$'	'${JOBDEFINITIONNAMEFULL})

	done <<< "$repoimagelist"
	echo -e "$DEPLOYJOBDEFINITIONSOUTPUT"

fi

