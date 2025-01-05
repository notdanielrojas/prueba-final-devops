import json
import os
import boto3

sns_client = boto3.client('sns')
TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    for record in event['Records']:
        message = json.loads(record['body'])
        print(f"Mensaje recibido: {message}")
        response = sns_client.publish(
            TopicArn=TOPIC_ARN,
            Message=json.dumps(message),
            Subject='Mensaje de SQS'
        )

        print(f"Mensaje publicado en SNS: {response}")

    return {
        'statusCode': 200,
        'body': 'Mensajes procesados correctamente'
    }