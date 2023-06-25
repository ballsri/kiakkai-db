import 'package:flutter/material.dart';
import 'package:kiakkai_db/form/rooms/edit_room_form.dart';
import 'package:kiakkai_db/resident_list.dart';

import 'mongodb.dart';

class ResidentTable extends StatelessWidget {
  final String filter;
  final Function(List<Map<String, dynamic>>)? onDataLoaded;
  final dynamic Function(bool)? setRefresh;
  final dynamic Function()? toggleSelectMode;
  final bool isSelectMode;
  final bool isRefreshing;
  final List<String> selectedRows;
  final void Function(List<String>)? onSelectedRowsChanged;
  const ResidentTable(
      {super.key,
      required this.filter,
      this.onDataLoaded,
      this.setRefresh,
      required this.isRefreshing,
      this.toggleSelectMode,
      required this.isSelectMode,
      required this.selectedRows,
      this.onSelectedRowsChanged});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: MongoDatabase.getResidentsWithRoom(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (onDataLoaded != null) {
              onDataLoaded!(data ?? []);
            }
            setRefresh!(false);
          });

          return Material(
            child: ResidentTableWidget(
              objects: data ?? [],
              filter: filter,
              setRefresh: setRefresh,
              isRefreshing: isRefreshing,
              isSelectMode: isSelectMode,
              toggleSelectMode: toggleSelectMode,
              selectedRows: selectedRows,
              onSelectedRowsChanged: onSelectedRowsChanged,
            ),
          );
        }
      },
    );
  }
}

class ResidentTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> objects;
  final String filter;
  final bool isSelectMode;
  final bool isRefreshing;
  final dynamic Function(bool)? setRefresh;
  final dynamic Function()? toggleSelectMode;
  final List<String> selectedRows;
  final void Function(List<String>)? onSelectedRowsChanged;
  const ResidentTableWidget(
      {super.key,
      required this.objects,
      required this.filter,
      this.setRefresh,
      required this.isRefreshing,
      required this.isSelectMode,
      this.toggleSelectMode,
      required this.selectedRows,
      this.onSelectedRowsChanged});

  @override
  State<StatefulWidget> createState() => _ResidentTableWidgetState();
}

class _ResidentTableWidgetState extends State<ResidentTableWidget> {
  String filter = '';
  late List<Map<String, dynamic>> objects;
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();
  bool isRefreshing = false;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  double _dragExtent = 0;

  void _sortObjects(int columnIndex, bool asc) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = asc;
      if (columnIndex == 0) {
        if (asc) {
          objects.sort((a, b) => int.parse(a['room'][0]['room_number'])
              .compareTo(int.parse(b['room'][0]['room_number'])));
        } else {
          objects.sort((a, b) => int.parse(b['room'][0]['room_number'])
              .compareTo(int.parse(a['room'][0]['room_number'])));
        }
      }

      if (columnIndex == 1) {
        if (asc) {
          objects.sort((a, b) => ('${a['prefix']}${a['name']} ${a['lastname']}')
              .compareTo('${b['prefix']}${b['name']} ${b['lastname']}'));
        } else {
          objects.sort((a, b) => ('${b['prefix']}${b['name']} ${b['lastname']}')
              .compareTo('${a['prefix']}${a['name']} ${a['lastname']}'));
        }
      }

      if (columnIndex == 2) {
        if (asc) {
          objects.sort((a, b) => a['agency'].compareTo(b['agency']));
        } else {
          objects.sort((a, b) => b['agency'].compareTo(a['agency']));
        }
      }

      if (columnIndex == 3) {
        if (asc) {
          objects
              .sort((a, b) => a['relationship'].compareTo(b['relationship']));
        } else {
          objects
              .sort((a, b) => b['relationship'].compareTo(a['relationship']));
        }
      }

