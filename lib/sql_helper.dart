import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Membuat tabel 'score' dengan penambahan 'quiz_type' untuk membedakan jenis kuis
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE score(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        score INTEGER, 
        timestamp TEXT,
        level_no INTEGER,
        quiz_type TEXT
      )
    """);
  }

  // Membuat tabel 'levels'
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

  // Membuka atau membuat database, dan membuat tabel jika belum ada
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbresult.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        print('Creating tables...');
        await createTables(database);
        await createLevelsTable(database);
      },
    );
  }

  // Memasukkan atau memperbarui skor dengan tambahan 'quiz_type'
  static Future<int> resultScore(
      int score, String timestamp, int levelNo, String quizType) async {
    final db = await SQLHelper.db();
    final data = {
      'score': score,
      'timestamp': timestamp,
      'level_no': levelNo,
      'quiz_type': quizType, // Menyimpan jenis kuis
    };

    final id = await db.insert(
      'score',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    // Membuka level berikutnya jika level ini selesai
    if (levelNo < 5) {
      await unlockNextLevel(levelNo + 1);
    }

    return id;
  }

  // Mengupdate skor berdasarkan level_no
  static Future<void> updateScore(int score, int levelNo) async {
    final db = await SQLHelper.db();
    final data = {
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await db.update(
      'score',
      data,
      where: 'level_no = ?',
      whereArgs: [levelNo],
    );
  }

  // Membuka level berikutnya dengan mengubah status 'lock' menjadi false
  static Future<void> unlockNextLevel(int nextLevel) async {
    final db = await SQLHelper.db();
    await db.update(
      'levels',
      {'lock': 'false'},
      where: 'no = ?',
      whereArgs: [nextLevel],
    );
  }

  // Mengambil skor dari database berdasarkan jenis kuis (quiz_type)
  static Future<List<Map<String, dynamic>>> getScore(String quizType) async {
    final db = await SQLHelper.db();
    return db.query(
      'score',
      where: 'quiz_type = ?',
      whereArgs: [quizType],
      orderBy: "id",
    );
  }

  // Mengupdate status 'lock' pada level tertentu
  static Future<void> updateLevelLock(int levelNo, String lockStatus) async {
    final db = await SQLHelper.db();
    await db.update(
      'levels',
      {'lock': lockStatus},
      where: 'no = ?',
      whereArgs: [levelNo],
    );
  }

  // Mengecek data di tabel 'levels'
  static Future<void> checkLevelsData() async {
    final db = await SQLHelper.db();
    final levels = await db.query('levels');

    if (levels.isNotEmpty) {
      print('Data dari tabel levels:');
      levels.forEach((row) => print(row));
    } else {
      print('Tidak ada data di tabel levels.');
    }
  }

  // Mengecek data di tabel 'score'
  static Future<void> checkScoreData() async {
    final db = await SQLHelper.db();
    final scores = await db.query('score');

    if (scores.isNotEmpty) {
      print('Data dari tabel score:');
      scores.forEach((row) => print(row));
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
