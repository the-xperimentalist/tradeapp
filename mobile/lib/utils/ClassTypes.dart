
class TradeWinInfo {
  int type;
  int wins;
  int losses;
  int total;
  double biggestLossAmount;
  String biggestLossSymbol;
  double profitLoss;
  String pnl;

  TradeWinInfo(
      this.type,
      this.wins,
      this.losses,
      this.total,
      this.biggestLossAmount,
      this.biggestLossSymbol,
      this.profitLoss,
      this.pnl
      );
}

class PortfolioTrade {
  int id;
  String symbol;
  double entry_price;
  double exit_price;
  int exit_quantity;
  int remaining_quantity;
  double net_profit;
  String status_date;

  PortfolioTrade(
      this.id,
      this.symbol,
      this.entry_price,
      this.exit_price,
      this.exit_quantity,
      this.remaining_quantity,
      this.net_profit,
      this.status_date
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "entry_price": entry_price,
    "exit_price": exit_price,
    "exit_quantity": exit_quantity,
    "remaining_quantity": remaining_quantity,
    "net_profit": net_profit,
    "status_date": status_date
  };
}
