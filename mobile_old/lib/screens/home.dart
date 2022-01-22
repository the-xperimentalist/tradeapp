import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  // const Home({Key? key}) : super(key: key);
  int noOfWins = 0;
  int noOfLosses = 0;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    setWinsLosses(1);
  }

  setWinsLosses(int searchTime) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var jsonResponse = null;
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/api/trades/home/1/"));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          noOfWins = jsonResponse['wins'];
          noOfLosses = jsonResponse['losses'];
        });
      }
    }
  }

  // @override
  // void didUpdateWidget(Widget oldWidget) {
  //   if (oldWidget.noOfWins !=)
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Welcome Mayank Prasoon!',
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('Your win ratio for the last 1 week is:'),
                subtitle: Text('86/106'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Select time range:"),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('1 week'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('1 month'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
