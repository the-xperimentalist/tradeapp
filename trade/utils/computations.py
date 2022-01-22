
import math
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
            exec_trader=trader)[:time_range] if time_range == 2 else Trade.objects.filter(exec_trader=trader)
        # portfolio_before = PortfolioStatus.objects.filter(
        #     related_trader = trader, status_date__lte=(curr_datetime - time_range)
        # ).first()
        # portfolio_trade_items = portfolio_before.contained_items.all()
        wins = losses = 0
        largest_loss = 0
        largest_loss_symbol = ""
        symbols = {}
        net_change = 0
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
                            net_change -= sold_quantity * trade.trade_item.price
                            if (buy_val["trade_item"]["price"] - trade.trade_item.price) > largest_loss:
                                largest_loss = buy_val["trade_item"]["price"] - trade.trade_item.price
                                largest_loss_symbol = trade.trade_item.symbol
                        else:
                            wins += sold_quantity
                            net_change += sold_quantity * trade.trade_item.price
                        buy_val["trade_item"]["quantity"] = buy_val["trade_item"]["quantity"] - sold_quantity
                    else:
                        if buy_val["trade_item"]["price"] > trade.trade_item.price:
                            losses += buy_val["trade_item"]["quantity"]
                            net_change -= sold_quantity * trade.trade_item.price
                            if (buy_val["trade_item"]["price"] - trade.trade_item.price) > largest_loss:
                                largest_loss = buy_val["trade_item"]["price"] - trade.trade_item.price
                                largest_loss_symbol = trade.trade_item.symbol
                        else:
                            wins += buy_val["trade_item"]["quantity"]
                            net_change += sold_quantity * trade.trade_item.price
                        sold_quantity -= buy_val["trade_item"]["quantity"]
                        buy_val["trade_item"]["quantity"] = 0
        return {
            "wins": wins,
            "losses": losses,
            "largest_loss": largest_loss,
            "largest_loss_symbol": largest_loss_symbol,
            "pnl": math.fabs(net_change),
            "pnl_type": "profit" if net_change > 0  else "loss"
            }
