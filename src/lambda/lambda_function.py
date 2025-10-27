from typing import Final, Dict
from logger import LOGGER
from s3 import S3Reporter


def _generate_s3_report() -> str:
    s3_reporter = S3Reporter()
    s3_report: Final[Dict] = {
        "empty": s3_reporter.get_empty_s3_buckets(),
        "no_http": s3_reporter.get_no_deny_http_access_buckets(),
    }
    s3_reporter.generate_s3_report(s3_report)
    return "Report generated"


def lambda_handler(_: Dict, __) -> Dict[str, int | str]:
    LOGGER.info("Initalization of report cleanup lambda")
    return {"statusCode": 200, "body": {"s3": _generate_s3_report()}}
