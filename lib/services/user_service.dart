import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Stream<DocumentSnapshot> getUser(String uid) {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots();
    } catch (e) {
      print('error $e');
    }
    return null;
  }

  Future addUser({
    String nombre,
    String apellido,
    Timestamp fechaNacimiento,
    String universidad,
    String carrera,
    String uid,
    String imagen,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'nombre': nombre,
      'apellido': apellido,
      'universidad': universidad,
      'carrera': carrera,
      'fecha_nacimiento': fechaNacimiento,
      'imagen': imagen
    });
  }

  Future updateFoto(String imagen, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'imagen': imagen,
    });
  }
}
