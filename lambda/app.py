import json
import os
import boto3
import uuid
from datetime import datetime, timezone

dynamodb = boto3.resource("dynamodb")
table_name = os.environ.get("TABLE_NAME")
table = dynamodb.Table(table_name)


def response(status_code, body):
return {
"statusCode": status_code,
"headers": {
"Content-Type": "application/json"
},
"body": json.dumps(body)
}


def lambda_handler(event, context):
request_context = event.get("requestContext", {})
http = request_context.get("http", {})
method = http.get("method", "")
path = event.get("rawPath", "")

if method == "GET" and path == "/health":
return response(200, {
"status": "ok",
"message": "API is healthy"
})

if method == "POST" and path == "/items":
body = json.loads(event.get("body") or "{}")

item = {
"id": str(uuid.uuid4()),
"name": body.get("name", "default-item"),
"created_at": datetime.now(timezone.utc).isoformat()
}

table.put_item(Item=item)

return response(200, {
"message": "item created",
"item": item
})

if method == "GET" and path == "/items":
result = table.scan()
items = result.get("Items", [])

return response(200, items)

return response(404, {
"message": "not found"
})

