
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return CustomScrollView(
    //   primary: false,
    //   slivers: <Widget>[
    //     SliverPadding(
    //       padding: const EdgeInsets.all(20),
    //       sliver: SliverGrid.count(
    //         crossAxisSpacing: 10,
    //         mainAxisSpacing: 10,
    //         crossAxisCount: 2,
    //         children: <Widget>[
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             child: const Text("He'd have you all unravel at the"),
    //             color: Colors.green[100],
    //           ),
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             child: const Text('Heed not the rabble'),
    //             color: Colors.green[200],
    //           ),
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             child: const Text('Sound of screams but the'),
    //             color: Colors.green[300],
    //           ),
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             child: const Text('Who scream'),
    //             color: Colors.green[400],
    //           ),
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             child: const Text('Revolution is coming...'),
    //             color: Colors.green[500],
    //           ),
    //           Container(
    //             padding: const EdgeInsets.all(8),
    //             child: const Text('Revolution, they...'),
    //             color: Colors.green[600],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
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
                title: Text('The Enchanted Nightingale'),
                subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('LISTEN'),
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
