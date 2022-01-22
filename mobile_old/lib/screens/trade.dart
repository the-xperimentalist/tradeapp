import 'package:flutter/material.dart';

class Trade extends StatefulWidget {
  const Trade({Key? key}) : super(key: key);

  @override
  State<Trade> createState() => _TradePageState();
}

class _TradePageState extends State<Trade> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 120,
          color: Colors.amber[600],
          child: ListView(
            children: <Widget>[
              Text("Time: 2022-01-14T11:15:23Z"),
              Text("Symbol: XYZ"),
              Text("Type: Buy"),
              Text("Quantity: 10"),
              Text("Price: 100"),
              Text("Exchange: NSE"),
              Text("TradeSheet: Yes")
            ],
          ),
        ),
        Container(
          height: 120,
          color: Colors.amber[600],
          child: ListView(
            children: <Widget>[
              Text("Time: 2022-01-14T14:15:23Z"),
              Text("Symbol: XYZ"),
              Text("Type: Buy"),
              Text("Quantity: 12"),
              Text("Price: 103"),
              Text("Exchange: NSE"),
              Text("TradeSheet: Yes")
            ],
          ),
        ),
        Container(
          height: 120,
          color: Colors.amber[600],
          child: ListView(
            children: <Widget>[
              Text("Time: 2022-01-15T14:15:23Z"),
              Text("Symbol: XYZ"),
              Text("Type: Sell"),
              Text("Quantity: 16"),
              Text("Price: 109"),
              Text("Exchange: NSE"),
              Text("TradeSheet: Yes")
            ],
          ),
        ),
        Container(
          height: 120,
          color: Colors.amber[600],
          child: ListView(
            children: <Widget>[
              Text("Time: 2022-01-15T14:15:23Z"),
              Text("Symbol: XYZ"),
              Text("Type: Buy"),
              Text("Quantity: 12"),
              Text("Price: 102"),
              Text("Exchange: NSE"),
              Text("TradeSheet: Yes")
            ],
          ),
        ),
        Container(
          height: 120,
          color: Colors.amber[600],
          child: ListView(
            children: <Widget>[
              Text("Time: 2022-01-14T14:15:23Z"),
              Text("Symbol: XYZ"),
              Text("Type: Buy"),
              Text("Quantity: 10"),
              Text("Price: 100"),
              Text("Exchange: NSE"),
              Text("TradeSheet: Yes")
            ],
          ),
        ),
        Container(
          height: 120,
          color: Colors.amber[600],
          child: ListView(
            children: <Widget>[
              Text("Time: 2022-01-14T14:15:23Z"),
              Text("Symbol: XYZ"),
              Text("Type: Buy"),
              Text("Quantity: 10"),
              Text("Price: 100"),
              Text("Exchange: NSE"),
              Text("TradeSheet: Yes")
            ],
          ),
        ),
      ],
    );
  }

}
