import boto3
import json
import sys

for line in sys.stdin:
    obj = json.loads(line)

    s3 = boto3.resource(
        's3',
        aws_access_key_id=obj['AccessKeyId'],
        aws_secret_access_key=obj['SecretAccessKey'],
        aws_session_token=obj['SessionToken']
    )

    object = s3.Object('milk-lambda-experiment', 'README.md')
    res = object.upload_file('README.md')
    print(res)
