import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// SQLiteデータベースの管理を行うヘルパークラス
class DatabaseHelper {
  static const String _databaseName = 'todo_database.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'todos';

  // Singleton pattern
  static Database? _database;
  
  /// データベースインスタンスを取得
  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// データベースを初期化
  static Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/$_databaseName';
    
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// テーブルを作成
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // インデックスを作成（検索性能向上のため）
    await db.execute('CREATE INDEX idx_title ON $_tableName (title)');
    await db.execute('CREATE INDEX idx_completed ON $_tableName (is_completed)');
    await db.execute('CREATE INDEX idx_created_at ON $_tableName (created_at)');
  }

  /// データベースのアップグレード処理
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // 将来的なマイグレーション処理をここに記述
    if (oldVersion < 2) {
      // バージョン2へのマイグレーション例
      // await db.execute('ALTER TABLE $_tableName ADD COLUMN new_column TEXT');
    }
  }

  /// データベースを閉じる
  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// データベースを削除（テスト用）
  static Future<void> deleteDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/$_databaseName';
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// テーブル名を取得
  static String get tableName => _tableName;
}