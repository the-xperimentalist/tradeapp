import 'package:flutter/material.dart';
import 'package:mobile/utils/TradeData.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/widget_function.dart';


class MainInfo extends StatefulWidget {
  const MainInfo({Key? key}) : super(key: key);

  @override
  _MainInfoState createState() => _MainInfoState();
}

class _MainInfoState extends State<MainInfo> {
  int _selectedTimeRange = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addVerticalSpace(10),
          Text("Welcome Mayank Prasoon!", style: themeData.textTheme.headline2,),
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
                    },
                selected: _selectedTimeRange == 0,
                type: 0),
                ChoiceOption(
                    text: "50",
                    onTap: () {
                      setState(() {
                        _selectedTimeRange = 1;
                      });
                    },
                selected: _selectedTimeRange == 1,
                type: 1),
                ChoiceOption(
                    text: "all",
                    onTap: () {
                      setState(() {
                        _selectedTimeRange = 2;
                      });
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
                      Text("Win Ratio", style: themeData.textTheme.bodyText1,),
                      Text("${TRADE_WIN_INFO[_selectedTimeRange]["wins"]}/${TRADE_WIN_INFO[_selectedTimeRange]["total"]}", style: themeData.textTheme.bodyText1,)
                    ],
                  ),
                ),
                addVerticalSpace(15),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Biggest Loss", style: themeData.textTheme.bodyText1,),
                    Text("${TRADE_WIN_INFO[_selectedTimeRange]['biggestLossSymbol']}", style: themeData.textTheme.bodyText1,),
                    Text("${TRADE_WIN_INFO[_selectedTimeRange]['biggestLossAmount']}/unit", style: themeData.textTheme.bodyText1,)
                  ],
                ),
                ),
                addVerticalSpace(15),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Avg ${TRADE_WIN_INFO[_selectedTimeRange]['pnl']} %", style: themeData.textTheme.bodyText1,),
                    Text("${TRADE_WIN_INFO[_selectedTimeRange]['Profit/Loss']}%", style: themeData.textTheme.bodyText1,)
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
  const ChoiceOption({
    Key? key,
  required this.text,
  required this.onTap,
  required this.selected,
  required this.type}) : super(key: key);

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
        color: selected ? COLOR_GREY.withAlpha(100) : COLOR_GREY.withAlpha(25)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      margin: EdgeInsets.only(left: 25),
      child: GestureDetector(
        onTap: onTap,
        child: Text(text, style: themeData.textTheme.headline5,),
      ),
    );
  }
}

