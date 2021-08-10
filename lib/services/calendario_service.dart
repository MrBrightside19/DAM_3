import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarioService {
  Future<DocumentSnapshot<Map<String, dynamic>>> getEvents(uid) {
    return FirebaseFirestore.instance.collection('events').doc(uid).get();
  }

  Future addEvent({var event, String uid}) async {
    await FirebaseFirestore.instance.collection('events').doc(uid).set({
      'eventos': event,
    });
  }

  Future deleteEvent({var event, String uid}) async {
    await FirebaseFirestore.instance.collection('events').doc(uid).set({
      'eventos': event,
    });
  }

  Future editEvent({var event, String uid}) async {
    await FirebaseFirestore.instance.collection('events').doc(uid).set({
      'eventos': event,
    });
  }
}
