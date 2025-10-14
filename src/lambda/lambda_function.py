from json import dumps
from logging import getLogger, INFO, Logger
from typing import Final, Dict, Union

logger: Final[Logger] = getLogger()
logger.setLevel(INFO)


def lambda_handler(event: Dict, _) -> Dict[str, Union[int, str]]:
    logger.info("Received event: %s", dumps(event))
    return {"statusCode": 200, "body": dumps("Hello from Lambda!")}
