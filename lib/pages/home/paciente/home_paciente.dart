import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/models/users_shared.dart';
import 'package:tcc/pages/home/paciente/home_paciente_click.dart';
import 'package:tcc/pages/system/login.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/color_util.dart';
import 'package:tcc/utils/navigator.dart';
import 'package:toast/toast.dart';

import '../update_profile.dart';

class HomePaciente extends StatefulWidget {
  @override
  _HomePacienteState createState() => _HomePacienteState();
}

class _HomePacienteState extends State<HomePaciente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
          ),
          child: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Bem-vindo\nPaciente: ${snapshot.data.getString("name")}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => NavigatorUtil().buildPage(
                            context: context,
                            page: UpdateProfile(),
                          ),
                          color: ColorUtil.colorPrimary,
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 35,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            FirebaseAuth auth = FirebaseAuth.instance;

                            auth.signOut();
                            UsersShared().deleteAll();

                            Toast.show("Você saiu da conta com sucesso!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                            NavigatorUtil().buildAndRemove(context: context, page: Login());
                          },
                          color: ColorUtil.colorPrimary,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: FutureBuilder(
                      future: FirestoreService().getPaciente(
                        email: snapshot.data.getString("email"),
                      ),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshotPaciente) {
                        if(snapshotPaciente.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if(!snapshotPaciente.hasData) {
                          return Center(
                            child: Text(
                              "Você ainda não cadastrou nenhuma receita",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshotPaciente.data.docs.length,
                          itemBuilder: (context, index) {
                            return CupertinoButton(
                              onPressed: () async {
                                await NavigatorUtil().buildPage(context: context, page: HomePacienteClick(
                                  receita: "Receita ${index + 1}",
                                  medico: snapshotPaciente.data.docs[index].data()['medico'],
                                  receitaTexto: snapshotPaciente.data.docs[index].data()['receita'],
                                  farmaceutico: verificarFarmaceutico(snapshotPaciente.data.docs[index]),
                                ));

                                setState(() => null);
                              },
                              padding: EdgeInsets.zero,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 5, top: 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[200],
                                        offset: Offset(1, 0),
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        "Receita ${index + 1}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Divider(color: ColorUtil.colorPrimary),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Médico",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${snapshotPaciente.data.docs[index].data()['medico']}",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorUtil.colorPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Farmacêutico",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    verificarFarmaceutico(snapshotPaciente.data.docs[index]),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorUtil.colorPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String verificarFarmaceutico(QueryDocumentSnapshot doc) {
    print(doc.data()['baixa']);

    if(doc.data()['baixa']) {
      return "Confirmado";
    } else {
      return "Pendente";
    }
  }
}
