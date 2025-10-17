from typing import TypedDict
from datetime import datetime


class S3Bucket(TypedDict):
    Name: str
    CreationDate: datetime | str
