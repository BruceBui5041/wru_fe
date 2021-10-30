import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/signup.screen.dart';
import 'package:wru_fe/widgets/form_field_custom.widget.dart';
import 'package:wru_fe/widgets/button_long_custom.widget.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
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
    final screenSize = MediaQuery.of(context).size;
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
                              height: screenSize.height * 0.2,
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
                                  SizedBox(
                                    height: screenSize.height * 0.8,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            "Login Account",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                        FormFieldCustomWidget(
                                          labelText: "Email",
                                          controller: _usernameController,
                                          icon: Icons.email_outlined,
                                          textInputAction: TextInputAction.next,
                                          obscureText: false,
                                        ),
                                        FormFieldCustomWidget(
                                          labelText: "Password",
                                          controller: _passwordController,
                                          icon: Icons.lock_outline,
                                          textInputAction: TextInputAction.done,
                                          obscureText: true,
                                          onFieldSubmitted: (_) {
                                            _submitForm(context);
                                          },
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        ButtonLongCustomWidget(
                                          label: "Login",
                                          onPressed: () {
                                            _submitForm(context);
                                          },
                                        ),
                                        ButtonLongCustomWidget(
                                          label: "Facebook",
                                          onPressed: () {},
                                        ),
                                        ButtonLongCustomWidget(
                                          label: "Google",
                                          onPressed: () {},
                                        ),
                                        const Divider(
                                          height: 20,
                                          thickness: 1,
                                          indent: 20,
                                          endIndent: 20,
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
