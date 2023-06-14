import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'mongodb.dart';

class VehicleList extends StatelessWidget {
  const VehicleList({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: MongoDatabase.getVehicleWithRoomAndResident(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleLoading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data;
          return Material(
              child: ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) {
              final item = data?[index];
              var room = "-";
              if (item?['room'].length > 0) {
                room = item?['room'][0]['address'];
              }
              var resident = item?['driver'];
              if (item?['resident'].length > 0) {
                resident =
                    '${item?['resident'][0]['prefix']}${item?['resident'][0]['name']} ${item?['resident'][0]['lastname']}';
              }

              var phone = item?['phone'];
              if (item?['resident'].length > 0) {
                phone = item?['resident'][0]['phone'];
              }

              final String vehicleType =
                  item?['vehicle_type'] == 'car' ? 'รถยนต์' : 'รถจักรยานยนต์';

              // Customize the UI according to your needs
              return Column(children: [
                ListTile(
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right:
                                      12.0), // Adjust the padding value as needed
                              child: Text("ห้อง : $room"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right:
                                      12.0), // Adjust the padding value as needed
                              child:
                                  Text('รหัสเครื่องบลูทูธ: ${item?['bt_id']}'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right:
                                  12.0), // Adjust the padding value as needed
                          child: Text("ประเภทรถ : $vehicleType",
                              style: TextStyle(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold)),
                        ),
                      ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    12.0), // Adjust the padding value as needed
                            child: Text('${item?['plate']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    12.0), // Adjust the padding value as needed
                            child: Text('ยี่ห้อ ${item?['brand']}'),
                          ),
                        ],
                      ),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right:
                                  12.0), // Adjust the padding value as needed
                          child: Text('สี${item?['color']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right:
                                  12.0), // Adjust the padding value as needed
                          child: Text('${item?['district']}'),
                        )
                      ]),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    12.0), // Adjust the padding value as needed
                            child: Text("เจ้าของรถ : $resident"),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 12.0), // Adjust the padding value as needed
                        child: Text("เบอร์โทรศัพท์ : $phone"),
                      ),
                    ],
                  ),
                  mouseCursor: MouseCursor.defer,
                  tileColor: item?['vehicle_type'] == 'car'
                      ? Colors.blue[50]
                      : Colors.green[50],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text('Next page'),
                          ),
                          body: const Center(
                            child: Text(
                              'This is the next page',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      },
                    ));
                  },
                ),
                const Divider(
                  thickness: 1, // Adjust the thickness of the border as needed
                  color:
                      Colors.grey, // Adjust the color of the border as needed
                ),
              ]);
            },
          ));
        }
      },
    );
  }
}

class CircleLoading extends StatelessWidget {
  const CircleLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
