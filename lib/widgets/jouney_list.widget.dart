import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/widgets/jouney_item.widget.dart';

class JouneyList extends StatefulWidget {
  const JouneyList({Key? key}) : super(key: key);

  @override
  _JouneyListState createState() => _JouneyListState();
}

class _JouneyListState extends State<JouneyList> {
  @override
  void initState() {
    super.initState();
    context.read<JouneyCubit>().fetchJouneys(FetchJouneyDto());
  }

  Widget _generateJouneyListWidget(
      List<Jouney> groups, MarkerCubit markerCubit) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final Jouney jouney = groups[index];
        if (index == 0) {
          return Column(
            children: [
              Container(
                height: 50,
                child: const Text("Drawer header"),
              ),
              JouneyItemWidget(
                jouney: jouney,
                markerCubit: markerCubit,
              )
            ],
          );
        }
        return JouneyItemWidget(jouney: jouney, markerCubit: markerCubit);
      },
      itemCount: groups.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JouneyCubit, JouneyState>(
      listener: (context, state) {
        // TODO Duplicate Unauthorized state
        // if (state is Unauthorized) {
        //   Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        // }
      },
      builder: (context, state) {
        if (state is FetchJouneysFailed) {
          return Text(state.message.toString());
        } else if (state is FetchJouneysSuccessed) {
          return _generateJouneyListWidget(
              state.jouneys, context.read<MarkerCubit>());
        } else {
          return const Text("Loading ...");
        }
      },
    );
  }
}
