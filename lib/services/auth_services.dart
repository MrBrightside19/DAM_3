import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get usuario {
    return _firebaseAuth.authStateChanges();
  }

  //LOGIN
  Future iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setStringList('user',
          [userCredential.user.uid, userCredential.user.email.toString()]);
      return userCredential.user;
    } catch (ex) {
      switch (ex.code) {
        case 'wrong-password':
          return Future.error('Credenciales incorrectas');
        case 'invalid-email':
          return Future.error('Credenciales incorrectas');
      }
      return Future.error(ex.code);
    }
  }

  Future cerrarSesion() async {
    return await _firebaseAuth.signOut();
  }

  Future crearCuenta(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setStringList('user',
          [userCredential.user.uid, userCredential.user.email.toString()]);
      return userCredential.user;
    } catch (ex) {
      switch (ex.code) {
        case 'weak-password':
          return Future.error('La contraseña debe tener mínimo 6 caracteres');
        case 'email-already-in-use':
          return Future.error('Ya existe una cuenta con ese email');
        default:
          return Future.error(ex.code);
      }
    }
  }
}
