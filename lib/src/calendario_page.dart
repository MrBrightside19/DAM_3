import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tarea_3_dam/services/calendario_service.dart';

class CalendarioPage extends StatefulWidget {
  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  Map<String, dynamic> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();
  TextEditingController _eventEditController = TextEditingController();
  String uid;
  @override
  void initState() {
    selectedEvents = {};
    cargarDatosUsuario().whenComplete(() => _loadEvents());

    super.initState();
  }

  _loadEvents() {
    CalendarioService().getEvents(uid).then((value) {
      try {
        var stringMap = Map<String, dynamic>.from(value['eventos']);
        setState(() {
          selectedEvents = stringMap;
        });
      } catch (ex) {
        print('sin datos $ex');
      }
    });
    // selectedEvents = events;
  }

  List _getEventsfromDay(DateTime date) {
    return selectedEvents[date.toString()] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Próximos eventos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/fondos/matematicas.jpg'),
            ),
          ),
          child: Column(
            children: [
              Card(
                color: Colors.amber[100],
                child: TableCalendar(
                  locale: 'es',
                  focusedDay: selectedDay,
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(DateTime.now().year + 1),
                  calendarFormat: format,
                  onFormatChanged: (CalendarFormat _format) {
                    setState(() {
                      format = _format;
                    });
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  // daysOfWeekVisible: false,
                  //Day Changed
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      focusedDay = focusDay;
                    });
                    print(focusedDay);
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },

                  eventLoader: _getEventsfromDay,

                  //To style the Calendar
                  calendarStyle: CalendarStyle(
                    disabledTextStyle: TextStyle(color: Colors.grey[600]),
                    weekendTextStyle: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    defaultTextStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    todayDecoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    weekendDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              ..._getEventsfromDay(selectedDay).map(
                (event) {
                  var dif = selectedDay.difference(DateTime.now()).inHours + 24;
                  var text = dif >= 24 ? 'Faltan $dif horas' : 'Es Hoy!!';
                  return Column(
                    children: [
                      Dismissible(
                        onDismissed: (direction) {
                          AwesomeDialog(
                            btnOkText: 'Aceptar',
                            btnCancelText: 'Cancelar',
                            context: context,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.SCALE,
                            title: 'Atencion❗❗',
                            desc: 'Está seguro de eliminar este evento?',
                            btnOkOnPress: () {
                              selectedEvents.forEach((key, value) {
                                for (var i = 0; i < value.length; i++) {
                                  if (value[i] == event) {
                                    value.removeAt(i);
                                  }
                                }
                              });

                              CalendarioService()
                                  .deleteEvent(event: selectedEvents, uid: uid);
                              setState(() {});
                            },
                            btnCancelOnPress: () {},
                          ).show();
                        },
                        key: ObjectKey(selectedDay),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 120.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  MdiIcons.trashCan,
                                  size: 50,
                                ),
                                Text(
                                  'Borrar',
                                  style: TextStyle(fontSize: 25),
                                )
                              ],
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0),
                          child: Container(
                            color: Colors.grey[300],
                            child: ListTile(
                              title: Text(
                                '$event',
                              ),
                              subtitle: Text(text),
                              trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Modificar Evento"),
                                        content: TextFormField(
                                          controller: _eventEditController,
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("Cancelar"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: Text("Aceptar"),
                                            onPressed: () {
                                              if (_eventEditController
                                                  .text.isEmpty) {
                                              } else {
                                                selectedEvents
                                                    .forEach((key, value) {
                                                  for (var i = 0;
                                                      i < value.length;
                                                      i++) {
                                                    if (value[i] == event) {
                                                      value[i] =
                                                          _eventEditController
                                                              .text;
                                                    }
                                                  }
                                                });
                                              }
                                              CalendarioService()
                                                  .editEvent(
                                                      event: selectedEvents,
                                                      uid: uid)
                                                  .whenComplete(() {
                                                _eventEditController.clear();
                                                Navigator.pop(context);
                                              });
                                              setState(() {});
                                              return;
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit)),
                            ),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            // _create(context),
            showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Agregar Evento"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: Text("Cancelar"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Aceptar"),
                onPressed: () {
                  if (_eventController.text.isEmpty) {
                  } else {
                    if (selectedEvents[selectedDay.toString()] != null) {
                      selectedEvents[selectedDay.toString()]
                          .add(_eventController.text);
                    } else {
                      selectedEvents[selectedDay.toString()] = [
                        _eventController.text
                      ];
                    }
                  }
                  Navigator.pop(context);
                  _eventController.clear();
                  _addEvent();
                  setState(() {});
                  return;
                },
              ),
            ],
          ),
        ),
        label: Text("Agregar Evento"),
        icon: Icon(Icons.add),
      ),
    );
  }

  _addEvent() {
    var event = CalendarioService();
    event.addEvent(event: selectedEvents, uid: uid);
  }

  Future cargarDatosUsuario() async {
    var sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getStringList('user')[0];
    });
  }
}
