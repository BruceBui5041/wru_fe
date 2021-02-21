import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/signup.screen.dart';
import 'package:wru_fe/widgets/form_field_custom.widget.dart';
import 'package:wru_fe/widgets/button_long_custom.widget.dart';

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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Center(
                                child: Text(
                                  "WRU",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ),
                            Form(
                              key: _form,
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Text("Login Account",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
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
                                          onFieldSubmitted: (_) {
                                            _submitForm(context);
                                          },
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        ButtonLongCustomWidget(
                                          label: "Login",
                                          onPressed: () {},
                                        ),
                                        ButtonLongCustomWidget(
                                          label: "Login with guess",
                                          onPressed: () {
                                            _submitForm(context);
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 1,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                " OR ",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              Container(
                                                width: 100,
                                                height: 1,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            ],
                                          ),
                                        ),
                                        ButtonLongCustomWidget(
                                          label: "Sign up",
                                          onPressed: () {
                                            _onOpenSignUpDialog(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
