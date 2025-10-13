from json import dumps


def lambda_handler(event, context):
    print("Received event:", event)
    print("Received context:", context)
    return {"statusCode": 200, "body": dumps("Hello from Lambda!")}
