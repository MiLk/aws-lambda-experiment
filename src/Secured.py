from __future__ import print_function

import json

def lambda_handler(event, context):
    print('event:' + json.dumps(event))
    return {
        'message': 'Hello world!'
    }
