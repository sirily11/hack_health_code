import 'package:flutter/material.dart';
import 'package:health_qr_code_generator/model/HealthCode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:path/path.dart' as p;
import 'package:sembast/sembast_io.dart';

class DatabaseProvider with ChangeNotifier {
  String dbPath = "health.db";
  String dbName = "healthCode";
  DatabaseFactory databaseFactory = databaseFactoryIo;
  Database db;

  /// Get database instance
  Future<Database> _openDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var path = p.join(dir.path, dbPath);
    Database db = await databaseFactory.openDatabase(path);
    return db;
  }

  DatabaseProvider() {
    _openDatabase().then((db) {
      this.db = db;
      notifyListeners();
    });
  }

  /// get list of records
  Stream<List<RecordSnapshot<int, Map<String, dynamic>>>> get stream {
    var store = intMapStoreFactory.store();
    var stream = store
        .query(
          finder: Finder(sortOrders: [
            SortOrder(
              'lastReportTime',
            )
          ]),
        )
        .onSnapshots(db);
    return stream;
  }

  /// Add new record
  Future<void> add(HealthCode healthCode) async {
    var store = intMapStoreFactory.store();
    await store.add(db, healthCode.toJson());
  }

  /// Delete a record by id
  Future<void> delete(int key) async {
    var store = intMapStoreFactory.store();
    var filter = Filter.byKey(key);
    var finder = Finder(filter: filter);
    await store.delete(db, finder: finder);
  }
}
