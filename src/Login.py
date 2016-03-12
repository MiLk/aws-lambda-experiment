import boto3
from passlib.hash import pbkdf2_sha256
import jwt
from datetime import datetime, timedelta

DYNAMO_TABLE_NAME = 'lambda_accounts'
JWT_SECRET = 'myjwtsecret'


def lambda_handler(event, context):
    """
    Provide an event that contains the following keys:
      - email
      - password
    """

    if len({'email', 'password'} & set(event.keys())) != 2:
        return {
            'errorMessage': 'Error: Missing required data.'
        }

    table = boto3.resource('dynamodb').Table(DYNAMO_TABLE_NAME)
    response = table.get_item(
        Key={
            'email': event.get('email')
        }
    )
    item = response['Item']
    if not item:
        return {
            'errorMessage': 'Error: Invalid email or password.'
        }

    verify = pbkdf2_sha256.verify(event.get('password'), item['hashed_password'])
    if not verify:
        return {
            'errorMessage': 'Error: Invalid email or password.'
        }

    return {
        'token': jwt.encode({
            'email': item['email'],
            'name': item['name'],
            'exp': datetime.utcnow() + timedelta(days=1)
        }, JWT_SECRET)
    }
