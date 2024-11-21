import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;
import 'package:flutter/material.dart';

class UsuariosDatabaseHelper {
  // Crear tabla de usuarios
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombres TEXT,
        apellidos TEXT,
        correo TEXT,
        contrasena TEXT,
        idEventos TEXT  -- Almacenaremos la lista de IDs como un JSON string
      )
      """);
  }

  // Inicializar base de datos
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'usuarios.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Crear un nuevo usuario
  static Future<int> createUser(String nombres, String apellidos,
      String correo, String contrasena, List<int> idEventos) async {
  final db = await UsuariosDatabaseHelper.db();

  // Convertimos idEventos a JSON para almacenarlo como texto
  final data = {
  'nombres': nombres,
  'apellidos': apellidos,
  'correo': correo,
  'contrasena': contrasena,
  'idEventos': idEventos.toString()
  };

  final id = await db.insert('usuarios', data,
  conflictAlgorithm: sql.ConflictAlgorithm.replace);
  return id;
  }

  // Leer todos los usuarios
  static Future<List<Map<String, dynamic>>> getUsers() async {
  final db = await UsuariosDatabaseHelper.db();
  return db.query('usuarios', orderBy: "id");
  }

  // Leer un solo usuario por ID
  static Future<List<Map<String, dynamic>>> getUser(int id) async {
  final db = await UsuariosDatabaseHelper.db();
  return db.query('usuarios', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Actualizar un usuario por ID
  static Future<int> updateUser(int id, String nombres, String apellidos,
      String correo, String contrasena, List<int> idEventos) async {
  final db = await UsuariosDatabaseHelper.db();

  final data = {
  'nombres': nombres,
  'apellidos': apellidos,
  'correo': correo,
  'contraseña': contrasena,
  'idEventos': idEventos.toString()
  };

  final result = await db.update('usuarios',
      data, where: "id = ?", whereArgs: [id]);
  return result;
  }

  // Eliminar un usuario por ID
  static Future<void> deleteUser(int id) async {
  final db = await UsuariosDatabaseHelper.db();
  try {
  await db.delete("usuarios", where: "id = ?", whereArgs: [id]);
  } catch (err) {
  debugPrint("Error al eliminar el usuario: $err");
  }
  }

}
