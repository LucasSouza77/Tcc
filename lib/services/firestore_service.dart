import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tcc/models/usuario.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> salvarUsuario(Usuario usuario) async {
    return await _db.collection('usuarios').doc(usuario.email).set(usuario.toMap());
  }

  Future<DocumentSnapshot> getTypeUser({@required email}) async {
    return _db.collection("usuarios").doc(email).get();
  }

  Future<QuerySnapshot> getMedico({@required email}) async {
    return _db.collection("medicos").doc(email).collection("receitas").get();
  }

  Future<QuerySnapshot> getPaciente({@required email}) async {
    return _db.collection("usuarios").doc(email).collection("receitas").get();
  }

  Future<QuerySnapshot> getFarmaceutico({@required email}) async {
    return _db.collection("farmaceutico").where("emailPaciente", isEqualTo: email).get();
  }

  Future<void> salvarReceitas({
    @required email,
    @required nome,
    @required nameMedico,
    @required emailMedico,
    @required receita,
  }) async {
    await _db.collection("medicos").doc(emailMedico).collection("receitas").doc().set({
      'receita' : receita,
      'paciente' : nome,
      'emailPaciente' : email,
      'baixa' : false,
    });

    await _db.collection("farmaceutico").doc().set({
      'receita' : receita,
      'paciente' : nome,
      'emailPaciente' : email,
      'medico' : nameMedico,
      'emailMedico' : emailMedico,
      'baixa' : false,
    });

    return await _db.collection("usuarios").doc(email).collection("receitas").doc().set({
      'receita' : receita,
      'medico' : nameMedico,
      'emailMedico' : emailMedico,
      'baixa' : false,
    });
  }

  Future<void> darBaixaReceitas({
    @required email,
    @required emailMedico,
    @required idDoc,
    @required idDocMedico,
    @required idDocFarmaceutico,
  }) async {

    await _db.collection("medicos").doc(emailMedico).collection("receitas").doc(idDocMedico).update({
      'baixa' : true,
    });

    await _db.collection("farmaceutico").doc(idDocFarmaceutico).update({
      'baixa' : true,
    });

    return await _db.collection("usuarios").doc(email).collection("receitas").doc(idDoc).update({
      'baixa' : true,
    });
  }
  
  Future<void> updateProfile({
    @required email,
    @required nome,
    @required endereco,
    @required celular,
    @required dataDeNascimento,
    @required cpf,
  }) async {
    return await _db.collection("usuarios").doc(email).update({
      'nome': nome,
      'endereco': endereco,
      'celular': celular,
      'dataDeNascimento': dataDeNascimento,
      'cpf': cpf,
    });
  }
}
