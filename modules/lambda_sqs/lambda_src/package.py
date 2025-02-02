import json
import boto3
import os
from pymongo import MongoClient

# AWS clients
sqs = boto3.client('sqs')
secretsmanager = boto3.client('secretsmanager')

# Get environment variables
SQS_QUEUE_URL = os.getenv('SQS_QUEUE_URL')
MONGO_SECRET_ARN = os.getenv('MONGO_SECRET_ARN')

# Get MongoDB connection string from AWS Secrets Manager
def get_mongo_connection_string():
    secret_value = secretsmanager.get_secret_value(SecretId=MONGO_SECRET_ARN)
    secret_dict = json.loads(secret_value['SecretString'])
    return secret_dict['connection_string']

def lambda_handler(event, context):
    # Get MongoDB connection
    mongo_conn_str = get_mongo_connection_string()
    client = MongoClient(mongo_conn_str)
    db = client["food-orders"]    # Project: Clarity, Database: food-orders
    collection = db["requests"]

    for record in event['Records']:
        message_body = json.loads(record['body'])

        # Insert into MongoDB Atlas
        collection.insert_one({
            "order_id": message_body["order_id"],
            "customer": message_body["customer"],
            "items": message_body["items"],
            "total_price": message_body["total_price"],
            "timestamp": message_body["timestamp"]
        })

        # Delete message from SQS after processing
        sqs.delete_message(
            QueueUrl=SQS_QUEUE_URL,
            ReceiptHandle=record['receiptHandle']
        )

    return {"statusCode": 200, "body": "Messages processed successfully"}

