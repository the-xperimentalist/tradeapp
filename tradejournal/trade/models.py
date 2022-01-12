from django.db import models
from trader.models import Trader


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
