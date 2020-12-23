import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: Container(
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignedIn) {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            } else if (state is SignInFail) {
              // TODO: state.message is an array of error
              print(state.message);
            }
          },
          builder: (context, state) {
            return Form(
              key: _form,
              child: Center(
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 200,
                    maxHeight: 300,
                  ),
                  child: Container(
                    height: 250,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                          ),
                          onFieldSubmitted: (_) {
                            _submitForm(context);
                          },
                        ),
                        FlatButton(
                          child: Text("Login"),
                          onPressed: () {
                            _submitForm(context);
                          },
                        ),
                        FlatButton(
                          child: Text("Sign Up"),
                          onPressed: () {
                            _onOpenSignUpDialog(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
