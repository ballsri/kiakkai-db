import 'package:flutter/material.dart';
import 'package:kiakkai_db/resident_list.dart';
import 'package:kiakkai_db/room_list.dart';
import 'package:kiakkai_db/vehicle_list.dart';

import 'mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await MongoDatabase.connect();

  runApp(const MyApp());
}

const List<String> titles = <String>[
  'ห้องพัก',
  'รายชื่อผู้พัก',
  'ข้อมูลรถยนตร์',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiakkai DB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'ข้อมูลผู้พักเกียกกาย'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 3;

    return DefaultTabController(
        initialIndex: 0,
        length: tabsCount,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('ข้อมูลที่พักเกียกกาย'),
              backgroundColor:
                  Color(ThemeData.light().colorScheme.inversePrimary.value),
              notificationPredicate: (ScrollNotification notification) {
                return notification.depth == 1;
              },
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () {
                    // handle the press
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'More',
                  onPressed: () {
                    // handle the press
                  },
                ),
              ],
              // The elevation value of the app bar when scroll view has
              // scrolled underneath the app bar.
              scrolledUnderElevation: 4.0,
              shadowColor: Theme.of(context).shadowColor,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: const Icon(Icons.home),
                    text: titles[0],
                  ),
                  Tab(
                    icon: const Icon(Icons.people),
                    text: titles[1],
                  ),
                  Tab(
                    icon: const Icon(Icons.car_crash_sharp),
                    text: titles[2],
                  ),
                ],
              ),
            ),
            body: const TabBarView(
              children: <Widget>[
                RoomList(),
                ResidentList(),
                VehicleList(),
              ],
            )));
  }
}
