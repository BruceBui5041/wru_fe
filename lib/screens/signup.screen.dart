import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 80,
                      left: 0,
                    ),
                    child: Text(
                      "WRU",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Center(
                      child: Card(
                        color: Theme.of(context).cardTheme.color,
                        elevation: 6,
                        // margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 20.0, right: 20.0, bottom: 10),
                            child: Form(
                              key: _form,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                      left: 0,
                                    ),
                                    child: Text("Sign up Account",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     border: Border(
                                  //       bottom: BorderSide(
                                  //           width: 1.0,
                                  //           color: Theme.of(context).accentColor),
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                    ),
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                    ),
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: "Confirm Password",
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  FlatButton(
                                    color: Theme.of(context).buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    minWidth: double.infinity,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          " OR ",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Container(
                          width: 100,
                          height: 1,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
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
