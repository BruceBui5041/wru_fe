import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/signup_cubit.dart';
import 'package:wru_fe/dto/signup.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/home_test.screen.dart';
import 'package:wru_fe/widgets/form_field_custom.widget.dart';
import 'package:wru_fe/widgets/button_long_custom.widget.dart';

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
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Center(
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
                                      Text(
                                        "Sign up Account",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      FormFieldCustomWidget(
                                        labelText: "Email",
                                        controller: _usernameController,
                                        icon: Icons.email_outlined,
                                        obscureText: false,
                                      ),
                                      FormFieldCustomWidget(
                                        labelText: "Password",
                                        controller: _passwordController,
                                        icon: Icons.lock_outline,
                                        obscureText: true,
                                      ),
                                      FormFieldCustomWidget(
                                        labelText: "Confirm Password",
                                        controller: _confirmPasswordController,
                                        icon: Icons.lock_outline,
                                        obscureText: true,
                                        onFieldSubmitted: (_) {
                                          _submitSignUp();
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ButtonLongCustomWidget(
                                        label: "Sign up",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/images/facebook.png'),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        child: Image.asset('assets/images/google.png'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
