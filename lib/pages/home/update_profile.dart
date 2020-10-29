import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc/models/users_shared.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/color_util.dart';
import 'package:tcc/utils/text_form_field_util.dart';
import 'package:toast/toast.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();

  var _controllerName = TextEditingController(); var errorName;
  var _controllerPhone = TextEditingController(); var errorPhone;
  var _controllerAddress = TextEditingController(); var errorAdress;
  var _controllerCPF = TextEditingController(); var errorCPF;
  var _controllerDate = TextEditingController(); var errorDate;
}

class _UpdateProfileState extends State<UpdateProfile> {
  Future<SharedPreferences> futureProfile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    futureProfile = SharedPreferences.getInstance();
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
          "Alterar dados",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 25,
          right: 25,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: FutureBuilder(
            future: futureProfile,
            builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              widget._controllerName.text = snapshot.data.getString("name");
              widget._controllerCPF.text = snapshot.data.getString("CPF");
              widget._controllerDate.text = snapshot.data.getString("dataNascimento");
              widget._controllerPhone.text = snapshot.data.getString("celular");
              widget._controllerAddress.text = snapshot.data.getString("endereco");

              return Column(
                children: [
                  SizedBox(
                    width: 256,
                    height: 256,
                    child: Image.asset("assets/logo.png"),
                  ),
                  TextFormFieldUtil().build(
                    title: "Nome",
                    controller: widget._controllerName,
                    error: widget.errorName,
                    obscured: false,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  TextFormFieldUtil().build(
                    title: "Celular",
                    controller: widget._controllerPhone,
                    error: widget.errorPhone,
                    obscured: false,
                    inputType: TextInputType.number,
                    mask: "+55 (##) #####-####",
                  ),
                  SizedBox(height: 10),
                  TextFormFieldUtil().build(
                    title: "Endereço",
                    controller: widget._controllerAddress,
                    error: widget.errorAdress,
                    obscured: false,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  TextFormFieldUtil().build(
                      title: "CPF",
                      controller: widget._controllerCPF,
                      error: widget.errorCPF,
                      inputType: TextInputType.number,
                      mask: "###.###.###-##",
                      obscured: false
                  ),
                  SizedBox(height: 10),
                  TextFormFieldUtil().build(
                    title: "Data de nascimento",
                    controller: widget._controllerDate,
                    error: widget.errorDate,
                    inputType: TextInputType.number,
                    mask: "##/##/####",
                    obscured: false,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
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
                      onPressed: () => submitAlterar(
                        email: snapshot.data.getString("email"),
                      ),
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
                                "Alterar dados",
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
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void submitAlterar({@required email}) async {
    if(widget._controllerName.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorName = "Não deixe o campo vazio!");
    } else if(widget._controllerPhone.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorPhone = "Não deixe o campo vazio!");
    } else if(widget._controllerAddress.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorAdress = "Não deixe o campo vazio!");
    } else if(widget._controllerCPF.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorCPF = "Não deixe o campo vazio!");
    } else if(widget._controllerDate.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorDate = "Não deixe o campo vazio!");
    } else {
      setState(() => isLoading = true);

      setNullAllPointer();

      await FirestoreService().updateProfile(
        email: email,
        nome: widget._controllerName.text,
        endereco: widget._controllerAddress.text,
        celular: widget._controllerPhone.text,
        dataDeNascimento: widget._controllerDate.text,
        cpf: widget._controllerCPF.text,
      );

      await UsersShared().saveUser(
        celular: widget._controllerPhone.text,
        endereco: widget._controllerAddress.text,
        name: widget._controllerName.text,
        CPF: widget._controllerCPF.text,
        dataNascimento: widget._controllerDate.text,
      );

      Toast.show("Dados alterado com sucesso", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      Navigator.pop(context);
    }
  }

  setNullAllPointer() {
    setState(() {
      widget.errorName = null;
      widget.errorPhone = null;
      widget.errorCPF = null;
      widget.errorDate = null;
      widget.errorAdress = null;
    });
  }
}
