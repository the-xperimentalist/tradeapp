from django.db import models
from accounts.models import Trader
from trade.utils.constants import TradeSheetConstants


class TradeSheet(models.Model):
    """
    Keep a note of trade sheets added with their specific times
    """
    UPLOADED_BROKERS = [
        [0, "ZERODHA"],
        [1, "ANGEL"],
        [2, "UPSTOX"],
        [3, "OTHERS"]
    ]
    uploaded_at = models.DateTimeField(auto_now=True)
    sheet_name = models.CharField(max_length=255, blank=False, null=False)
    uploaded_by = models.ForeignKey(Trader, on_delete=models.CASCADE, related_name="sheet_uploader")
    upload_type = models.IntegerField(default=3, choices=UPLOADED_BROKERS)
    raw_file = models.FileField(upload_to=TradeSheetConstants.SHEET_LOCATION)

    class Meta:
        ordering = ("-uploaded_at", )


class TradeItem(models.Model):
    """
    """
    symbol = models.CharField(max_length=32, null=False)
    quantity = models.IntegerField()
    price = models.FloatField()


class Trade(models.Model):
    """
    The model contains the details for the trade #TODO: Figure the case of multiple trade details from different places
    :field trade_symbol: Trade symbol here
    :field trade_in: The time when trade started
    :field trade_out: The time when trade ended
    :field exec_trader: Trader who executed the trade
    """
    NSE = 0
    BSE = 1
    EXCHANGES_LIST = [
        [NSE, "NSE"],
        [BSE, "BSE"]
    ]

    BUY = 0
    SELL = 1
    TRADE_TYPES = [
        [BUY, "BUY"],
        [SELL, "SELL"]
    ]
    exchange = models.IntegerField(choices=EXCHANGES_LIST)
    time = models.DateTimeField()
    trade_type = models.IntegerField(choices=TRADE_TYPES)
    trade_item = models.ForeignKey(TradeItem, on_delete=models.CASCADE)
    exec_trader = models.ForeignKey(Trader, on_delete=models.CASCADE, related_name="trader")
    related_trade_sheet = models.ForeignKey(TradeSheet, on_delete=models.SET_NULL, null=True, related_name="sheet")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ("-created_at", )

    def __str__(self) -> str:
        return f"{self.trade_item.symbol}|{self.trade_item.quantity}|{self.trade_item.price}"


class PortfolioStatus(models.Model):
    """
    The model contains the details for the portfolio status at a given point of time
    """
    related_trader = models.ForeignKey(Trader, on_delete=models.CASCADE, related_name="owner")
    status_date = models.DateField()
    contained_items = models.ManyToManyField(TradeItem)

    class Meta:
        ordering = ("-status_date",)
