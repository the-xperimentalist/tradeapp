import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile/common/BorderBox.dart';
import 'package:mobile/screens/LoginPage.dart';
import 'package:mobile/screens/subComponents/AddTradeButton.dart';
import 'package:mobile/screens/subComponents/MainInfo.dart';
import 'package:mobile/screens/subComponents/TradeInfo.dart';
import 'package:mobile/utils/ClassTypes.dart';
import 'package:mobile/utils/TradeData.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/utils/widget_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences sharedPreferences;
  dynamic tradeWinInfo = TRADE_WIN_INFO;
  dynamic tradeData = TRADE_DATA;

  checkLoginAndFetchData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (route) => false);
    } else if (sharedPreferences.getString("token") != "-1") {}
  }

  @override
  void initState() {
    super.initState();
    checkLoginAndFetchData();
  }

  uploadTradeSheets() async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://144.126.255.106/api/trades/sheet_upload/"));
    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var file = result.files.single;
      request.files.add(new http.MultipartFile(
          "trade_sheets", file.readStream!, file.size,
          filename: file.name));

      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successfully uploaded sheet!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Upload failed!")));
      }
    }
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    final ThemeData themeData = Theme.of(context);
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
        title: Text(
          'Add Trade Sheet',
          style: TextStyle(color: COLOR_BLACK, fontSize: 16),
        ),
        content: Text("Select Trade Sheet file"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double padding = 25;
    final sidePadding = EdgeInsets.symmetric(horizontal: padding);
    final ThemeData themeData = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Container(
              color: Colors.red,
            )),
            GestureDetector(
                onTap: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  await sharedPreferences.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                      (route) => false);
                },
                child: ListTile(
                  title: Text(
                    "Log Out",
                    style: themeData.textTheme.headline4,
                  ),
                )),
            Divider(
              thickness: 2,
            )
          ],
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addVerticalSpace(padding),
                Padding(
                  padding: sidePadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BorderBox(
                          child: GestureDetector(
                        child: Icon(
                          Icons.menu,
                          color: COLOR_BLACK,
                        ),
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ))
                    ],
                  ),
                ),
                addVerticalSpace(padding),
                Padding(
                  padding: sidePadding,
                  child: Text(
                    "The Wise Traders",
                    style: themeData.textTheme.headline1,
                  ),
                ),
                Padding(
                  padding: sidePadding,
                  child: Divider(
                    height: padding,
                    color: COLOR_GREY,
                  ),
                ),
                Padding(
                  padding: sidePadding,
                  child: MainInfo(),
                ),
                Expanded(
                    child: Padding(
                  padding: sidePadding,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: TradeInfo(),
                  ),
                ))
              ],
            ),
            Positioned(
                bottom: 20,
                width: size.width,
                child: Center(
                  child: AddTradeButton(
                    icon: Icons.add,
                    text: "Upload Sheet",
                    width: size.width * 0.45,
                    onPressed: () {
                      // Navigator.of(context).restorablePush(_dialogBuilder);
                      uploadTradeSheets();
                    },
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
