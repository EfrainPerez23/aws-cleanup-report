from json import dumps
from logging import getLogger, INFO, Logger
from typing import Final, Any, Dict

logger: Final[Logger] = getLogger()
logger.setLevel(INFO)


def lambda_handler(event, context) -> Dict[str, Any]:
    logger.info("Received event:", event)
    logger.info("Received context:", context)
    return {"statusCode": 200, "body": dumps("Hello from Lambda!")}
