#!/bin/bash

BUCKETNAME="bucket-for-arhived-lambdas-12-12-23"

echo "Deleting S3 Bucket..."

sleep 2

aws s3 rb s3://$BUCKETNAME --force

echo "Deleting Infrastructure..."

sleep 2

terraform destroy -auto-approve