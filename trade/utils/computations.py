
import math
from datetime import datetime
from statistics import quantiles
from time import time
from trade.models import PortfolioStatus, Trade, TradeItem


class Computations:

    @staticmethod
    def calculate_win_ratio(trader, trades_to_consider, create_portfolio=False):
        """
        Calculate the win ratio for the trader in the selected time range
        # Refactor this code
        """
        curr_datetime = datetime.utcnow()
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
                    symbols[trade.trade_item.symbol] = {
                        "time": trade.time,
                        "trade_item": {
                            "symbol": trade.trade_item.symbol,
                            "quantity": trade.trade_item.quantity,
                            "price": trade.trade_item.price
                        }
                    }
                else:
                    new_symbol_quantity = trade.trade_item.quantity + symbols[trade.trade_item.symbol]["trade_item"]["quantity"]
                    new_symbol_price = (trade.trade_item.quantity * trade.trade_item.price + symbols[trade.trade_item.symbol]["trade_item"]["quantity"] * symbols[trade.trade_item.symbol]["trade_item"]["price"]) / new_symbol_quantity
                    symbols[trade.trade_item.symbol] = {
                        "time": trade.time,
                        "trade_item": {
                            "symbol": trade.trade_item.symbol,
                            "quantity": new_symbol_quantity,
                            "price": new_symbol_price
                        }
                    }
                # if trade.trade_item.symbol not in symbols:
                #     symbols[trade.trade_item.symbol] = [{
                #         "trade_item": {"symbol": trade.trade_item.symbol, "quantity": trade.trade_item.quantity,
                #         "price": trade.trade_item.price}, "time": trade.time}]
                # else:
                #     symbols[trade.trade_item.symbol].append({"trade_item": {
                #         "symbol": trade.trade_item.symbol, "quantity": trade.trade_item.quantity,
                #         "price": trade.trade_item.price}, "time": trade.time})
            elif trade.trade_type == Trade.SELL:
                sold_quantity = trade.trade_item.quantity

                trade_value = symbols[trade.trade_item.symbol]
                if trade_value["trade_item"]["quantity"] == 0:
                    continue
                elif trade_value["trade_item"]["quantity"] > sold_quantity:
                    trade_value["trade_item"]["quantity"] = trade_value["trade_item"]["quantity"] - sold_quantity
                    if trade_value["trade_item"]["price"] > trade.trade_item.price:
                        losses += sold_quantity
                        net_change -= sold_quantity * trade.trade_item.price
                        if (trade_value["trade_item"]["price"] - trade.trade_item.price) > largest_loss:
                            largest_loss = trade_value["trade_item"]["price"] - trade.trade_item.price
                            largest_loss_symbol = trade.trade_item.symbol
                    else:
                        wins += sold_quantity
                        net_change += sold_quantity * trade.trade_item.price
                    if create_portfolio:
                        trade_item = TradeItem(
                            symbol=trade.trade_item.symbol,
                            price = trade_value["trade_item"]["price"],
                            quantity = sold_quantity
                        )
                        trade_item.save()
                        status = PortfolioStatus(
                            related_trader=trader,
                            status_date=trade.time.date(),
                            contained_item=trade_item,
                            exit_price=trade.trade_item.price,
                            remaining_quantity=trade_value["trade_item"]["quantity"]-sold_quantity,
                            net_profit=(trade.trade_item.price - trade_value["trade_item"]["price"]) * sold_quantity
                        )
                        status.save()
                else:
                    if trade_value["trade_item"]["price"] > trade.trade_item.price:
                        losses += trade_value["trade_item"]["quantity"]
                        net_change -= sold_quantity * trade.trade_item.price
                        if (trade_value["trade_item"]["price"] - trade.trade_item.price) > largest_loss:
                            largest_loss = trade_value["trade_item"]["price"] - trade.trade_item.price
                            largest_loss_symbol = trade.trade_item.symbol
                    else:
                        wins += trade_value["trade_item"]["quantity"]
                        net_change += sold_quantity * trade.trade_item.price
                    sold_quantity -= trade_value["trade_item"]["quantity"]
                    trade_value["trade_item"]["quantity"] = 0

                    if create_portfolio:
                        trade_item = TradeItem(
                            symbol=trade.trade_item.symbol,
                            price=trade_value["trade_item"]["price"],
                            quantity=sold_quantity
                        )
                        trade_item.save()
                        status = PortfolioStatus(
                            related_trader=trader,
                            status_date=trade.time.date(),
                            contained_item=trade_item,
                            exit_price=trade.trade_item.price,
                            remaining_quantity=0,
                            net_profit=(trade.trade_item.price - trade_value["trade_item"]["price"]) * sold_quantity
                        )
                        status.save()

                # for buy_val in symbols[trade.trade_item.symbol]:
                #     if buy_val["trade_item"]["quantity"] == 0:
                #         continue
                #     if buy_val["trade_item"]["quantity"] > sold_quantity:
                #         if buy_val["trade_item"]["price"] > trade.trade_item.price:
                #             losses += sold_quantity
                #             net_change -= sold_quantity * trade.trade_item.price
                #             if (buy_val["trade_item"]["price"] - trade.trade_item.price) > largest_loss:
                #                 largest_loss = buy_val["trade_item"]["price"] - trade.trade_item.price
                #                 largest_loss_symbol = trade.trade_item.symbol
                #         else:
                #             wins += sold_quantity
                #             net_change += sold_quantity * trade.trade_item.price
                #         buy_val["trade_item"]["quantity"] = buy_val["trade_item"]["quantity"] - sold_quantity
                #     else:
                #         if buy_val["trade_item"]["price"] > trade.trade_item.price:
                #             losses += buy_val["trade_item"]["quantity"]
                #             net_change -= sold_quantity * trade.trade_item.price
                #             if (buy_val["trade_item"]["price"] - trade.trade_item.price) > largest_loss:
                #                 largest_loss = buy_val["trade_item"]["price"] - trade.trade_item.price
                #                 largest_loss_symbol = trade.trade_item.symbol
                #         else:
                #             wins += buy_val["trade_item"]["quantity"]
                #             net_change += sold_quantity * trade.trade_item.price
                #         sold_quantity -= buy_val["trade_item"]["quantity"]
                #         buy_val["trade_item"]["quantity"] = 0
        return {
            "wins": wins,
            "losses": losses,
            "largest_loss": largest_loss,
            "largest_loss_symbol": largest_loss_symbol,
            "pnl": math.fabs(net_change),
            "pnl_type": "profit" if net_change > 0  else "loss"
            }
