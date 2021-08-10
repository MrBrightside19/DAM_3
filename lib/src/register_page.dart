import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarea_3_dam/services/auth_services.dart';
import 'package:tarea_3_dam/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String errorText = '';
  final _formKey = GlobalKey<FormState>();
  final _emailRegex =
      r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+";

  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  TextEditingController dateCtrl = new TextEditingController();
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController apellidoCtrl = new TextEditingController();
  TextEditingController universidadCtrl = new TextEditingController();
  TextEditingController carreraCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Registro de Usuario'),),
      body: SingleChildScrollView(
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    margin: EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Registro de Usuario',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su nombre';
                        }
                        return null;
                      },
                      controller: nombreCtrl,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Nombre',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su apellido';
                        }
                        return null;
                      },
                      controller: apellidoCtrl,
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(color: Colors.red[400], fontSize: 16),
                        labelText: 'Apellido',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su fecha de nacimiento';
                        }
                        return null;
                      },
                      controller: dateCtrl,
                      decoration: InputDecoration(
                        labelText: 'Fecha de nacimiento',
                        fillColor: Colors.white,
                      ),
                      onTap: () async {
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        dateCtrl.text = date != ''
                            ? DateFormat('dd-MM-yyyy').format(date).toString()
                            : '';
                        // _swType ? 'Con Ponderación' : 'Sin Ponderación'
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su universidad';
                        }
                        return null;
                      },
                      controller: universidadCtrl,
                      decoration: InputDecoration(
                        labelText: 'Universidad',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su carrera';
                        }
                        return null;
                      },
                      controller: carreraCtrl,
                      decoration: InputDecoration(
                        labelText: 'Carrera',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su email';
                        }
                        if (!RegExp(_emailRegex).hasMatch(value)) {
                          return 'Email no válido';
                        }
                        return null;
                      },
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Colors.white,
                        hintText: 'user1@gmail.com',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ingrese su contraseña';
                        }
                        return null;
                      },
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        fillColor: Colors.white,
                      ),
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
                      child: Text(
                        'Registrarse',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.orange),
                      onPressed: () {
                        var fecha = DateTime.parse(DateFormat('yyyy-MM-dd')
                            .format(DateFormat('dd-MM-yyyy')
                                .parse(dateCtrl.text.trim())));
                        AuthService authService = AuthService();
                        if (_formKey.currentState.validate()) {
                          authService
                              .crearCuenta(emailCtrl.text.trim(),
                                  passwordCtrl.text.trim())
                              .then((value) {
                            UserService().addUser(
                              nombre: nombreCtrl.text.trim(),
                              apellido: apellidoCtrl.text.trim(),
                              fechaNacimiento: Timestamp.fromDate(fecha),
                              universidad: universidadCtrl.text.trim(),
                              carrera: carreraCtrl.text.trim(),
                              uid: value.uid.toString(),
                              imagen: '',
                            );
                            Navigator.pop(context);
                          }).catchError((ex) {
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
                        Text(
                          '¿Ya tiene una cuenta?',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
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
