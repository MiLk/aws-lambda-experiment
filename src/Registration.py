import boto3
from boto3.dynamodb.conditions import Attr
from botocore.exceptions import ClientError
from passlib.hash import pbkdf2_sha256

DYNAMO_TABLE_NAME = 'lambda_accounts'


def lambda_handler(event, context):
    """
    Provide an event that contains the following keys:
      - email
      - name
      - password
    """

    if len({'email', 'name', 'password'} & set(event.keys())) != 3:
        return {
            'errorMessage': 'Error: Missing required data.'
        }

    table = boto3.resource('dynamodb').Table(DYNAMO_TABLE_NAME)

    hashed_password = pbkdf2_sha256.encrypt(
        event.get('password'), salt_size=16, rounds=4000)

    try:
        table.put_item(
            Item={
                'email': event.get('email'),
                'name': event.get('name'),
                'hashed_password': hashed_password
            },
            ConditionExpression=Attr('email').ne(event.get('email'))
        )
    except ClientError as e:
        if e.response['Error']['Code'] == "ConditionalCheckFailedException":
            return {
                'errorMessage': 'Error: This email address is already used.'
            }
        else:
            raise
    else:
        return {}
