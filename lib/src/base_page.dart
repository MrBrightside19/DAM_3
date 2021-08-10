import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_3_dam/src/home_page.dart';
import 'package:tarea_3_dam/src/login_page.dart';

class BasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<User>(context);
    return usuario == null ? LoginPage() : HomePage();
  }
}
