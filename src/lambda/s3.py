from boto3 import client
from boto3.session import Session
from typing import Final, Dict, List
from models.s3 import S3Bucket


s3_client: Final[Session] = client("s3")


class S3Reporter:

    def get_all_buckets(self) -> List[S3Bucket]:
        response: Final[Dict] = s3_client.list_buckets()
        buckets: List[S3Bucket] = response.get("Buckets", [])
        return buckets

    def is_empty(self, bucket_name: str) -> bool:

        assert isinstance(bucket_name, str), "Bucket name must be a string"
        assert bucket_name, "Bucket name cannot be empty"

        s3_content: Final[Dict] = s3_client.list_objects_v2(
            Bucket=bucket_name, MaxKeys=1
        )
        return s3_content.get("KeyCount", 0) == 0
