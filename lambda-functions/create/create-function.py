import json
import boto3

dynamo = boto3.client('dynamodb')

def lambda_handler(event, context):
    
    body = None
    statusCode = 200
    headers = {
    'Content-Type': 'application/json'
    }
    
    try:
        route_key = event['routeKey']
        
        if route_key == 'POST /items':
            response = dynamo.list_tables()
            value = response['TableNames']
            request_json = json.loads(event['body'])
            dynamo.put_item(
                TableName=value[0],
                Item={
                    'id': {'N': request_json['id']},
                    'name': {'S': request_json['name']},
                    'surname': {'S': request_json['surname']},
                    'position': {'S': request_json['position']},
                    'salary': {'S': request_json['salary']},
                }
            )
            body = f"Post item {request_json['id']}"
        else:
            raise ValueError(f"Unsupported route: '{route_key}'")
   
    except Exception as err:
        statusCode = 400
        body = str(err)
   
    finally:
        body = json.dumps(body)

    return {
    'statusCode': statusCode,
    'body': body,
    'headers': headers
    }