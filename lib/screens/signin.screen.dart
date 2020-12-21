import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/dto/signin.dto.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = './signin';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _form = GlobalKey<FormState>();
  final SignInDto _signInDto = SignInDto(username: '', password: '');

  void _submitForm(BuildContext context) async {
    _form.currentState.save();
    print(_signInDto.username);
    print(_signInDto.password);

    context.read<SignInCubit>().signIn(_signInDto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignedIn) {
              // TODO: Go to Home pay
            } else if (state is SignInFail) {
              // TODO: state.message is an array of error
            }
          },
          builder: (context, state) {
            return Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    onSaved: (newValue) {
                      setState(() {
                        _signInDto.username = newValue;
                      });
                    },
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    // TODO: Find a way get user's input but not **** characters with obscureText: true
                    // obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onFieldSubmitted: (_) {
                      _submitForm(context);
                    },
                    onSaved: (newValue) {
                      setState(() {
                        _signInDto.password = newValue;
                      });
                    },
                  ),
                  FlatButton(
                    child: Text("Login"),
                    onPressed: () {
                      _submitForm(context);
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
