import 'dart:developer';

import 'package:kiakkai_db/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(mongoUrl);
    await db.open();
    return db;
  }

  static stringId2ObjectId(String id) {
    final idString = id.toString();
    final idPattern = RegExp(r'\("(\w+)"\)');
    final match = idPattern.firstMatch(idString);
    return match?.group(1) ?? '';
  }

  static Future<List<Map<String, dynamic>>> getRooms() async {
    var db = await connect();
    var rooms = await db.collection(collectionRoom).find().toList();
    return rooms;
  }

  static Future<Map<String, dynamic>> getRoom(String id) async {
    var db = await connect();
    var room = await db.collection(collectionRoom).findOne(where.eq('_id', id));
    return room;
  }

  static Future<List<Map<String, dynamic>>> getResidents() async {
    var db = await connect();
    var residents = await db.collection(collectionResident).find().toList();
    return residents;
  }

  static Future<Map<String, dynamic>> getResident(String id) async {
    var db = await connect();
    var resident =
        await db.collection(collectionResident).findOne(where.eq('_id', id));
    return resident;
  }

  static Future<List<Map<String, dynamic>>> getVehicles() async {
    var db = await connect();
    var vehicles = await db.collection(collectionVehicle).find().toList();
    return vehicles;
  }

  static Future<Map<String, dynamic>> getVehicle(String id) async {
    var db = await connect();
    var vehicle =
        await db.collection(collectionVehicle).findOne(where.eq('_id', id));
    return vehicle;
  }

  static Future<Map<String, dynamic>> getElectricMeter(String id) {
    var db = connect();
    var electricMeter =
        db.collection(collectionElectricMeter).findOne(where.eq('_id', id));
    return electricMeter;
  }

  static Future<List<Map<String, dynamic>>> getResidentsWithRoom() async {
    var db = await connect();
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: collectionRoom,
            localField: 'room_ref',
            foreignField: '_id',
            as: 'room'))
        .build();

    var residents = await db
        .collection(collectionResident)
        .aggregateToStream(pipeline)
        .toList();
    return residents;
  }

  static Future<List<Map<String, dynamic>>>
      getVehicleWithRoomAndResident() async {
    var db = await connect();
    // look up room from resident lookup
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: collectionResident,
            localField: 'resident_ref',
            foreignField: '_id',
            as: 'resident'))
        .addStage(Lookup(
            from: collectionRoom,
            localField: 'resident.room_ref',
            foreignField: '_id',
            as: 'room'))
        .build();

    var vehicles = await db
        .collection(collectionVehicle)
        .aggregateToStream(pipeline)
        .toList();
    return vehicles;
  }

  static Future<WriteResult> addResident(
      {required Map<String, String> data}) async {
    var db = await connect();
    var address = data['address'];
    var roomRef = await db
        .collection(collectionRoom)
        .findOne(where.eq('address', address));
    var input = {
      'prefix': data['prefix'],
      'name': data['name'],
      'lastname': data['lastname'],
      'room_ref': roomRef!['_id'],
      'phone': data['phone'],
      'citizen_id': data['cid'],
      'agency': data['agency'],
      'relationship': data['relationship'],
      'is_owner': data['relationship'] == 'เจ้าบ้าน' ? true : false,
      'created_at': DateTime.now().toString(),
      'created_by': 'admin',
      'updated_at': null,
      'updated_by': null,
      'removed_at': null,
      'removed_by': null,
      'joined_at': null,
      'left_at': null,
    };

    return await db.collection(collectionResident).insertOne(input);
  }

  static Future<WriteResult> deleteResidents(
      {required List<String> ids}) async {
    var db = await connect();
    print(ids);
    // convert string to ObjectId
    var idsObj = ids.map((e) => ObjectId.parse(e)).toList();
    return await db
        .collection(collectionResident)
        .deleteMany(where.oneFrom('_id', idsObj));
  }

  static Future<List<Map<String, dynamic>>> getResidentAndVehicleAndEmeterByRoomUnit(
      String roomUnit) async {
    var db = await connect();
    var room = await db
        .collection(collectionRoom)
        .findOne(where.eq('address', roomUnit));

    // add the pipeline to get vehicle from a list of vihecle ref in each resident
    final pipeline = AggregationPipelineBuilder()
        .addStage(Match(where.eq('room_ref', room['_id']).map['\$query']))
        .addStage(Lookup(
            from: collectionVehicle,
            localField: 'vehicle_ref',
            foreignField: '_id',
            as: 'vehicle'))
        .addStage(Lookup(
            from: collectionElectricMeter,
            localField: 'e_meter_ref',
            foreignField: '_id',
            as: 'e_meter'))
        .build();

    var resident = await db
        .collection(collectionResident)
        .aggregateToStream(pipeline)
        .toList();

    return resident;
  }


}
