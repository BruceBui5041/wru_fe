import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/signup_cubit.dart';
import 'package:wru_fe/dto/signup.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _submitSignUp() {
    final SignUpDto signUpDto = SignUpDto(
      username: _usernameController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    print(_passwordController.text);
    print(_confirmPasswordController.text);
    context.read<SignUpCubit>().signUp(signUpDto);
  }

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
                                top: 30.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 10,
                              ),
                              child: BlocConsumer<SignUpCubit, SignUpState>(
                                listener: (context, state) {
                                  if (state is SigningUp) {
                                    // TODO: Show loading indicator
                                  } else if (state is SignUpSuccessful) {
                                    Navigator.of(context).pushReplacementNamed(
                                        HomeScreen.routeName);
                                  } else if (state is SignUpFail) {
                                    // TODO: Show errors
                                    print(state.message);
                                  }
                                },
                                builder: (context, state) {
                                  return Form(
                                    key: _form,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 4,
                                            left: 0,
                                          ),
                                          child: Text(
                                            "Sign up Account",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        TextFormField(
                                          controller: _usernameController,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            labelText: "Email",
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: true,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            labelText: "Password",
                                          ),
                                        ),
                                        TextFormField(
                                          controller:
                                              _confirmPasswordController,
                                          obscureText: true,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            labelText: "Confirm Password",
                                          ),
                                          onFieldSubmitted: (_) {
                                            _submitSignUp();
                                          },
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        FlatButton(
                                          color: Theme.of(context).buttonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
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
                                          onPressed: _submitSignUp,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
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
