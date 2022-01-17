
from datetime import datetime
from time import time
from trade.models import PortfolioStatus, Trade


class Computations:

    @staticmethod
    def calculate_win_ratio(time_range, trader):
        """
        Calculate the win ratio for the trader in the selected time range
        # Refactor this code
        """
        curr_datetime = datetime.utcnow()
        trades_to_consider = Trade.objects.filter(
            exec_trader=trader, time__gte=(curr_datetime - time_range)).order_by("time")
        # portfolio_before = PortfolioStatus.objects.filter(
        #     related_trader = trader, status_date__lte=(curr_datetime - time_range)
        # ).first()
        # portfolio_trade_items = portfolio_before.contained_items.all()
        wins = losses = 0
        symbols = {}
        for trade in trades_to_consider:
            if trade.trade_type == Trade.SELL and trade.trade_item.symbol not in symbols:
                continue # Such cases are not computed
            elif trade.trade_type == Trade.BUY:
                if trade.trade_item.symbol not in symbols:
                    symbols[trade.trade_item.symbol] = [{
                        "trade_item": {"symbol": trade.trade_item.symbol, "quantity": trade.trade_item.quantity,
                        "price": trade.trade_item.price}, "time": trade.time}]
                else:
                    symbols[trade.trade_item.symbol].append({"trade_item": {
                        "symbol": trade.trade_item.symbol, "quantity": trade.trade_item.quantity,
                        "price": trade.trade_item.price}, "time": trade.time})
            elif trade.trade_type == Trade.SELL:
                sold_quantity = trade.trade_item.quantity
                for buy_val in symbols[trade.trade_item.symbol]:
                    if buy_val["trade_item"]["quantity"] == 0:
                        continue
                    if buy_val["trade_item"]["quantity"] > sold_quantity:
                        if buy_val["trade_item"]["price"] > trade.trade_item.price:
                            losses += sold_quantity
                        else:
                            wins += sold_quantity
                        buy_val["trade_item"]["quantity"] = buy_val["trade_item"]["quantity"] - sold_quantity
                    else:
                        if buy_val["trade_item"]["price"] > trade.trade_item.price:
                            losses += buy_val["trade_item"]["quantity"]
                        else:
                            wins += buy_val["trade_item"]["quantity"]
                        sold_quantity -= buy_val["trade_item"]["quantity"]
                        buy_val["trade_item"]["quantity"] = 0
        return {"wins": wins, "losses": losses}
