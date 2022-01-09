from django.db import models
from userprofile.models import Trader


class Trade(models.Model):
    """
    Store the information of the trade
    :field amount: Amount of trade
    :field trade_in: Trade In time
    :field trade_out: Trade Out time
    :field trade_symbol: Trade Symbol
    :field trader: Trader
    """
    amount = models.FloatField(blank=False, null=False)
    trade_in = models.DateTimeField(null=False)
    trade_out = models.DateTimeField(null=False)
    trade_symbol = models.CharField(max_length=63)
    trader = models.ForeignKey(Trader, on_delete=models.CASCADE)
