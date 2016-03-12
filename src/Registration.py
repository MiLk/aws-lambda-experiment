from __future__ import print_function

import boto3
import json
from boto3.dynamodb.conditions import Attr
from botocore.exceptions import ClientError
from passlib.hash import pbkdf2_sha256

print('Loading function')

DYNAMO_TABLE_NAME = 'lambda_accounts'

def lambda_handler(event, context):
    '''Provide an event that contains the following keys:

      - email
      - name
      - password
    '''
    print("Received event: " + json.dumps(event, indent=2))

    if (len(set(['email', 'name', 'password']) & set(event.keys())) != 3):
      raise ValueError('Invalid data')

    table = boto3.resource('dynamodb').Table(DYNAMO_TABLE_NAME)

    hash = pbkdf2_sha256.encrypt(event.get('password'), salt_size=16, rounds=4000)

    try:
      table.put_item(
        Item={
          'email': event.get('email'),
          'name': event.get('name'),
          'hashed_password': hash
        },
        ConditionExpression=Attr('email').ne(event.get('email'))
      )
    except ClientError as e:
      if e.response['Error']['Code'] == "ConditionalCheckFailedException":
          print(e.response['Error']['Message'])
      else:
          raise
    else:
        print("Registration successful")
    
