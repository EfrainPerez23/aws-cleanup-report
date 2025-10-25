from boto3 import client
from boto3.session import Session
from typing import Final, Dict, List
from models.s3 import S3Bucket
from datetime import datetime
from botocore.exceptions import ClientError
from json import loads

s3_client: Final[Session] = client("s3")


class S3Reporter:

    def _clean_s3_bucket_creation_date(self, s3_bucket: S3Bucket) -> S3Bucket:
        assert s3_bucket, "S3 bucket cannot be null"
        if isinstance(s3_bucket["CreationDate"], datetime):
            s3_bucket["CreationDate"] = s3_bucket["CreationDate"].isoformat()
        return s3_bucket

    def get_empty_s3_buckets(self) -> List[S3Bucket]:
        return [
            bucket for bucket in self.get_all_buckets() if self.is_empty(bucket["Name"])
        ]

    def get_no_deny_http_access_buckets(self) -> List[S3Bucket]:
        return [
            bucket
            for bucket in self.get_all_buckets()
            if not self.check_bucket_deny_http_access_policy(bucket["Name"])
        ]

    def get_all_buckets(self) -> List[S3Bucket]:
        response: Final[Dict] = s3_client.list_buckets()
        buckets: List[S3Bucket] = response.get("Buckets", [])
        return [self._clean_s3_bucket_creation_date(b) for b in buckets]

    def get_policy_s3_bucket(self, bucket_name: str) -> Dict:
        assert bucket_name, "S3 bucket cannot be null"
        assert isinstance(bucket_name, str), "Bucket name must be a string"
        try:
            return loads(s3_client.get_bucket_policy(Bucket=bucket_name)["Policy"])
        except ClientError:
            return {"Policy": {}}

    def check_bucket_deny_http_access_policy(self, bucket_name: str) -> bool:
        assert bucket_name, "S3 bucket cannot be null"
        assert isinstance(bucket_name, str), "Bucket name must be a string"

        s3_bucket_policy: Final[Dict] = self.get_policy_s3_bucket(bucket_name)
        statemests: Final[List[Dict]] = s3_bucket_policy.get("Statement", [])

        for statement in statemests:
            condition: Dict = statement.get("Condition", {})
            if "Bool" in condition:
                bools: Dict = condition["Bool"]
                if (
                    "aws:SecureTransport" in bools
                    and bools["aws:SecureTransport"] == "false"
                ):
                    return True

        return False

    def is_empty(self, bucket_name: str) -> bool:
        assert isinstance(bucket_name, str), "Bucket name must be a string"
        assert bucket_name, "Bucket name cannot be empty"

        s3_content: Final[Dict] = s3_client.list_objects_v2(
            Bucket=bucket_name, MaxKeys=1
        )
        return s3_content.get("KeyCount", 0) == 0
