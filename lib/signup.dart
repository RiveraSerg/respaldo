import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:proyecto_final/login.dart';
import 'package:proyecto_final/utils/db_usuarios.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // All data
  List<Map<String, dynamic>> myData = [];

  bool _isLoading = true;
  // Función para refrescar las BD
  void _refreshData() async {
    final data = await UsuariosDatabaseHelper.getUsers();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Cargar la información a la app
  }

  final TextEditingController name = TextEditingController();
  final TextEditingController last_name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password_confirm = TextEditingController();



    // Insertar un nuevo usuario
  Future<void> addItem() async {
    await UsuariosDatabaseHelper.createUser(
        name.text, last_name.text, email.text, password.text, []);
    _refreshData();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return Scaffold(
      body: Stack(
        children: [

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6DA6BF), // Color claro
                  Color(0xFF2C3E50), // Color oscuro
                ],
              ),
            ),
          ),

          SingleChildScrollView(

            child: Padding(
              padding: const EdgeInsets.all(20.0),

              child: Container(

                  height: 745, 
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

                        const SizedBox(height: 60.0),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4A5568)
                              )
                          ),
                        ),

                        const SizedBox(height: 10.0),


                        TextFormField(
                          controller: name,

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

                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Nombre(s)'


                          ),


                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: last_name,


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

                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Apellido(s)'


                          ),


                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: email,


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
                          controller: password,

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
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: password_confirm,

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
                              hintText: 'confirmar contraseña'


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
                          onPressed: () async {
                            if(name.text.isNotEmpty &&
                                last_name.text.isNotEmpty &&
                                email.text.isNotEmpty &&
                                password.text.isNotEmpty &&
                                password_confirm.text.isNotEmpty){

                              if(password.text == password_confirm.text){

                                await addItem();

                                // Limpiar los campos después de registrar
                                name.clear();
                                last_name.clear();
                                email.clear();
                                password.clear();
                                password_confirm.clear();

                              }
                              else {
                                showSnackBar('Contraseña incorrecta', 10);
                              }

                            }
                            else{
                              showSnackBar('Algun campo esta vacio', 10);
                            }

                          },
                          child: const Row(

                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Text(
                                'Registrar',
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
                                    const TextSpan(text: '¿tienes una cuenta? '),
                                    TextSpan(
                                      text: 'Inicia sesion.',
                                      style: const TextStyle(
                                        color: Color(0xFF32788E),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          iniciar(context);
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

          )
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
}

void iniciar(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Login()),
  );
}