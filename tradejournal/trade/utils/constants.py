
from enum import Enum
from datetime import timedelta


class RangeTime:
    DAY = timedelta(hours=24)
    WEEK = timedelta(days=7)
    MONTH = timedelta(days=30)
