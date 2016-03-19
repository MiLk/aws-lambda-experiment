# AWS API Gateway configuration

## Custom Authorizer

```json
{
    "items": [
        {
            "name": "Authorizer",
            "authorizerUri": "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:990529572879:function:Authorizer/invocations",
            "identityValidationExpression": ".*\\..*\\..*",
            "authorizerResultTtlInSeconds": 300,
            "identitySource": "method.request.header.X-Access-Token",
            "type": "TOKEN",
            "id": "5pyati"
        }
    ]
}
```

## Resources

```json
{
    "items": [
        {
            "path": "/register",
            "resourceMethods": {
                "POST": {}
            },
            "id": "3fyl4f",
            "pathPart": "register",
            "parentId": "uy9v379tvg"
        },
        {
            "path": "/upload",
            "id": "adjx35",
            "pathPart": "upload",
            "parentId": "uy9v379tvg"
        },
        {
            "path": "/upload/request",
            "resourceMethods": {
                "POST": {}
            },
            "id": "exoxzl",
            "pathPart": "request",
            "parentId": "adjx35"
        },
        {
            "path": "/login",
            "resourceMethods": {
                "POST": {}
            },
            "id": "npc8s2",
            "pathPart": "login",
            "parentId": "uy9v379tvg"
        },
        {
            "path": "/secured",
            "resourceMethods": {
                "GET": {}
            },
            "id": "otgbp5",
            "pathPart": "secured",
            "parentId": "uy9v379tvg"
        },
        {
            "path": "/", 
            "id": "uy9v379tvg"
        }
    ]
}
```

## Methods

### POST `/register`

```json
{
    "apiKeyRequired": false, 
    "httpMethod": "POST", 
    "methodIntegration": {
        "integrationResponses": {
            "200": {
                "responseTemplates": {
                    "application/json": null
                }, 
                "statusCode": "200"
            }
        }, 
        "cacheKeyParameters": [], 
        "uri": "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:990529572879:function:Registration/invocations", 
        "httpMethod": "POST", 
        "cacheNamespace": "3fyl4f", 
        "type": "AWS"
    }, 
    "requestParameters": {}, 
    "methodResponses": {
        "200": {
            "responseModels": {
                "application/json": "Empty"
            }, 
            "statusCode": "200"
        }
    }, 
    "authorizationType": "NONE"
}
```

### POST `/login`

```json
{
    "apiKeyRequired": false,
    "httpMethod": "POST",
    "methodIntegration": {
        "integrationResponses": {
            "200": {
                "responseTemplates": {
                    "application/json": null
                },
                "statusCode": "200"
            }
        },
        "cacheKeyParameters": [],
        "uri": "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:990529572879:function:Login/invocations",
        "httpMethod": "POST",
        "cacheNamespace": "npc8s2",
        "type": "AWS"
    },
    "requestParameters": {},
    "methodResponses": {
        "200": {
            "responseModels": {
                "application/json": "Empty"
            },
            "statusCode": "200"
        }
    },
    "authorizationType": "NONE"
}
```

### GET `/secured`

```json
{
    "methodResponses": {
        "200": {
            "responseModels": {
                "application/json": "Empty"
            },
            "statusCode": "200"
        }
    },
    "authorizationType": "CUSTOM",
    "apiKeyRequired": false,
    "httpMethod": "GET",
    "methodIntegration": {
        "integrationResponses": {
            "200": {
                "responseTemplates": {
                    "application/json": null
                },
                "statusCode": "200"
            }
        },
        "cacheKeyParameters": [],
        "uri": "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:990529572879:function:Secured/invocations",
        "httpMethod": "POST",
        "cacheNamespace": "otgbp5",
        "type": "AWS"
    },
    "requestParameters": {
        "method.request.header.X-Access-Token": false
    },
    "authorizerId": "5pyati"
}
```

### POST `/upload/request`

```json
{
    "methodResponses": {
        "200": {
            "responseModels": {
                "application/json": "Empty"
            }, 
            "statusCode": "200"
        }
    }, 
    "requestModels": {
        "application/json": "TokenRequest"
    }, 
    "authorizationType": "CUSTOM", 
    "apiKeyRequired": false, 
    "httpMethod": "POST", 
    "methodIntegration": {
        "integrationResponses": {
            "200": {
                "responseTemplates": {
                    "application/json": null
                }, 
                "statusCode": "200"
            }
        }, 
        "cacheKeyParameters": [], 
        "requestParameters": {
            "integration.request.header.X-Access-Token": "method.request.header.X-Access-Token"
        }, 
        "uri": "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:990529572879:function:RequestToken/invocations", 
        "httpMethod": "POST", 
        "requestTemplates": {
            "application/json": "{\n    \"authorizationToken\": \"$input.params('X-Access-Token')\",\n    \"path\": \"$input.params('X-Path')\"\n}"
        }, 
        "cacheNamespace": "exoxzl", 
        "type": "AWS"
    }, 
    "requestParameters": {
        "method.request.header.X-Access-Token": false
    }, 
    "authorizerId": "5pyati"
}
```
