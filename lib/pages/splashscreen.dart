import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/pages/home/farmaceutico/home_farmaceutico.dart';
import 'package:tcc/pages/system/login.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/navigator.dart';

import 'home/medico/home_medico.dart';
import 'home/paciente/home_paciente.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    verifyUser();
  }

  verifyUser() {
    FirebaseAuth auth = FirebaseAuth.instance;

    Future.delayed(Duration(milliseconds: 1500), () async {
      if(auth.currentUser != null) {
        await FirestoreService().getTypeUser(
          email: auth.currentUser.email,
        ).then((value) {
          if(value.data().containsKey("categoria")) {
            switch(value.data()['categoria']) {
              case "Paciente": NavigatorUtil().buildAndRemove(context: context, page: HomePaciente()); break;
              case "Médico": NavigatorUtil().buildAndRemove(context: context, page: HomeMedico()); break;
              case "Farmacêutico": NavigatorUtil().buildAndRemove(context: context, page: HomeFarmaceutico()); break;
            }
          }
        });
      } else {
        NavigatorUtil().buildAndRemove(context: context, page: Login());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: 256,
          height: 256,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
