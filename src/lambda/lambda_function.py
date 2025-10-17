from json import dumps
from typing import Final, Dict, List
from logger import LOGGER
from models.s3 import S3Bucket
from s3 import S3Reporter


def _generate_s3_report() -> List[S3Bucket]:
    s3_reporter = S3Reporter()
    s3_empty_report: Final[List[S3Bucket]] = s3_reporter.get_empty_s3_buckets()
    return s3_empty_report


def lambda_handler(event: Dict, _) -> Dict[str, int | str]:
    LOGGER.info("Received event: %s", dumps(event))
    return {"statusCode": 200, "body": {"s3": _generate_s3_report()}}
