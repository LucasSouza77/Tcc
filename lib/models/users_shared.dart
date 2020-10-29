import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersShared {
  Future<bool> saveUser({
    @required name,
    email,
    @required dataNascimento,
    @required CPF,
    categoria,
    @required celular,
    @required endereco,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("name", name);
    if (email != null) prefs.setString("email", email);
    prefs.setString("dataNascimento", dataNascimento);
    prefs.setString("CPF", CPF);
    if (categoria != null) prefs.setString("categoria", categoria);
    prefs.setString("celular", celular);
    prefs.setString("endereco", endereco);

    return true;
  }

  Future<String> getUser({@required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(type);
  }

  Future<bool> deleteAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();

    return true;
  }
}
