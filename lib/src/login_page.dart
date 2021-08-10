import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tarea_3_dam/services/auth_services.dart';
import 'package:tarea_3_dam/src/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final labelStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  final textStyle = TextStyle(color: Colors.white);
  final _emailRegex =
      r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+";

  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();

  String errorText = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/fondos/matematicas.jpg'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 375,
                        margin: EdgeInsets.only(top: 200),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.purple[900],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Inicio de Sesión',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Indique su email';
                                }
                                if (!RegExp(_emailRegex).hasMatch(value)) {
                                  return 'Email no válido';
                                }
                                // else{
                                //   return errorText;
                                // }
                                return null;
                              },
                              controller: emailCtrl,
                              style: textStyle,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                icon: Icon(Icons.person, color: Colors.orange),
                                labelText: 'Email',
                                labelStyle: labelStyle,
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Indique su contraseña';
                                }
                                // else{
                                //   return errorText;
                                // }
                                return null;
                              },
                              controller: passwordCtrl,
                              style: textStyle,
                              obscureText: true,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.orange,
                                ),
                                labelText: 'Contraseña',
                                labelStyle: labelStyle,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                errorText,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                child: Text('Iniciar Sesión', style: TextStyle(color: Colors.black, fontSize: 18),),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.orange),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    AuthService authService = new AuthService();
                                    authService
                                        .iniciarSesion(emailCtrl.text.trim(),
                                            passwordCtrl.text.trim())
                                        .catchError((ex) {
                                      setState(() {
                                        errorText = ex.toString();
                                      });
                                    });
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Text('¿Desea registrarse?', style: TextStyle(color: Colors.white),),
                                  TextButton(
                                    onPressed: () {
                                      MaterialPageRoute route =
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage());
                                      Navigator.push(context, route);
                                    },
                                    child: Text('Registrarse', style: TextStyle(color: Colors.blue),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 155,
                        right: 160,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.orange),
                                color: Colors.orange),
                            child: Icon(
                              Icons.person,
                              size: 70,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