      if (columnIndex == 4) {
        if (asc) {
          objects.sort((a, b) => a['phone'].compareTo(b['phone']));
        } else {
          objects.sort((a, b) => b['phone'].compareTo(a['phone']));
        }
      }
    });
  }

  List<Map<String, dynamic>> filterObjects(
      List<Map<String, dynamic>> objects, String searchQuery) {
    final regex = RegExp(searchQuery, caseSensitive: false);

    return objects.where((object) {
      String prefix = object['prefix']?.toString() ?? '';
      String name = object['name']?.toString() ?? '';
      String lastname = object['lastname']?.toString() ?? '';
      String agency = object['agency']?.toString() ?? '';
      String phone = object['phone']?.toString() ?? '';
      String relationship = object['relationship']?.toString() ?? '';
      Map<String, dynamic> room = object['room']?[0] ?? [];
      String roomAddress = room['address']?.toString() ?? '';
      String roomNumber = room['room_number']?.toString() ?? '';
      String fullname = '$prefix$name $lastname';
      return regex.hasMatch(fullname) ||
          regex.hasMatch(agency) ||
          regex.hasMatch(phone) ||
          regex.hasMatch(relationship) ||
          regex.hasMatch(roomAddress) ||
          regex.hasMatch(roomNumber);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
    objects = widget.objects;
    isRefreshing = widget.isRefreshing;
    objects.sort((a, b) => int.parse(a['room'][0]['room_number'])
        .compareTo(int.parse(b['room'][0]['room_number'])));
  }

  @override
  void didUpdateWidget(ResidentTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter != oldWidget.filter) {
      setState(() {
        filter = widget.filter;
        objects = filterObjects(widget.objects, filter);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification && _dragExtent >= 200) {
            // Handle the long pull-down and release
            widget.setRefresh!(true);
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            // Perform the action on pull-down and release
            widget.setRefresh!(true);
          },
          child: Scrollbar(
            interactive: true,
            thumbVisibility: true,
            thickness: 7.0,
            controller: _vertical,
            child: Scrollbar(
              thumbVisibility: true,
              interactive: true,
              controller: _horizontal,
              thickness: 7.0,
              notificationPredicate: (notif) => notif.depth == 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontal,
                  // child: SizedBox(
                  //   width: MediaQuery.of(context)
                  //       .size
                  //       .width, // Set the width to full width
                  child: DataTable(
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columnSpacing: 30.0,
                    border: TableBorder.all(
                      width: 0.5,
                      color: ThemeData.dark().primaryColor,
                    ),
                    columns: [
                      DataColumn(
                          label: const Text('ห้อง',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          onSort: (columnIndex, ascending) {
                            _sortObjects(columnIndex, ascending);
                          }),
                      DataColumn(
                          label: const Text('ยศ-ชื่อ-นามสกุล',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          onSort: (columnIndex, ascending) {
                            _sortObjects(columnIndex, ascending);
                          }),
                      DataColumn(
                        label: const Text('หน่วยงาน',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) {
                          _sortObjects(columnIndex, ascending);
                        },
                      ),
                      DataColumn(
                          label: const Text('ความสำพันธ์',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          onSort: (columnIndex, ascending) {
                            _sortObjects(columnIndex, ascending);
                          }),
                      DataColumn(
                        label: const Text('เบอร์โทรศัพท์',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) =>
                            {_sortObjects(columnIndex, ascending)},
                      ),
                    ],
                    rows: objects.map((object) {
                      final idString = object['_id'].toString();
                      final idPattern = RegExp(r'\("(\w+)"\)');
                      final match = idPattern.firstMatch(idString);
                      final id = match?.group(1) ?? '';
                      final prefix = object['prefix']?.toString() ?? '';
                      final name = object['name']?.toString() ?? '';
                      final lastname = object['lastname']?.toString() ?? '';
                      final agency = object['agency']?.toString() ?? '';
                      final phone = object['phone']?.toString() ?? '';
                      final relationship =
                          object['relationship']?.toString() ?? '';
                      final room = object['room']?[0] ?? '';
                      final roomUnit = room['address'] ?? '';
                      final fullname = '$prefix$name $lastname';

                      return widget.isSelectMode
                          ? DataRow(
                              selected: widget.selectedRows
                                  .contains(id), // Check if the row is selected
                              onSelectChanged: (selected) {
                                // Toggle the selection state of the row
                                setState(() {
                                  if (selected!) {
                                    widget.selectedRows.add(
                                        id); // Add the row index to the list of selected rows
                                  } else {
                                    widget.selectedRows.remove(
                                        id); // Remove the row index from the list of selected rows
                                  }

                                  widget.onSelectedRowsChanged!(
                                      widget.selectedRows);
                                });
                              },
                              cells: [
                                DataCell(
                                  Text(roomUnit),
                                  // onTap: () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => ResidentList(
                                  //               roomUnit: roomUnit)));
                                  // }
                                ),
                                DataCell(
                                  Text(fullname),
                                  // onTap: () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => ResidentList(
                                  //               roomUnit: roomUnit)));
                                  // }
                                ),
                                DataCell(Text(agency)),
                                DataCell(Text(relationship)),
                                DataCell(Text(phone)),
                              ],
                            )
                          : DataRow(
                              cells: [
                                DataCell(
                                  Text(roomUnit),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute<void>(
                                      builder: (BuildContext context) {
                                        return Scaffold(
                                            appBar: AppBar(
                                              title:
                                                  Text("ข้อมูลห้อง $roomUnit"),
                                            ),
                                            body: EditRoom(
                                              roomUnit: roomUnit,
                                            ));
                                      },
                                    ));
                                  },
                                ),
                                DataCell(Text(fullname)),
                                DataCell(Text(agency)),
                                DataCell(Text(relationship)),
                                DataCell(Text(phone)),
                              ],
                            );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  void _handleDragStart(DragStartDetails details) {
    _dragExtent = 0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dy;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    _dragExtent = 0;
  }
}
