import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tcc/models/users_shared.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/color_util.dart';
import 'package:tcc/utils/text_form_field_util.dart';
import 'package:toast/toast.dart';

class HomeMedicoAdd extends StatefulWidget {
  @override
  _HomeMedicoAddState createState() => _HomeMedicoAddState();

  var _controllerTexto = TextEditingController();
  var errorTexto;
}

class _HomeMedicoAddState extends State<HomeMedicoAdd> {
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
          "Adicionar receita",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: qrText.isEmpty
          ? QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            )
          : FutureBuilder(
              future: FirestoreService().getTypeUser(
                email: qrText.replaceAll("http://", ""),
              ),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                              Icon(Icons.person_pin_circle,
                                  color: Colors.black87),
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
                                  calcularIdade(
                                      snapshot.data.data()['dataDeNascimento']),
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
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormFieldUtil().build(
                              title: "Digite a receita do paciente",
                              obscured: false,
                              inputType: TextInputType.text,
                              controller: widget._controllerTexto,
                              error: widget.errorTexto,
                              line: 5,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.3, 1],
                                colors: [
                                  ColorUtil.colorPrimary,
                                  ColorUtil.colorPrimary.withOpacity(0.8)
                                ],
                              ),
                            ),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => submitCadastrarReceita(
                                email: snapshot.data.data()['email'],
                                nome: snapshot.data.data()['nome'],
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 25),
                                            Text(
                                              "Cadastrar receita",
                                              style: TextStyle(
                                                fontSize: 18,
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
                                              width: 35,
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
                  ),
                );
              },
            ),
    );
  }

  String calcularIdade(value) {
    return "Idade\n" +
        getAge(value.split("/")[2], value.split("/")[1], value.split("/")[0]);
  }

  getAge(String year, String month, String day) {
    final birthday =
        DateTime(int.parse(year), int.parse(month), int.parse(day));

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

  void submitCadastrarReceita({@required email, @required nome}) async {
    if (widget._controllerTexto.text.isEmpty) {
      setState(() => widget.errorTexto = "Não deixe o campo vazio");
    } else {
      setState(() => isLoading = true);

      await FirestoreService().salvarReceitas(
        email: email,
        nome: nome,
        nameMedico: await UsersShared().getUser(type: "name"),
        emailMedico: await UsersShared().getUser(type: "email"),
        receita: widget._controllerTexto.text,
      );

      Toast.show("Você cadastrou uma nova receita", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      Navigator.pop(context);
    }
  }
}
