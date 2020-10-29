import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc/models/users_shared.dart';
import 'package:tcc/pages/home/farmaceutico/home_farmaceutico.dart';
import 'package:tcc/pages/home/medico/home_medico.dart';
import 'package:tcc/pages/home/paciente/home_paciente.dart';
import 'package:tcc/services/authentication_service.dart';
import 'package:tcc/services/firestore_service.dart';
import 'package:tcc/utils/color_util.dart';
import 'package:tcc/utils/navigator.dart';
import 'package:tcc/utils/text_form_field_util.dart';

import 'cadastro.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();

  var _controllerEmail = TextEditingController(); var errorEmail;
  var _controllerPassword = TextEditingController(); var errorPassword;
}

class _LoginState extends State<Login> {
  bool isLoading = false;

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
                title: "E-mail",
                controller: widget._controllerEmail,
                error: widget.errorEmail,
                obscured: false,
                inputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              TextFormFieldUtil().build(
                title: "Senha",
                controller: widget._controllerPassword,
                error: widget.errorPassword,
                obscured: true,
                inputType: TextInputType.text,
              ),
              Container(
                height: 40,
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: Text(
                    "Recuperar senha",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: ColorUtil.colorPrimary,
                    ),
                  ),
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
                  onPressed: () => submitLogin(),
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
                            "Entrar",
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
              SizedBox(height: 5),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => Cadastro(),
                )),
                child: Text(
                  "Não tem uma conta? Clique aqui!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: ColorUtil.colorPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitLogin() {
    if(widget._controllerEmail.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorEmail = "Não deixe o campo vazio!");
    } else if(widget._controllerPassword.text.isEmpty) {
      setNullAllPointer();
      setState(() => widget.errorPassword = "Não deixe o campo vazio!");
    } else {
      setState(() => isLoading = true);

      setNullAllPointer();

      AuthenticartionService.login(
        email: widget._controllerEmail.text,
        password: widget._controllerPassword.text,
      ).then((value) async {
        switch(value) {
          case 'Email não encontrado.' :
            setState(() {
              widget._controllerEmail.clear();
              widget._controllerPassword.clear();
              widget.errorEmail = value;
              isLoading = false;
            });
            break;
          case 'Senha incorreta.' :
            setState(() {
              widget._controllerEmail.clear();
              widget._controllerPassword.clear();
              widget.errorPassword = value;
              isLoading = false;
            });
            break;
          case 'Sucesso' :
            FirestoreService().getTypeUser(
              email: widget._controllerEmail.text,
            ).then((value) async {
              if(value.data().containsKey("categoria")) {
                await UsersShared().saveUser(
                  name: value.data()['nome'],
                  endereco: value.data()['endereco'],
                  celular: value.data()['celular'],
                  email: value.data()['email'],
                  categoria: value.data()['categoria'],
                  CPF: value.data()['cpf'],
                  dataNascimento: value.data()['dataDeNascimento'],
                );

                switch(value.data()['categoria']) {
                  case "Paciente": NavigatorUtil().buildAndRemove(context: context, page: HomePaciente()); break;
                  case "Médico": NavigatorUtil().buildAndRemove(context: context, page: HomeMedico()); break;
                  case "Farmacêutico": NavigatorUtil().buildAndRemove(context: context, page: HomeFarmaceutico()); break;
                }
              }
            });
            break;
        }
      });
    }
  }

  setNullAllPointer() {
    setState(() {
      widget.errorEmail = null;
      widget.errorPassword = null;
    });
  }
}
