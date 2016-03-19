import boto3
import json
import jwt

DYNAMO_TABLE_NAME = 'lambda_accounts'
JWT_SECRET = 'myjwtsecret'

def lambda_handler(event, context):
    print(json.dumps(event))
    token = jwt.decode(event['authorizationToken'], JWT_SECRET)
    filepath = event['path']

    policy_to_grant = {'Statement': [{'Action': ['s3:GetObject', 's3:PutObject'],
                                      'Effect': 'Allow',
                                      'Resource': ['arn:aws:s3:::milk-lambda-experiment/' + filepath]}]}
    client = boto3.client('sts')
    assume = client.assume_role(
        RoleSessionName=token['email'],
        RoleArn='arn:aws:iam::990529572879:role/execution-role',
        ExternalId=token['email'],
        Policy=json.dumps(policy_to_grant),
        DurationSeconds=900
    )

    return {
        'AccessKeyId': assume['Credentials']['AccessKeyId'],
        'SecretAccessKey': assume['Credentials']['SecretAccessKey'],
        'SessionToken': assume['Credentials']['SessionToken']
    }
