import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tcc/models/users_shared.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/color_util.dart';
import 'package:toast/toast.dart';

class HomeFarmaceuticoConsulta extends StatefulWidget {
  @override
  _HomeFarmaceuticoConsultaState createState() => _HomeFarmaceuticoConsultaState();
}

class _HomeFarmaceuticoConsultaState extends State<HomeFarmaceuticoConsulta> {
  bool isLoading = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";

  QRViewController controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorUtil.colorPrimary,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Consultar receita",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: qrText.isEmpty ? QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ) : FutureBuilder(
        future: FirestoreService().getTypeUser(
          email: qrText.replaceAll("http://", ""),
        ),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return FutureBuilder(
            future: FirestoreService().getPaciente(
              email: snapshot.data.data()['email'],
            ),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshotReceita) {
              if(snapshotReceita.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.all(10),
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_pin_circle, color: Colors.black87),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Nome do paciente\n${snapshot.data.data()['nome']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: ColorUtil.colorPrimary),
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.black87),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                calcularIdade(snapshot.data.data()['dataDeNascimento']),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: ColorUtil.colorPrimary),
                        Row(
                          children: [
                            Icon(Icons.add_location, color: Colors.black87),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Endereço\n${snapshot.data.data()['endereco']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: ColorUtil.colorPrimary),
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.black87),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "Email\n${snapshot.data.data()['email']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: ColorUtil.colorPrimary),
                        Text(
                          "Receita médica: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshotReceita.data.docs.length,
                          itemBuilder: (context, indexReceitas) {
                            return FutureBuilder(
                              future: FirestoreService().getMedico(
                                email: snapshotReceita.data.docs[indexReceitas].data()['emailMedico'],
                              ),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshotMedico) {
                                if(snapshotMedico.connectionState == ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if(snapshotReceita.data.docs[indexReceitas].data()['baixa'] == true) {
                                  return SizedBox();
                                }

                                return FutureBuilder(
                                  future: FirestoreService().getFarmaceutico(
                                    email: snapshot.data.data()['email'],
                                  ),
                                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshotFarmaceutico) {
                                    if(snapshotFarmaceutico.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 5, top: 5),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[350],
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Receita ${indexReceitas + 1}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                snapshotReceita.data.docs[indexReceitas].data()['receita'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  stops: [0.3, 1],
                                                  colors: [ColorUtil.colorPrimary, ColorUtil.colorPrimary.withOpacity(0.8)],
                                                ),
                                              ),
                                              child: CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  submitDarBaixaReceita(
                                                    emailPaciente: snapshot.data.data()['email'],
                                                    emailMedico: snapshotReceita.data.docs[indexReceitas].data()['emailMedico'],
                                                    idDocPaciente: snapshotReceita.data.docs[indexReceitas].id,
                                                    idDocMedico: snapshotMedico.data.docs[indexReceitas].id,
                                                    idDocFarmaceutico: snapshotFarmaceutico.data.docs[indexReceitas].id,
                                                  );
                                                },
                                                child: isLoading ? SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: CircularProgressIndicator(),
                                                ) : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 25),
                                                        Text(
                                                          "Dar baixa na receita",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/pills.png",
                                                          width: 25,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        SizedBox(width: 25),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String calcularIdade(value) {
    return "Idade\n" + getAge(value.split("/")[2], value.split("/")[1], value.split("/")[0]);
  }

  getAge(String year, String month, String day)
  {
    final birthday = DateTime(int.parse(year), int.parse(month), int.parse(day));

    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthday.year;
    int month1 = currentDate.month;
    int month2 = birthday.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthday.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age.toString();
  }

  void submitDarBaixaReceita({
    @required emailPaciente,
    @required emailMedico,
    @required idDocPaciente,
    @required idDocMedico,
    @required idDocFarmaceutico,
  }) async {
    setState(() => isLoading = true);

    await FirestoreService().darBaixaReceitas(
      email: emailPaciente,
      emailMedico: emailMedico,
      idDoc: idDocPaciente,
      idDocFarmaceutico: idDocFarmaceutico,
      idDocMedico: idDocMedico,
    );

     Toast.show("Você deu baixa nesta receita!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

     Navigator.pop(context);
  }
}
