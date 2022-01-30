import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/utils/ClassTypes.dart';
import 'package:mobile/utils/TradeData.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/widget_function.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainInfo extends StatefulWidget {
  const MainInfo({Key? key}) : super(key: key);

  @override
  _MainInfoState createState() => _MainInfoState();
}

class _MainInfoState extends State<MainInfo> {
  int _selectedTimeRange = 0;
  String? _username = '';
  String? _token = '';
  late SharedPreferences sharedPreferences;
  TradeWinInfo? _tradeWinInfo = null;

  @override
  void initState() {
    super.initState();
    setStateVars();
  }

  fetchWinInfo(int selectedIndex) async {
    if (_token != "-1") {
      var jsonResponse = null;
      var response = await http.get(
          Uri.parse(
              "https://thewisetraders.azurewebsites.net/api/trades/home/${selectedIndex}"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': "Bearer ${_token}"
          });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        TradeWinInfo tradeWinInfo = TradeWinInfo(
            _selectedTimeRange,
            jsonResponse['wins'],
            jsonResponse['losses'],
            jsonResponse['total'],
            jsonResponse['biggestLossAmount'],
            jsonResponse['biggestLossSymbol'],
            jsonResponse['Profit/Loss'],
            jsonResponse['pnl']);
        setState(() {
          _tradeWinInfo = tradeWinInfo;
        });
      }
    } else {
      setState(() {
        _tradeWinInfo = null;
      });
    }
  }

  setStateVars() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? username = sharedPreferences.getString("username");
    String? token = sharedPreferences.getString("token");
    setState(() {
      _username = username;
      _token = token;
    });
    fetchWinInfo(_selectedTimeRange);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addVerticalSpace(10),
          Text(
            "Welcome ${_username}",
            style: themeData.textTheme.headline2,
          ),
          addVerticalSpace(20),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Select trade range: ",
                  style: themeData.textTheme.headline5,
                ),
                ChoiceOption(
                    text: "10",
                    onTap: () {
                      setState(() {
                        _selectedTimeRange = 0;
                      });
                      fetchWinInfo(0);
                    },
                    selected: _selectedTimeRange == 0,
                    type: 0),
                ChoiceOption(
                    text: "100",
                    onTap: () {
                      setState(() {
                        _selectedTimeRange = 1;
                      });
                      fetchWinInfo(1);
                    },
                    selected: _selectedTimeRange == 1,
                    type: 1),
                ChoiceOption(
                    text: "all",
                    onTap: () {
                      setState(() {
                        _selectedTimeRange = 2;
                      });
                      fetchWinInfo(2);
                    },
                    selected: _selectedTimeRange == 2,
                    type: 2)
              ],
            ),
          ),
          addVerticalSpace(15),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Win Ratio",
                        style: themeData.textTheme.bodyText1,
                      ),
                      Text(
                        "${_tradeWinInfo != null ? _tradeWinInfo?.wins : TRADE_WIN_INFO[_selectedTimeRange]["wins"]}/${_tradeWinInfo != null ? _tradeWinInfo?.total : TRADE_WIN_INFO[_selectedTimeRange]["total"]}",
                        style: themeData.textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
                addVerticalSpace(15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Biggest Loss",
                        style: themeData.textTheme.bodyText1,
                      ),
                      Text(
                        "${_tradeWinInfo != null ? _tradeWinInfo?.biggestLossSymbol : TRADE_WIN_INFO[_selectedTimeRange]['biggestLossSymbol']}",
                        style: themeData.textTheme.bodyText1,
                      ),
                      Text(
                        "${_tradeWinInfo != null ? _tradeWinInfo?.biggestLossAmount : TRADE_WIN_INFO[_selectedTimeRange]['biggestLossAmount']}/unit",
                        style: themeData.textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
                addVerticalSpace(15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Avg ${_tradeWinInfo != null ? _tradeWinInfo?.pnl : TRADE_WIN_INFO[_selectedTimeRange]['pnl']} %",
                        style: themeData.textTheme.bodyText1,
                      ),
                      Text(
                        "${_tradeWinInfo != null ? _tradeWinInfo?.profitLoss : TRADE_WIN_INFO[_selectedTimeRange]['Profit/Loss']}%",
                        style: themeData.textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
                addVerticalSpace(15)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChoiceOption extends StatelessWidget {
  const ChoiceOption(
      {Key? key,
      required this.text,
      required this.onTap,
      required this.selected,
      required this.type})
      : super(key: key);

  final String text;
  final dynamic onTap;
  final bool selected;
  final int type;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              selected ? COLOR_GREY.withAlpha(100) : COLOR_GREY.withAlpha(25)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      margin: EdgeInsets.only(left: 25),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: themeData.textTheme.headline5,
        ),
      ),
    );
  }
}
