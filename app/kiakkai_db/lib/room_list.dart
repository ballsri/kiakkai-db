import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'mongodb.dart';

class RoomList extends StatelessWidget {
  const RoomList({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: MongoDatabase.getRooms(),
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
              // Customize the UI according to your needs
              return Column(children: [
                ListTile(
                  title: Text('${item?['address']}'),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    12.0), // Adjust the padding value as needed
                            child: Text('เลขห้อง: ${item?['room_number']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    12.0), // Adjust the padding value as needed
                            child: Text('ตึก: ${item?['building_address']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    12.0), // Adjust the padding value as needed
                            child: Text('ชั้น: ${item?['floor']}'),
                          ),
                        ],
                      )
                    ],
                  ),
                  mouseCursor: MouseCursor.defer,
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
                  thickness:
                      1.0, // Adjust the thickness of the border as needed
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
