#!/bin/bash -xe
#
# Script to delete AWS IAM roles for use with OpenShift for AWS Snowball Edge

ROLE_NAME="lambda-sbe-role"
PROFILE_NAME="${ROLE_NAME}"
TRUST_POLICY="trust.json"
PERMISSIONS="permissions.json"

#aws iam delete-instance-profile --instance-profile-name "${PROFILE_NAME}"

#sleep 2

aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "${ROLE_NAME}"

sleep 2

aws iam delete-role --role-name "${ROLE_NAME}"

sleep 2

exit 0
