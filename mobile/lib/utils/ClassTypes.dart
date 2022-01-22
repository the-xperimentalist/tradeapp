
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
  double entryPrice;
  double exitPrice;
  int exitQuantity;
  int remainingQuantity;
  int pnl;

  PortfolioTrade(
      this.id,
      this.symbol,
      this.entryPrice,
      this.exitPrice,
      this.exitQuantity,
      this.remainingQuantity,
      this.pnl
      );
}
