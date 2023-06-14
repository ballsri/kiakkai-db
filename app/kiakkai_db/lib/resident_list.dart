import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'mongodb.dart';

Color? getTileColor(String agency) {
  switch (agency) {
    case "สนง.รอป.":
      return Colors.yellow[50];
    case "พันราชสำนักฯ" || "ทม.รอ.":
      return Colors.purple[50];
    default:
      return Colors.grey[25];
  }
}

class ResidentList extends StatelessWidget {
  const ResidentList({super.key});
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
          return Material(
              child: ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) {
              final item = data?[index];
              final room = item?['room'][0];

              // Customize the UI according to your needs
              return Column(children: [
                ListTile(
                  title: Column(children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right:
                                  12.0), // Adjust the padding value as needed
                          child: Text('${room['address']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right:
                                  12.0), // Adjust the padding value as needed
                          child: Text(
                              '${item?['prefix']}${item?['name']} ${item?['lastname']}'),
                        ),
                      ],
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
                            child: Text('${item?['agency']}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    12.0), // Adjust the padding value as needed
                            child: Text('${item?['phone']}'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text('ความสำพันธ์: ${item?['relationship']}'),
                      ),
                    ],
                  ),
                  mouseCursor: MouseCursor.defer,
                  tileColor: getTileColor(item?['agency']),
                  textColor: item?['relationship'] == 'เจ้าบ้าน'
                      ? Colors.red[500]
                      : Colors.black,
                  titleTextStyle: item?['relationship'] == 'เจ้าบ้าน'
                      ? const TextStyle(fontWeight: FontWeight.bold)
                      : const TextStyle(fontWeight: FontWeight.normal),
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
