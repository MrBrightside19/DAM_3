import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_3_dam/services/auth_services.dart';
import 'package:tarea_3_dam/services/ramos_service.dart';
import 'package:tarea_3_dam/services/user_service.dart';
import 'package:tarea_3_dam/src/calendario_page.dart';
import 'package:tarea_3_dam/src/perfil_page.dart';
import 'package:tarea_3_dam/src/ramos_page.dart';
import 'package:tarea_3_dam/widgets/calculadora.dart';
import 'package:tarea_3_dam/widgets/notas_field.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    cargarDatosUsuario();
    iniciarTextField();
    super.initState();
  }

  iniciarTextField() {
    listNotas.add(TextNotasField());
    listPond.add(TextPondField());
    _rowList = [
      DataRow(
        cells: <DataCell>[
          DataCell(
            Container(
              child: listNotas[0],
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          DataCell(
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: listPond[0],
            ),
          ),
        ],
      )
    ];
    _rowListNotas = [
      DataRow(cells: <DataCell>[
        DataCell(
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: listNotas[0],
          ),
        ),
      ])
    ];
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController notaMinimaCtrl = TextEditingController();
  TextEditingController classCtrl = TextEditingController();
  List<TextNotasField> listNotas = [];
  List<TextPondField> listPond = [];
  var registroNotas = [];
  List<DataRow> _rowList;
  List<DataRow> _rowListNotas;
  bool _swType = true;
  var _labelSwType = 'Con Ponderación';
  String uid;
  var _estiloTexto = TextStyle(fontSize: 20);
  var mapa = <dynamic, dynamic>{};

  Icon floatingIcon = new Icon(Icons.add);
  removeField() {
    if (_rowList.length == 1 && _rowListNotas.length == 1) {
      return;
    }
    if (_rowList.length <= 10 || _rowListNotas.length <= 10) {
      setState(() {
        if (_swType) {
          listNotas.removeLast();
          listPond.removeLast();
          _rowList.removeLast();
        } else {
          listNotas.removeLast();
          _rowListNotas.removeLast();
        }
      });
    }
  }

  addField() {
    if (_rowList.length == 10 || _rowListNotas.length == 10) {
      return;
    }
    if (_rowList.length >= 1 || _rowListNotas.length >= 1) {
      setState(() {
        listNotas.add(new TextNotasField());
        listPond.add(new TextPondField());
        _swType
            ? _rowList.add(DataRow(cells: <DataCell>[
                DataCell(
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: listNotas[listNotas.length - 1],
                  ),
                ),
                DataCell(
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: listPond[listNotas.length - 1],
                  ),
                ),
              ]))
            : _rowListNotas.add(DataRow(cells: <DataCell>[
                DataCell(
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: listNotas[listNotas.length - 1],
                  ),
                ),
              ]));
      });
    }
  }

  submitnotas() {
    var length = _swType ? _rowList.length : _rowListNotas.length;
    registroNotas = [];
    for (var i = 0; i < length; i++) {
      registroNotas
          .add([listNotas[i].controller.text, listPond[i].controller.text]);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de notas'),
      ),
      drawer: _drawer(),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                _notaMinima(),
                _classAndSave(),
                _estadoPond(),
                _swType ? _notasPond() : _notas(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buttonsAddRemove(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _notaMinima() {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Theme.of(context).primaryColor.withOpacity(0.999),
      ),
      padding: EdgeInsets.all(15),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Debe ingresar la nota minima para pasar el ramo';
          }
          return null;
        },
        maxLength: 3,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          errorStyle: TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintText: 'Promedio con que pasa su ramo:',
          hintStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        controller: notaMinimaCtrl,
      ),
    );
  }

  _buttonsAddRemove() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'add',
          onPressed: () {
            addField();
          },
          child: Icon(
            MdiIcons.plus,
            size: 30,
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: FloatingActionButton(
            heroTag: 'remove',
            onPressed: () {
              removeField();
            },
            child: Icon(
              MdiIcons.minus,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  _notasPond() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: DataTable(
          dividerThickness: 0,
          dataRowHeight: 80,
          columns: [
            DataColumn(
                numeric: mounted,
                label: Text(
                  'Notas',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                )),
            DataColumn(
                label: Text(
              'Ponderaciones',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ))
          ],
          rows: _rowList),
    );
  }

  _notas() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        width: double.infinity,
        margin: EdgeInsets.all(15),
        child: DataTable(
            columnSpacing: 30,
            dataRowHeight: 80,
            dividerThickness: 0,
            columns: [
              DataColumn(
                  label: Text(
                'Notas',
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
            ],
            rows: _rowListNotas),
      ),
    );
  }

  _classAndSave() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Theme.of(context).primaryColor.withOpacity(0.999),
          ),
          height: MediaQuery.of(context).size.height * 0.112,
          margin: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.65,
          padding: EdgeInsets.all(15),
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Debe ingresar el nombre del ramo';
              }
              return null;
            },
            maxLength: 50,
            controller: classCtrl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              // errorStyle: TextStyle(fontSize: 10),

              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              hintText: 'Nombre ramo:',
              hintStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            color: Theme.of(context).primaryColor.withOpacity(0.96),
          ),
          height: MediaQuery.of(context).size.height * 0.112,
          // margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              IconButton(
                iconSize: 50,
                onPressed: () {
                  submitnotas();
                  if (_formKey.currentState.validate()) {
                    int min = int.parse(notaMinimaCtrl.text.trim());
                    var nota = 0;
                    var pond = 0;
                    var cantNotas =
                        _swType ? _rowList.length : _rowListNotas.length;

                    for (var i = 0; i < registroNotas.length; i++) {
                      if (registroNotas[i][0] == "") {
                        nota += 1;
                      }
                      if (registroNotas[i][1] == "") {
                        pond += 1;
                      }
                    }
                    var notasIngresadas = registroNotas;
                    var calc = Calculadora(
                            registroNotas, min, cantNotas, _swType, nota, pond)
                        .calculo();
                    var key = 0;
                    setState(() {
                      registroNotas.forEach((notas) {
                        mapa.putIfAbsent(key.toString(), () => notas);
                        key++;
                      });
                    });

                    RamosService().addRamo(
                      notas: mapa,
                      notasCalc: calc,
                      ramo: classCtrl.text.trim(),
                      uid: uid,
                      tipo: _swType,
                    );
                  }
                },
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ),
              Text(
                'Guardar',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        )
      ],
    );
  }

  _estadoPond() {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(35)),
        color: Theme.of(context).primaryColor.withOpacity(0.96),
      ),
      child: SwitchListTile(
        title: Text(
          _labelSwType,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        secondary: Icon(
          MdiIcons.calculator,
          size: 35,
          color: Colors.white,
        ),
        onChanged: (bool value) {
          setState(() {
            _swType = value;
            _labelSwType = _swType ? 'Con Ponderación' : 'Sin Ponderación';
            registroNotas = [];
            listNotas = [];
            listPond = [];
            mapa = {};
          });
          iniciarTextField();
        },
        value: _swType,
      ),
    );
  }

  Future cargarDatosUsuario() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getStringList('user')[0];
    });
  }

  _drawer() {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.28,
              width: double.infinity,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: StreamBuilder(
                    stream: _fetch(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.20,
                              width: 130,
                              child: CircularProgressIndicator()),
                        );
                      } else {
                        var usuario = snapshot.data;
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => _navegar(context, 0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: 130,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: usuario['imagen'] == ''
                                            ? AssetImage(
                                                'assets/profile/profile.png')
                                            : NetworkImage(
                                                usuario['imagen'],
                                              ) as ImageProvider,
                                        fit: BoxFit.cover),
                                    border: Border.all(
                                        width: 2.0, color: Colors.black)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(
                                usuario['nombre'] + ' ' + usuario['apellido'] ??
                                    '',
                                style: TextStyle(
                                    fontSize: 23, color: Colors.amberAccent),
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              child: ListTile(
                trailing: Icon(MdiIcons.arrowRightBoldCircle),
                onTap: () => _navegar(context, 1),
                title: Text(
                  'Ramos',
                  style: _estiloTexto,
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              child: ListTile(
                trailing: Icon(MdiIcons.arrowRightBoldCircle),
                onTap: () => _navegar(context, 2),
                title: Text(
                  'Calendario',
                  style: _estiloTexto,
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Spacer(),
            ListTile(
              trailing: Icon(MdiIcons.arrowRightBoldCircle),
              onTap: () {
                AuthService authService = new AuthService();
                authService.cerrarSesion();
              },
              title: Text(
                'Cerrar Sesión',
                style: _estiloTexto,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navegar(BuildContext context, int pagina) {
    // ignore: missing_return
    final route = CupertinoPageRoute(builder: (context) {
      switch (pagina) {
        case 0:
          return PerfilPage();
        case 1:
          return RamosPage();
        case 2:
          return CalendarioPage();
      }
    });

    Navigator.push(context, route);
  }

  Stream<DocumentSnapshot> _fetch() {
    return UserService().getUser(uid);
  }
}
