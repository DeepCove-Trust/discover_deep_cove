import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/permissions.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:path/path.dart';

export 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart'
    show SqfliteAdapter;

/// Singleton class (lazy instantiation) for database provision.
class DB {
  /// Private constructor
  DB._();

  /// Private singleton instance.
  static DB _instance;

  /// Return the single instance if it exists, otherwise create it.
  static DB get instance => _instance ??= DB._();

  /// Single database adaptor instance belonging to the single provider.
  static SqfliteAdapter _adapter;

  /// Return _db if not null, else initialize the database.
  Future<SqfliteAdapter> get adapter async => _adapter ??= await _initDb();

  /// Removes the [_adapter] so that the database will be re-initialized
  /// the next time [adapter] is retrieved.
  ///
  /// Should not be called outside of the [SyncProvider] class.
  void resetAdapter() {
    _adapter = null;
  }

  /// Throws [InsufficientPermissionException] is user does not grant storage
  /// permission.
  Future<SqfliteAdapter> _initDb() async {
    print('Connecting to database...');

    // Request external storage permission if the app is configured to use
    // external storage.
    if (Env.debugStorageMode) {
      // Throw exception if the user doesn't grant storage permission
      // TODO: Improve this exception and catch on the calling function
      if (!await Permissions.ensurePermission(PermissionGroup.storage)) {
        print('Storage permissions not granted. Aborting...');
        throw Exception('Permission not granted: ${PermissionGroup.storage}');
      }
    }

    // Establish the path to the database file
    String dbPath = join(await Env.dbPath);
    // Could use getDatabasesPath() instead of env value

    // Create the database adaptor, connect to db, and return adaptor for use
    // when creating database beans.
    SqfliteAdapter adapter = SqfliteAdapter(dbPath);
    await adapter.connect(); // TODO: Try-catch? Don't know what it throws...

    print('Database connection initialized...');

    return adapter;
  }
}
