#!/bin/bash

# Define bucket names
SOURCE_BUCKET="data-engineer-takehome-source-bucket"
DESTINATION_BUCKET="data-engineer-takehome-destination-bucket"

# Function to check permissions on a bucket
check_bucket_permissions() {
    BUCKET_NAME=$1

    echo "Testing permissions for bucket: $BUCKET_NAME"

    # Try listing the bucket
    echo "Listing contents of $BUCKET_NAME:"
    aws s3 ls s3://$BUCKET_NAME/
    if [ $? -ne 0 ]; then
        echo "Failed to list bucket $BUCKET_NAME"
    else
        echo "Successfully listed bucket $BUCKET_NAME"
    fi

    # Try to upload a file
    echo "Uploading to $BUCKET_NAME:"
    echo "Test file content" > testfile.txt
    aws s3 cp testfile.txt s3://$BUCKET_NAME/testfile.txt
    if [ $? -ne 0 ]; then
        echo "Failed to upload to bucket $BUCKET_NAME"
    else
        echo "Successfully uploaded to bucket $BUCKET_NAME"
    fi

    # Try to download the file back
    echo "Downloading from $BUCKET_NAME:"
    aws s3 cp s3://$BUCKET_NAME/testfile.txt downloaded_testfile.txt
    if [ $? -ne 0 ]; then
        echo "Failed to download from bucket $BUCKET_NAME"
    else
        echo "Successfully downloaded from bucket $BUCKET_NAME"
    fi

    # Clean up local test files
    rm -f testfile.txt downloaded_testfile.txt

    # Clean up the uploaded test file
    aws s3 rm s3://$BUCKET_NAME/testfile.txt
    echo "Cleaned up testfile.txt from $BUCKET_NAME"
}

# Check permissions for both buckets
check_bucket_permissions $SOURCE_BUCKET
check_bucket_permissions $DESTINATION_BUCKET

