import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/models/users_shared.dart';
import 'package:tcc/pages/home/farmaceutico/home_farmaceutico_consulta.dart';
import 'package:tcc/pages/home/paciente/home_paciente_click.dart';
import 'package:tcc/pages/system/login.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/color_util.dart';
import 'package:tcc/utils/navigator.dart';
import 'package:toast/toast.dart';

import '../update_profile.dart';

class HomeFarmaceutico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorUtil.colorPrimary,
        onPressed: () => NavigatorUtil()
            .buildPage(context: context, page: HomeFarmaceuticoConsulta()),
        child: Icon(Icons.add, color: Colors.white),
      ),
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
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                          "Bem-vindo\nFarmacêutico: ${snapshot.data.getString("name")}",
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

                            Toast.show(
                                "Você saiu da conta com sucesso!", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);

                            NavigatorUtil().buildAndRemove(
                                context: context, page: Login());
                          },
                          color: ColorUtil.colorPrimary,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
