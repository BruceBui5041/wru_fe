import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/signup.screen.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = './signin';

  final _form = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm(BuildContext context) {
    final SignInDto signInDto = SignInDto(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    context.read<SignInCubit>().signIn(signInDto);
  }

  void _onOpenSignUpDialog(BuildContext context) {
    // showDialog<Null>(
    //   context: context,
    //   builder: (ctx) => SignUpDialog(),
    // );
    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Stack(
              children: [
                Container(
                  child: BlocConsumer<SignInCubit, SignInState>(
                    listener: (context, state) {
                      if (state is SignedIn) {
                        Navigator.of(context)
                            .pushReplacementNamed(HomeScreen.routeName);
                      } else if (state is SignInFail) {
                        print(state.message);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 50,
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
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
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
                                        bottom: 10.0,
                                        right: 20.0),
                                    child: Form(
                                      key: _form,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 4,
                                              left: 0,
                                            ),
                                            child: Text("Login Account",
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
                                            height: 50.0,
                                          ),
                                          TextFormField(
                                            controller: _usernameController,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .color),
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                              labelStyle: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .labelStyle,
                                              suffixIcon: Icon(
                                                Icons.email_outlined,
                                                color: Theme.of(context)
                                                    .accentIconTheme
                                                    .color,
                                              ),
                                              labelText: "Email",
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _passwordController,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline4
                                                    .color),
                                            textInputAction:
                                                TextInputAction.done,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              labelText: "Password",
                                              focusColor: Colors.white,
                                              labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline4
                                                      .color),
                                              suffixIcon: Icon(
                                                Icons.lock_outline,
                                                color: Theme.of(context)
                                                    .accentIconTheme
                                                    .color,
                                              ),
                                            ),
                                            onFieldSubmitted: (_) {
                                              _submitForm(context);
                                            },
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          FlatButton(
                                            color:
                                                Theme.of(context).buttonColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .color,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            minWidth: double.infinity,
                                            onPressed: () {
                                              _submitForm(context);
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
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
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                Container(
                                  width: 100,
                                  height: 1,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                          ),
                          FlatButton(
                            color: Theme.of(context).buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.button.color,
                                  fontWeight: FontWeight.w700),
                            ),
                            minWidth: 300,
                            onPressed: () {
                              _onOpenSignUpDialog(context);
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
