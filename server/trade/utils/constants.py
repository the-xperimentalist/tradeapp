
from enum import Enum
from datetime import timedelta


class RangeTime:
    DAY = 0
    WEEK = 1
    MONTH = 2
    TIME_MAPPING = {
        DAY: 10,
        WEEK: 100,
        MONTH: 1000
    }


class TradeSheetConstants:
    SHEET_LOCATION = "trade_sheets"
    ORDER_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S"
