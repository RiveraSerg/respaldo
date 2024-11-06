import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sql;
import 'package:flutter/material.dart';
import 'package:proyecto_final/utils/constantes.dart';
import 'package:proyecto_final/widgets/drawer.dart';
import 'package:proyecto_final/utils/singletone.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  Singleton singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: colorPrincipal,
        title: const Text(
          "Pantalla Principal", style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      drawer: appDrawer(size: size),

    );
  }
}
