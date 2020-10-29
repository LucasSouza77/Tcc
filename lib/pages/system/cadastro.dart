import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc/models/users_shared.dart';
import 'package:tcc/models/usuario.dart';
import 'package:tcc/pages/home/farmaceutico/home_farmaceutico.dart';
import 'package:tcc/pages/home/medico/home_medico.dart';
import 'package:tcc/pages/home/paciente/home_paciente.dart';
import 'package:tcc/services/authentication_service.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/color_util.dart';
import 'package:tcc/utils/navigator.dart';
import 'package:tcc/utils/text_form_field_util.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();

  var _controllerName = TextEditingController(); var errorName;
  var _controllerPhone = TextEditingController(); var errorPhone;
  var _controllerAddress = TextEditingController(); var errorAdress;
  var _controllerCPF = TextEditingController(); var errorCPF;
  var _controllerEmail = TextEditingController(); var errorEmail;
  var _controllerPassword = TextEditingController(); var errorPassword;
  var _controllerDate = TextEditingController(); var errorDate;
}

class _CadastroState extends State<Cadastro> {
  bool isLoading = false;

  int segmentedControlGroupValue = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text(
      "Paciente",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    ),
    1: Text("Médico", style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    )),
    2: Text("Farmacêutico", style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    )),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 25,
          left: 25,
          right: 25,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
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
                title: "Email",
                controller: widget._controllerEmail,
                error: widget.errorEmail,
                inputType: TextInputType.emailAddress,
                obscured: false,
              ),
              SizedBox(height: 10),
              TextFormFieldUtil().build(
                title: "Senha",
                controller: widget._controllerPassword,
                error: widget.errorPassword,
                inputType: TextInputType.text,
                obscured: true,
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
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                child: CupertinoSlidingSegmentedControl(
                  groupValue: segmentedControlGroupValue,
                  children: myTabs,
                  onValueChanged: (i) {
                    setState(() {
                      segmentedControlGroupValue = i;
                    });
                  },
                ),
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
                  onPressed: () => submitCadastrar(),
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
                            "Cadastrar",
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
          ),
        ),
      ),
    );
  }

  void submitCadastrar() {
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
    } else if(widget._controllerEmail.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorEmail = "Não deixe o campo vazio!");
    } else if(widget._controllerPassword.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorPassword = "Não deixe o campo vazio!");
    } else if(widget._controllerDate.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorDate = "Não deixe o campo vazio!");
    } else {
      setState(() => isLoading = true);

      setNullAllPointer();

      AuthenticartionService.register(
        email: widget._controllerEmail.text,
        password: widget._controllerPassword.text,
      ).then((value) {
        switch(value) {
          case 'Esse email já existe.' :
            setState(() {
              widget._controllerEmail.clear();
              widget._controllerPassword.clear();
              widget.errorEmail = value;
              isLoading = false;
            });
            break;
          case 'Senha mínima é de 6 caractéres.' :
            setState(() {
              widget._controllerEmail.clear();
              widget._controllerPassword.clear();
              widget.errorPassword = value;
              isLoading = false;
            });
            break;
          case 'Sucesso' :
            Usuario usuario = Usuario(
              senha: widget._controllerPassword.text,
              email: widget._controllerEmail.text,
              cpf: widget._controllerCPF.text,
              celular: widget._controllerPhone.text,
              dataDeNascimento: widget._controllerDate.text,
              endereco: widget._controllerAddress.text,
              nome: widget._controllerName.text,
              category: segmentedControlGroupValue == 0
                  ? "Paciente" : segmentedControlGroupValue == 1
                  ? "Médico"
                  : "Farmacêutico",
            );

            FirestoreService().salvarUsuario(usuario);

            UsersShared().saveUser(
              dataNascimento: widget._controllerDate.text,
              CPF: widget._controllerCPF.text,
              categoria: segmentedControlGroupValue == 0
                  ? "Paciente" : segmentedControlGroupValue == 1
                  ? "Médico"
                  : "Farmacêutico",
              email: widget._controllerEmail.text,
              celular: widget._controllerPhone.text,
              endereco: widget._controllerAddress.text,
              name: widget._controllerName.text,
            );

            switch(segmentedControlGroupValue) {
              case 0: NavigatorUtil().buildAndRemove(context: context, page: HomePaciente()); break;
              case 1: NavigatorUtil().buildAndRemove(context: context, page: HomeMedico()); break;
              case 2: NavigatorUtil().buildAndRemove(context: context, page: HomeFarmaceutico()); break;
            }
            break;
        }
      });
    }
  }

  setNullAllPointer() {
    setState(() {
      widget.errorName = null;
      widget.errorPhone = null;
      widget.errorAdress = null;
      widget.errorCPF = null;
      widget.errorEmail = null;
      widget.errorPassword = null;
      widget.errorDate = null;
    });
  }
}
