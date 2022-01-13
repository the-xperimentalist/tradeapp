from django.db import models
from accounts.models import Trader


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

    class Meta:
        ordering = ("-uploaded_at", )


class Trade(models.Model):
    """
    The model contains the details for the trade #TODO: Figure the case of multiple trade details from different places
    :field trade_symbol: Trade symbol here
    :field trade_in: The time when trade started
    :field trade_out: The time when trade ended
    :field exec_trader: Trader who executed the trade
    """
    trade_symbol = models.CharField(max_length=8, null=False)
    trade_in = models.DateTimeField()
    trade_out = models.DateTimeField()
    exec_trader = models.ForeignKey(Trader, on_delete=models.CASCADE, related_name="trader")
    related_trade_sheet = models.ForeignKey(TradeSheet, on_delete=models.SET_NULL, null=True, related_name="sheet")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ("-created_at", )
