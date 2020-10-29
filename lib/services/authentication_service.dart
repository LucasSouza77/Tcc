import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticartionService {
  FirebaseAuth auth = FirebaseAuth.instance;

  static Future<String> login({@required email, @required password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "Sucesso";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Email não encontrado.';
      } else if (e.code == 'wrong-password') {
        return 'Senha incorreta.';
      }
    }
  }

  static Future<String> register({@required email, @required password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "Sucesso";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Senha mínima é de 6 caractéres.';
      } else if (e.code == 'email-already-in-use') {
        return 'Esse email já existe.';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
