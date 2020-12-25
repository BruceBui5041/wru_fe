import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/widgets/signup.dialog.dart';

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
    showDialog<Null>(
      context: context,
      builder: (ctx) => SignUpDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
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
                          top: 100,
                          left: 0,
                        ),
                        child: Text(
                          "WRU",
                          style: GoogleFonts.averiaLibre(
                            fontSize: 60.6,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textTheme.headline1.color,
                          ),
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
                              height: MediaQuery.of(context).size.height / 2,
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
                                        child: Text(
                                          "Login",
                                          style: GoogleFonts.averiaLibre(
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
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
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          focusColor: Colors.white,
                                          labelStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .color),
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
                                        textInputAction: TextInputAction.done,
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
                                        color: Theme.of(context).buttonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
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
                                      FlatButton(
                                        color: Theme.of(context).buttonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
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
                                          _onOpenSignUpDialog(context);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
