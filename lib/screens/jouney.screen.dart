import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';

class JouneyScreen extends StatefulWidget {
  const JouneyScreen({Key? key}) : super(key: key);
  static const routeName = "/jouney-screen";

  @override
  _JouneyScreenState createState() => _JouneyScreenState();
}

class _JouneyScreenState extends State<JouneyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JouneyCubit>().fetchGroups(FetchJouneyDto());
  }

  Widget _generateGroupListWidget(List<Jouney> groups) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final Jouney jouney = groups[index];
        return Column(
          children: [
            Text(jouney.uuid ?? ""),
            Text(jouney.name ?? ""),
            Text(jouney.createdAt ?? "")
          ],
        );
      },
      itemCount: groups.length,
    );
  }

  Widget _screenContent(JouneyState state) {
    if (state is FetchJouneysFailed) {
      return Text(state.message.toString());
    } else if (state is FetchJouneysSuccessed) {
      return _generateGroupListWidget(state.jouneys);
    } else {
      return const Text("Loading ...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JouneyCubit, JouneyState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            child: _screenContent(state),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('Jouney'),
            icon: const Icon(Icons.add),
            backgroundColor: Theme.of(context).accentColor,
          ),
        );
      },
    );
  }
}
