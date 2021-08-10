import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class RamosService {
  Future addRamo({
    String ramo,
    Map notas,
    // List notas,
    List notasCalc,
    String uid,
    bool tipo,
    // List<dynamic> notas,
  }) async {
    var notaID = Uuid().v4();

    await FirebaseFirestore.instance.collection('ramos').doc(notaID).set({
      'uid': uid,
      'ramo': ramo,
      'notas_calculadas': notasCalc,
      'notas': notas,
      'ingreso': Timestamp.now(),
      'tipo': tipo
    });
  }

  Future deleteRamo({var uid}) async {
    await FirebaseFirestore.instance.collection('ramos').doc(uid).delete();
  }

  Stream<QuerySnapshot> getRamo(String uid) {
    return FirebaseFirestore.instance
        .collection('ramos')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }
}
