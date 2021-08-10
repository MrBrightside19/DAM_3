import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_3_dam/services/ramos_service.dart';

class RamosPage extends StatefulWidget {
  RamosPage({Key key}) : super(key: key);

  @override
  _RamosPageState createState() => _RamosPageState();
}

class _RamosPageState extends State<RamosPage> {
  @override
  void initState() {
    cargarDatosUsuario();
    super.initState();
  }

  var text;

  String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ramos'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/fondos/matematicas.jpg'),
          ),
        ),
        child: StreamBuilder(
          stream: _fetch(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var ramos = snapshot.data.docs[index];
                  List<String> notas = [];
                  var j = 0;
                  var validate = true;
                  for (var i = 0; i < ramos['notas'].length; i++) {
                    if (ramos['notas'][i.toString()][0].isEmpty) {
                      if (double.parse(ramos['notas_calculadas'][j]) < 0) {
                        validate = false;
                      } else {
                        notas.add(ramos['notas_calculadas'][j].toString());
                        j++;
                      }
                    }
                  }
                  if (validate) {
                    text = 'Las notas que necesita son: ${notas.join(' - ')}';
                  } else {
                    text = 'Ramo ya aprobado';
                  }

                  return Container(
                    margin: EdgeInsets.all(5),
                    color: Colors.blue.withOpacity(0.98),
                    child: Slidable(
                      actions: [
                        IconSlideAction(
                          onTap: () {
                            AwesomeDialog(
                              btnOkText: 'Aceptar',
                              btnCancelText: 'Cancelar',
                              context: context,
                              dialogType: DialogType.WARNING,
                              animType: AnimType.SCALE,
                              title: 'Atencion❗❗',
                              desc: 'Está seguro de eliminar estas notas?',
                              btnOkOnPress: () {
                                RamosService().deleteRamo(uid: ramos.id);
                              },
                              btnCancelOnPress: () {},
                            ).show();
                          },
                          caption: 'Borrar',
                          color: Colors.red,
                          icon: MdiIcons.trashCan,
                        )
                      ],
                      actionPane: SlidableDrawerActionPane(),
                      child: ListTile(
                        title: Text(ramos['ramo']),
                        subtitle: Text(text),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future cargarDatosUsuario() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getStringList('user')[0];
    });
  }

  Stream<QuerySnapshot> _fetch() {
    var service = RamosService().getRamo(uid);
    return service;
  }
}
