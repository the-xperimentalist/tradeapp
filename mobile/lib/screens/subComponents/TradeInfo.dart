import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/utils/ClassTypes.dart';
import 'package:mobile/utils/TradeData.dart';
import 'package:mobile/utils/widget_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TradeInfo extends StatefulWidget {
  const TradeInfo({Key? key}) : super(key: key);

  @override
  _TradeInfoState createState() => _TradeInfoState();
}

class _TradeInfoState extends State<TradeInfo> {
  late SharedPreferences sharedPreferences;
  List<PortfolioTrade> _portfolioTradeList = <PortfolioTrade>[];

  @override
  void initState() {
    super.initState();
    fetchPortfolioTrades();
  }

  fetchPortfolioTrades() async {

    sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    if (token != '-1') {
      var jsonResponse = null;
      var response = await http.get(
          Uri.parse("http://10.0.2.2:8000/api/trades/portfolio/"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}'
      });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        List<PortfolioTrade> newList = <PortfolioTrade>[];
        for (var obj in jsonResponse) {
          newList.add(PortfolioTrade(
              obj['id'],
              obj['symbol'],
          obj['entry_price'],
              obj['exit_price'],
          obj['exit_quantity'],
          obj['remaining_quantity'],
              obj['net_profit'], obj['status_date']
          ));
        }
        setState(() {
          _portfolioTradeList = newList;
        });
      }
    }
  }

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
              children: _portfolioTradeList.length==0 ? TRADE_DATA.map(
                  (eachItemData) => TradeInfoItem(itemData: eachItemData)
              ).toList() : _portfolioTradeList.map(
                  (eachItemData) => TradeInfoItem(itemData: eachItemData.toJson())
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
          Text("Trade Date: ${itemData['status_date']}", style: themeData.textTheme.headline3,),
          addVerticalSpace(10),
          Text("Symbol: ${itemData['symbol']}"),
          addVerticalSpace(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Entry Price: ", style: themeData.textTheme.bodyText1,),
              Text("${itemData['entry_price']}", style: themeData.textTheme.bodyText1,),
              Text("Exit Price:", style: themeData.textTheme.bodyText1,),
              Text("${itemData['exit_price']}", style: themeData.textTheme.bodyText1,)
            ],
          ),
          addVerticalSpace(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sold Quantity: ", style: themeData.textTheme.bodyText1,),
              Text("${itemData['exit_quantity']}", style: themeData.textTheme.bodyText1,),
              Text("Remaining: ", style: themeData.textTheme.bodyText1,),
              Text("${itemData['remaining_quantity']}", style: themeData.textTheme.bodyText1,)
            ],
          ),
          addVerticalSpace(10),
          Text("Net Profit: ${itemData['net_profit']}", style: themeData.textTheme.headline4,),
          addVerticalSpace(20)
        ],
      )
    );
  }
}
