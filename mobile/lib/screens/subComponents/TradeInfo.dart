import 'package:flutter/material.dart';
import 'package:mobile/utils/TradeData.dart';
import 'package:mobile/utils/widget_function.dart';

class TradeInfo extends StatefulWidget {
  const TradeInfo({Key? key}) : super(key: key);

  @override
  _TradeInfoState createState() => _TradeInfoState();
}

class _TradeInfoState extends State<TradeInfo> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addVerticalSpace(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Your trades: ", style: themeData.textTheme.headline3),
          ],
        ),
          addVerticalSpace(10),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: TRADE_DATA.map(
                  (eachItemData) => TradeInfoItem(itemData: eachItemData)
              ).toList(),
            ),
          ),
        ],
      );
  }
}

class TradeInfoItem extends StatelessWidget {
  const TradeInfoItem({
    Key? key,
  required this.itemData}) : super(key: key);

  final dynamic itemData;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      child: Column(
        children: [
          addVerticalSpace(10),
          Text("Trade Date: ${itemData['date']}", style: themeData.textTheme.headline3,),
          addVerticalSpace(10),
          Text("Symbol: ${itemData['symbol']}"),
          addVerticalSpace(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Entry Price: ", style: themeData.textTheme.bodyText1,),
              Text("${itemData['entryPrice']}", style: themeData.textTheme.bodyText1,),
              Text("Exit Price:", style: themeData.textTheme.bodyText1,),
              Text("${itemData['exitPrice']}", style: themeData.textTheme.bodyText1,)
            ],
          ),
          addVerticalSpace(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sold Quantity: ", style: themeData.textTheme.bodyText1,),
              Text("${itemData['exitQuantity']}", style: themeData.textTheme.bodyText1,),
              Text("Remaining: ", style: themeData.textTheme.bodyText1,),
              Text("${itemData['remainingQuantity']}", style: themeData.textTheme.bodyText1,)
            ],
          ),
          addVerticalSpace(10),
          Text("Net Profit: ${itemData['profit/loss']}", style: themeData.textTheme.headline4,),
          addVerticalSpace(20)
        ],
      )
    );
  }
}
