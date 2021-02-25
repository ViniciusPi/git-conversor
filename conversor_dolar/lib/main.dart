import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const Request =
    "https://economia.awesomeapi.com.br/all/USD-BRL,EUR-BRL,BTC-BRL";
void main() async {
  print(await Getdata());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber))),
  ));
}

Future<Map> Getdata() async {
  http.Response response = await http.get(Request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    if (text.isEmpty) {
      return clearAll();
    }

    double dolarc = double.parse(dolar);
    double euroc = double.parse(euro);
    double real = double.parse(text);
    dolarController.text = (real / dolarc).toStringAsFixed(2);
    euroController.text = (real / euroc).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      return clearAll();
    }

    double dolar = double.parse(text);
    double dolarf = double.parse(this.dolar);
    double eurof = double.parse(this.euro);
    realController.text = (dolarf * dolar).toStringAsFixed(2);
    euroController.text = (dolarf * dolar / eurof).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      return clearAll();
    }

    double euro = double.parse(text);
    double eurof = double.parse(this.euro);
    double dolarf = double.parse(this.dolar);
    realController.text = (euro * eurof).toStringAsFixed(2);
    dolarController.text = (euro * eurof / dolarf).toStringAsFixed(2);
  }

  dynamic dolar;
  dynamic euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '\$ Conversor \$',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: clearAll,
          )
        ],
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: Getdata(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando...",
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "ERRO!!!!",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["USD"]["bid"];
                euro = snapshot.data["EUR"]["bid"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.account_balance_outlined,
                          size: 100.0, color: Colors.amber),
                      Divider(
                        height: 15.0,
                      ),
                      buildTextfield(
                          'real', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextfield(
                          'dolar', 'U\$D', dolarController, _dolarChanged),
                      Divider(),
                      buildTextfield('Euro', '€', euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

buildTextfield(String label, String prefix, TextEditingController controle,
    Function funcao) {
  return TextField(
    onChanged: funcao,
    controller: controle,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
  );
}
