import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE score(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        score INTEGER, 
        timestamp TEXT,
        level_no INTEGER
        )""");
  }

  static Future<void> createLevelsTable(sql.Database database) async {
    await database.execute('''
    CREATE TABLE levels(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      no INTEGER,
      title TEXT,
      lock TEXT
    )
  ''');
  }

  static Future<void> updateScore(int score, int levelNo) async {
    final db = await SQLHelper.db();
    final data = {
      'score': score,
      'timestamp':
          DateTime.now().toIso8601String(), // Menggunakan timestamp terbaru
    };
    // Update skor berdasarkan level_no
    await db.update(
      'score',
      data,
      where: 'level_no = ?',
      whereArgs: [levelNo],
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('dbresult.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      print('...creating a table');
      await createTables(database);
      await createLevelsTable(database);
    });
  }

  static Future<int> resultScore(
      int score, String timestamp, int levelNo) async {
    final db = await SQLHelper.db();
    final data = {
      'score': score,
      'timestamp': timestamp,
      'level_no': levelNo, // Menyimpan level_no bersama dengan score
    };
    final id = await db.insert('score', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    // Membuka level berikutnya jika level ini selesai
    if (levelNo < 5) {
      // Jika level terakhir (5) belum tercapai
      SQLHelper.unlockNextLevel(levelNo + 1);
    }

    return id;
  }

  static Future<void> addLevelsTable() async {
    final db = await SQLHelper.db();
    await db.execute('''
    CREATE TABLE IF NOT EXISTS levels (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      no INTEGER,
      title TEXT,
      lock TEXT
    )
  ''');
  }

  static Future<void> unlockNextLevel(int nextLevel) async {
    // Fungsi untuk membuka level berikutnya
    // Logika bisa disesuaikan sesuai dengan kebutuhan
    final db = await SQLHelper.db();
    await db.update('levels', {'lock': 'false'},
        where: 'no = ?', whereArgs: [nextLevel]);
  }

  static Future<List<Map<String, dynamic>>> getScore() async {
    final db = await SQLHelper.db();
    return db.query('score', orderBy: "id");
  }

  static Future<void> updateLevelLock(int levelNo, String lockStatus) async {
    final db = await SQLHelper.db();
    await db.rawUpdate('''
    UPDATE levels
    SET lock = ?
    WHERE no = ?
  ''', [lockStatus, levelNo]);
  }

  static Future<void> checkLevelsData() async {
    final db = await SQLHelper.db();
    // Query untuk mengambil semua data dari tabel levels
    final List<Map<String, dynamic>> levels = await db.query('levels');

    // Menampilkan hasil query di console
    if (levels.isNotEmpty) {
      print('Data dari tabel levels:');
      levels.forEach((row) {
        print(row);
      });
    } else {
      print('Tidak ada data di tabel levels.');
    }
  }

  static Future<void> checkScoreData() async {
    final db = await SQLHelper.db();
    // Query untuk mengambil semua data dari tabel score
    final List<Map<String, dynamic>> scores = await db.query('score');

    // Menampilkan hasil query di console
    if (scores.isNotEmpty) {
      print('Data dari tabel score:');
      scores.forEach((row) {
        print(row);
      });
    } else {
      print('Tidak ada data di tabel score.');
    }
  }

  // static Future<int> resultScore(int score, String timestamp) async {
  //   final db = await SQLHelper.db();
  //   final data = {
  //     'score': score,
  //     'timestamp': timestamp,
  //   };
  //   final id = await db.insert('score', data,
  //       conflictAlgorithm: sql.ConflictAlgorithm.replace);
  //   return id;
  // }

  // dapetin satu data
  // static Future<List<Map<String, dynamic>>> getItem(int id) async {
  //   final db = await SQLHelper.db();
  //   return db.query('trx_lokasi', where: "id = ?", whereArgs: [id], limit: 1);
  // }

  //contoh update
  // static Future<int> updateItem(int id, String spkID, String koordinat,
  //     String trxTime, String namaDriver) async {
  //   final db = await SQLHelper.db();
  //   final data = {
  //     'spkID': spkID,
  //     'koordinat': koordinat,
  //     'trxTime': trxTime,
  //     'namaDriver': namaDriver
  // };
  //   final result =
  //       await db.update('trx_lokasi', data, where: "id = ?", whereArgs: [id]);
  //   return result;
  // }
  // contoh hapus data
  // static Future<void> deleteItem(int id) async {
  //   final db = await SQLHelper.db();
  //   try {
  //     await db.delete('score', where: "id = ?", whereArgs: [id]);
  //   } catch (err) {
  //     debugPrint("Terjadi Kesalahan saat menghapus data lokal: $err");
  //   }
  // }
}
