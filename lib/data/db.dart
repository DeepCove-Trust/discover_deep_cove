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

  /// Database adaptor for the temporary database
  static SqfliteAdapter _tempAdapter;

  /// Return _adapter if not null, else initialize the database.
  Future<SqfliteAdapter> get adapter async => _adapter ??= await _initDb(false);

  /// Return _tempAdapter if not null, else initialize
  Future<SqfliteAdapter> get tempAdapter async =>
      _tempAdapter ??= await _initDb(true);

  /// Removes the [_adapter] so that the database will be re-initialized
  /// the next time [adapter] is retrieved.
  ///
  /// Should not be called outside of the [SyncProvider] class.
  Future<void> resetAdapter() async {
    await _adapter.close();
    _adapter = null;
  }

  /// Closes connection to the temp database, delete the temp database file
  /// and set the _tempAdapter member back to null.
  Future<void> resetTempAdapter() async {
    await _tempAdapter.close();
    _tempAdapter = null;
  }

  /// Throws [InsufficientPermissionException] is user does not grant storage
  /// permission.
  Future<SqfliteAdapter> _initDb(bool temp) async {
   if (Env.debugMessages) print('Connecting to ${temp ? 'temporary' : ''} database...');

    // Request external storage permission if the app is configured to use
    // external storage.
    if (Env.debugStorageMode) {
      // Throw exception if the user doesn't grant storage permission
      // TODO: Improve this exception and catch on the calling function
      if (!await Permissions.ensurePermission(PermissionGroup.storage)) {
        if (Env.debugMessages) print('Storage permissions not granted. Aborting...');
        throw Exception('Permission not granted: ${PermissionGroup.storage}');
      }
    }

    // Establish the path to the database file
    String dbPath = join(temp ? Env.tempDbPath : Env.dbPath);
    // Could use getDatabasesPath() instead of env value

    // Create the database adaptor, connect to db, and return adaptor for use
    // when creating database beans.
    SqfliteAdapter adapter = SqfliteAdapter(dbPath);
    await adapter.connect(); // TODO: Try-catch? Don't know what it throws...

    if (Env.debugMessages) print('Database connection initialized...');

    return adapter;
  }
}
