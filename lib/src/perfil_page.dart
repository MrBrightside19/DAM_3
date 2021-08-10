import 'dart:developer';
import 'dart:io';

// import 'package:RollerMapp/src/pages/user/login_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_3_dam/services/storage_service.dart';
import 'package:tarea_3_dam/services/user_service.dart';
import 'package:tarea_3_dam/src/login_page.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({Key key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String email = '';
  String uid = '';
  String nombre = '';
  String apellido = '';
  FocusNode myFocusNode;
  bool _editProfile = false;
  bool value;

  TextEditingController nombresCtrl = TextEditingController();
  TextEditingController universidadCtrl = TextEditingController();
  TextEditingController carreraCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  File _image;

  @override
  void initState() {
    cargarDatosUsuario().then((value) => descargarImagen());
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil')),
      body: StreamBuilder(
          stream: _fetch(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var usuario = snapshot.data;
              nombresCtrl.text = usuario['nombre'] + ' ' + usuario['apellido'];
              universidadCtrl.text = usuario['universidad'];
              carreraCtrl.text = usuario['carrera'];
              dateCtrl.text = DateFormat('dd-MM-yyyy').format(
                  DateTime.fromMicrosecondsSinceEpoch(
                      usuario['fecha_nacimiento'].microsecondsSinceEpoch));

              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/fondos/fondo_perfil.jpg'),
                    fit: BoxFit.cover,
                  ),
                  // border: Border.all(width: 2.0, color: Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      color: Colors.black,
                      width: double.maxFinite,
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.none,
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: usuario['imagen'] == ''
                                        ? AssetImage(
                                            'assets/profile/profile.png')
                                        : NetworkImage(usuario['imagen']),
                                    fit: BoxFit.cover),
                                border:
                                    Border.all(width: 2.0, color: Colors.black),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Container(
                                child: FloatingActionButton(
                                  onPressed: () {
                                    getImage().then((value) async {
                                      var ref = StorageService()
                                          .putUserImage(_image, uid);
                                      await ref.whenComplete(() async {
                                        await downloadURL();
                                      });
                                    });
                                  },
                                  backgroundColor:
                                      Colors.black.withOpacity(0.8),
                                  child: Icon(MdiIcons.camera),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: nombresCtrl,
                            focusNode: myFocusNode,
                            decoration: InputDecoration(
                                fillColor: Theme.of(context).primaryColor,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none),
                            textAlign: TextAlign.center,
                            readOnly: _editProfile ? false : true,
                            style: TextStyle(
                                fontSize: 25, color: Colors.amberAccent),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 4,
                      color: Colors.deepPurple,
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Theme.of(context).primaryColor.withOpacity(0.96),
                      ),
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: universidadCtrl,
                        readOnly: _editProfile ? false : true,
                        decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.95),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 1.5,
                          )),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 1.5,
                          )),
                          labelText: 'Universidad',
                          labelStyle: TextStyle(
                              backgroundColor:
                                  Colors.deepPurpleAccent.withOpacity(0.8),
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Theme.of(context).primaryColor.withOpacity(0.96),
                      ),
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: carreraCtrl,
                        readOnly: _editProfile ? false : true,
                        decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.95),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.5, color: Colors.purple)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                            ),
                          ),
                          labelText: 'Carrera',
                          labelStyle: TextStyle(
                              backgroundColor:
                                  Colors.deepPurpleAccent.withOpacity(0.8),
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Theme.of(context).primaryColor.withOpacity(0.96),
                      ),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: dateCtrl,
                        readOnly: _editProfile ? false : true,
                        decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.95),
                          labelText: 'Fecha de Nacimiento',
                          labelStyle: TextStyle(
                              backgroundColor:
                                  Colors.deepPurpleAccent.withOpacity(0.8),
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Stream<DocumentSnapshot> _fetch() {
    return UserService().getUser(uid);
  }

  //Funciones
  Future cargarDatosUsuario() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getStringList('user')[0];
      email = sp.getStringList('user')[1];
    });
  }

  Future<void> descargarImagen() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    var downloadToFile = File('${appDocDir.path}/profile.jpg');

    try {
      await StorageService().writeImage(downloadToFile, uid);
      setState(() {
        _image = downloadToFile;
      });
    } catch (e) {
      print('error $e');
      // e.g, e.code == 'canceled'
    }
  }

  Future downloadURL() async {
    try {
      var storage = await StorageService().getUserUrl(uid);
      await UserService().updateFoto(storage, uid);
    } catch (ex) {
      print('error: $ex');
    }
  }
}
