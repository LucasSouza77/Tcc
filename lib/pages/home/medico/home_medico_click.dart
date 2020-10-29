import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc/utils/color_util.dart';

class HomeMedicoClick extends StatefulWidget {
  @override
  _HomeMedicoClickState createState() => _HomeMedicoClickState();

  var receita;
  var medico;
  var receitaTexto;
  var farmaceutico;

  HomeMedicoClick({
    @required this.receita,
    @required this.medico,
    @required this.receitaTexto,
    @required this.farmaceutico,
  });
}

class _HomeMedicoClickState extends State<HomeMedicoClick> {
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
          widget.receita,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.person_pin_circle, color: Colors.black87),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Médico\n${widget.medico}",
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
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.local_hospital_rounded, color: Colors.black87),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Farmacêutico\n${widget.farmaceutico}",
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
                child: Text(
                  "${widget.receitaTexto}",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
