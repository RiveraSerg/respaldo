import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:proyecto_final/signup.dart';
import 'package:proyecto_final/principal.dart';
import 'package:proyecto_final/utils/db_usuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_final/utils/singletone.dart';
import 'package:proyecto_final/widgets/loader.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // All data
  Singleton singleton = Singleton();
  List<Map<String, dynamic>> myData = [];
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = true;
  // Función para refrescar las BD
  void _refreshData() async {
    final data = await UsuariosDatabaseHelper.getUsers();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    initShared();

    super.initState();
    _refreshData(); // Cargar la información a la app
  }

  Future<void> initShared() async {
    sharedPreferences = await  SharedPreferences.getInstance();
    ///Función para verificar si tiene la sesión activa
    tieneLaSesionAbierta();
  }


  // Eliminar un usuario
  void deleteItem(int id) async {
    await UsuariosDatabaseHelper.deleteUser(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted!'),
        backgroundColor:Colors.green
    ));
    _refreshData();
  }

  /// Verificar credenciales
  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final usuarios = await UsuariosDatabaseHelper.getUsers();
    final usuarioEncontrado = usuarios.firstWhere(
          (usuario) => usuario['correo'] == email && usuario['contrasena'] == password,
      orElse: () => {},
    );

    if (usuarioEncontrado.isNotEmpty) {
      // Guardar sesión iniciada y credenciales en cache
      sharedPreferences.setBool('islogin', true);
      sharedPreferences.setString('user', emailController.text);
      sharedPreferences.setString('pass', passwordController.text);

      // Navegar a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    } else {
      showSnackBar('Correo o contraseña incorrectos', 3);
    }
  }



  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    Widget loadingIndicator = singleton.loader ?
    const Loader() : Container();

    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6DA6BF),
                  Color(0xFF2C3E50),
                ],
              ),
            ),
          ),

          SingleChildScrollView(

            child: Padding(
                padding: const EdgeInsets.all(20.0),

                child: Container(

                    height: 750,
                    width: size.width, ///100%

                    padding: const EdgeInsets.all(20.0),


                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0x7DDFF7FF)
                    ),


                    child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                                'Nombre App',
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4A5568),
                                )
                            ),
                          ),

                          const SizedBox(height: 100.0),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF4A5568)
                                )
                            ),
                          ),

                          const SizedBox(height: 10.0),


                          TextFormField(
                            controller: emailController,

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),

                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),

                                ),

                                filled: true,
                                fillColor: const Color(0xFFCBD5E0),

                                prefixIcon: const Icon(Icons.email_rounded),
                                hintText: 'correo electronico'


                            ),


                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            controller: passwordController,

                            obscureText: true,

                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),

                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),

                                ),

                                filled: true,
                                fillColor: const Color(0xFFCBD5E0),

                                prefixIcon: const Icon(Icons.lock),
                                hintText: 'contraseña'


                            ),


                          ),


                          const SizedBox(height: 35.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(

                              backgroundColor: const Color(0xBF508DA0),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              fixedSize: const Size(180,45),
                            ),
                            onPressed: _login,
                            child: const Row(

                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,

                              children: [
                                Text(
                                  'Ingresar',
                                  style: TextStyle(
                                    color: Color(0xFFD9F6FF),
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 25.0),
                          const Divider(
                            color: Color(0xFF2C3E50),
                            thickness: 2,
                            height: 20,
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Color(0xFF4A5568),
                                      fontSize: 16.0,
                                    ),
                                    children: [
                                      const TextSpan(text: '¿No tienes una cuenta? '),
                                      TextSpan(
                                        text: 'Regístrate.',
                                        style: const TextStyle(
                                          color: Color(0xFF32788E),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            registrar(context);
                                          },
                                      ),
                                    ],
                                  )
                              )
                          ),


                        ]
                    )


                ),
              ),

          ),

          Align(alignment: FractionalOffset.center, child: loadingIndicator)

        ],
      ),
    );
  }

  void showSnackBar(String texto, int duracion){
    final snack = SnackBar(
      content: Text(texto),
      duration: Duration(seconds: duracion),
      action: SnackBarAction(
        onPressed: () {
          //Cualquier acción al dar clic sobre el widget
        },
        label: 'Cerrar',
      ),
    );

    ///Muestra el mensaje en pantalla
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }


  void tieneLaSesionAbierta() {
    final isLogin = sharedPreferences.getBool('islogin') ?? false;

    if (isLogin) {
      print('Sesión abierta');
      singleton.user = sharedPreferences.getString('user') ?? '';
      singleton.pass = sharedPreferences.getString('pass') ?? '';

      // Navegar directamente a la pantalla principal si ya está logueado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    } else {
      print('No hay sesión activa');
    }
  }

}


void registrar(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Signup()),
  );
}
