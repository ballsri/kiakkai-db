import 'package:flutter/material.dart';
import 'package:kiakkai_db/form/rooms/widget/edit_field.dart';
import 'package:kiakkai_db/mongodb.dart';
import 'package:collection/collection.dart';

class EditRoom extends StatefulWidget {
  final String roomUnit;
  const EditRoom({super.key, required this.roomUnit});
  @override
  EditRoomState createState() => EditRoomState();
}

class EditRoomState extends State<EditRoom> {
  late String roomUnit;
  List<Map<String, dynamic>> residents = [];
  List<Map<String, dynamic>> vehicles = [];

  bool isLoading = true; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    roomUnit = widget.roomUnit;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Perform your MongoDB queries here
      List<Future<List<Map<String, dynamic>>>> queries = [
        MongoDatabase.getResidentAndVehicleAndEmeterByRoomUnit(roomUnit),
        // Add more queries as needed
      ];

      // Wait for all queries to complete
      List<List<Map<String, dynamic>>> results = await Future.wait(queries);

      // Assign the fetched data to respective variables
      residents = results[0];
      print(residents[0]["e_meter"]);
      residents.forEach((element) {
        if (element['vehicle'] != null && element['vehicle'].isNotEmpty) {
          element['vehicle'].forEach((data) {
            vehicles.add(data);
          });
        }
      });

      setState(() {
        isLoading = false; // Data fetching is complete
      });
    } catch (error) {
      // Handle any errors that occur during data fetching
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(), // Display a loading indicator
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(
                        'เจ้าของห้อง',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                      child: EditFieldWidget(
                        inputText: residents
                            .map((e) => e['is_owner'] == true
                                ? "${e['prefix']}${e['name']} ${e['lastname']}"
                                : '')
                            .join(''),
                        callback: (string) => print(string),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(
                        'ผู้พักอาศัย',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        children: residents.mapIndexed((index, element) {
                          return element['is_owner'] == false
                              ? EditFieldWidget(
                                  inputText:
                                      "${index}.) ${element['prefix']}${element['name']} ${element['lastname']}",
                                  callback: (string) => print(string),
                                )
                              : Container();
                        }).toList(),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(
                        'รถยนตร์',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: vehicles.isEmpty
                            ? [
                                const Text(
                                  'ไม่มีรถยนตร์',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]
                            : vehicles.mapIndexed((index, element) {
                                return element['vehicle_type'] == "car"
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: EditFieldWidget(
                                          inputText:
                                              "${index + 1}.) รถยนตร์ ${element['brand']} ${element['color']} \n\t\t\t${element['plate']} ${element['district']} \n\t\t\tเลขบลูทูธ ${element['bt_id']}",
                                          callback: (string) => print(string),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: EditFieldWidget(
                                          inputText:
                                              "${index + 1}.) รถจักรยานยนตร์ ${element['brand']} ${element['color']} \n\t\t\t${element['plate']} ${element['district']} \n\t\t\tเลขบลูทูธ ${element['bt_id']}",
                                          callback: (string) => print(string),
                                        ),
                                      );
                              }).toList(),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(
                        'เลขที่มาตรไฟฟ้า',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: EditFieldWidget(
                          inputText: residents
                              .map((e) => e['is_owner'] == true
                                  ? "${e['e_meter'][0]['meter_id']}"
                                  : '')
                              .join(''),
                          callback: (string) => print(string),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0, right: 10.0),
                      child: Text(
                        'เลขที่สัญญา',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: EditFieldWidget(
                        inputText: residents
                            .map((e) => e['is_owner'] == true
                                ? "${e['e_meter'][0]['contract_id']}"
                                : '')
                            .join(''),
                        callback: (string) => print(string),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
