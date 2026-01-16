import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/expense_tracker/data/models/category_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ledger_lens.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories(
        id TEXT PRIMARY KEY,
        name TEXT,
        icon_code INTEGER,
        color_value INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        amount REAL,
        merchant TEXT,
        date TEXT,
        category_id TEXT,
        receipt_path TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    await _seedCategories(db);
  }

  Future<void> _seedCategories(Database db) async {
    final List<CategoryModel> defaultCategories = [
      const CategoryModel(
        id: '1',
        name: 'Food',
        iconCode: 0xe532,
        colorValue: 0xFF4CAF50,
      ), // restaurant, green
      const CategoryModel(
        id: '2',
        name: 'Transport',
        iconCode: 0xe55c,
        colorValue: 0xFF2196F3,
      ), // directions_car, blue
      const CategoryModel(
        id: '3',
        name: 'Shopping',
        iconCode: 0xe8cc,
        colorValue: 0xFFFF9800,
      ), // shopping_cart, orange
      const CategoryModel(
        id: '4',
        name: 'Utilities',
        iconCode: 0xeb3c,
        colorValue: 0xFF9C27B0,
      ), // home_work, purple
      const CategoryModel(
        id: '5',
        name: 'Entertainment',
        iconCode: 0xea66,
        colorValue: 0xFFE91E63,
      ), // movie, pink
      const CategoryModel(
        id: '6',
        name: 'Others',
        iconCode: 0xe80b,
        colorValue: 0xFF2196F3,
      ), // favorite, blue
    ];

    final batch = db.batch();
    for (var cat in defaultCategories) {
      batch.insert('categories', cat.toJson());
    }
    await batch.commit();
  }
}
