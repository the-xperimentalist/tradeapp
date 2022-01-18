
from enum import Enum
from datetime import timedelta


class RangeTime:
    DAY = 0
    WEEK = 1
    MONTH = 2
    TIME_MAPPING = {
        DAY: timedelta(hours=24),
        WEEK: timedelta(days=7),
        MONTH: timedelta(days=30)
    }


class TradeSheetConstants:
    SHEET_LOCATION = "trade_sheets"
    ORDER_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S"
