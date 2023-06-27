import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

/// # EntityService
///
/// The entity service
///
/// @author TintLwinOo
class EntityService {
  late Database _database;

  /// Empty constructor
  EntityService();

  /// ## initialize
  ///
  /// Initialize the database
  Future<void> initialize() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'itemdb.db');
    _database = await openDatabase(path, version: 1, onCreate: _onDbCreate); //
  }

  /// ## _onDbCreate
  ///
  /// Create table on database newly created.
  ///
  /// [Parameters]:
  ///   - db [Database]
  ///   - version [Version]
  Future<void> _onDbCreate(Database db, int version) async {
    // create all tables from the models
    await db.execute(
        'CREATE TABLE IF NOT EXISTS item (id INTEGER PRIMARY KEY, title VARCHAR(50), description TEXT, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)');
  }

  get database => _database;
}
