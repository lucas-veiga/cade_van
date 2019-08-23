import 'package:flutter/material.dart';

class ResponsibleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "NOME",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Mateus Gomes',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "EMAIL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: EdgeInsets.only(left: 0.0, right: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'mateus7532@gmail.com',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "TELEFONE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '(61) 99878 7528',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      "SENHA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: new Text(
                      "CONFIRMAR SENHA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 0.5,
                      style: BorderStyle.solid),
                ),
              ),
              padding: const EdgeInsets.only(left: 0.0, right: 10.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Expanded(
                    child: TextField(
                      obscureText: true,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '*********',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () => {},
                      child: new Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: Text(
                                "CADASTRAR",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
