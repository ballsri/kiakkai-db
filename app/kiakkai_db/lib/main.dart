import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiakkai_db/form/residents/add_resident_form.dart';
import 'package:kiakkai_db/resident_table.dart';
import 'package:kiakkai_db/room_list.dart';
import 'package:kiakkai_db/vehicle_list.dart';

import 'mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await MongoDatabase.connect();

  runApp(const MyApp());
}

const List<String> titles = <String>['ห้องพัก', 'ผู้พัก', 'รถยนตร์'];

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isRefreshing = false;
  bool _isSearchVisible = false;
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> objects = [];
  ValueNotifier<String> filterNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void onDataLoaded(List<Map<String, dynamic>> data) {
    setState(() {
      objects = data;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearchVisibility() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        filterNotifier.value = '';
      }
    });
  }

  void _setRefresh(bool value) {
    setState(() {
      isRefreshing = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 3;
    return DefaultTabController(
        initialIndex: 1,
        length: tabsCount,
        child: Scaffold(
            appBar: AppBar(
              title: _isSearchVisible
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Align(
                        alignment: Alignment.center,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          autofocus: true,
                          controller: _searchController,
                          onChanged: (String value) {
                            filterNotifier.value = value;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 8.0),
                            hintText: 'ค้นหา',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Text('ข้อมูลที่พักเกียกกาย'),
              backgroundColor:
                  Color(ThemeData.light().colorScheme.inversePrimary.value),
              notificationPredicate: (ScrollNotification notification) {
                return notification.depth == 1;
              },
              actions: [
                IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: _isSearchVisible
                        ? const Icon(Icons.close)
                        : const Icon(Icons.search),
                    tooltip: 'Search',
                    onPressed: _toggleSearchVisibility),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add data',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return  ModalAddData(tab: _tabController.index);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete data',
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
                controller: _tabController,
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
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                RoomList(),
                ValueListenableBuilder<String>(
                  valueListenable: filterNotifier,
                  builder: (context, filter, _) {
                    return objects.isEmpty || isRefreshing
                        ? ResidentTable(
                            filter: filter,
                            onDataLoaded: onDataLoaded,
                            isRefreshing: isRefreshing,
                            setRefresh: _setRefresh)
                        : Material(
                            child: ResidentTableWidget(
                                objects: objects,
                                filter: filter,
                                isRefreshing: isRefreshing,
                                setRefresh: _setRefresh),
                          );
                  },
                ),
                VehicleList(),
              ],
            )));
  }
}

class ModalAddData extends StatelessWidget {
  final int tab;
  const ModalAddData({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            if (tab == 0)
              Text(
                'เพิ่มข้อมูลห้องพัก',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            else if (tab == 1)
              Column(children: [
                Text(
                  'เพิ่มข้อมูลผู้พัก',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Material(
                  child: AddResidentForm(),
                )
              ])
            else if (tab == 2)
              Text(
                'เพิ่มข้อมูลรถ',
                style: Theme.of(context).textTheme.headlineMedium,
              )
          ],
        ),
      ),
    );
  }
}
