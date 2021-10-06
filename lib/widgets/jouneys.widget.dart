import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/widgets/jouney.widget.dart';

class JouneyList extends StatefulWidget {
  const JouneyList({
    Key? key,
  }) : super(key: key);

  @override
  _JouneyListState createState() => _JouneyListState();
}

class _JouneyListState extends State<JouneyList> {
  StreamSubscription<BoxEvent>? watchLastSeenJouney;

  @override
  void initState() {
    super.initState();
    context.read<JouneyCubit>().fetchJouneys(FetchJouneyDto());
    var hiveConfig = getIt<HiveConfig>();
    watchLastSeenJouney =
        hiveConfig.storeBox!.watch(key: LAST_SEEN_JOUNEY).listen((event) {
      context.read<JouneyCubit>().fetchJouneys(FetchJouneyDto());
    });
  }

  @override
  void dispose() {
    if (watchLastSeenJouney != null) {
      watchLastSeenJouney!.cancel();
    }
    super.dispose();
  }

  Widget _generateJouneyListWidget(List<Jouney> jouneys, ThemeData theme) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final Jouney jouney = jouneys[index];

        Widget jouneyItem = Stack(
          key: Key(jouney.uuid.toString()),
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            JouneyItem(
              jouney: jouney,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                chip(
                  const Icon(
                    Icons.share,
                    size: 17,
                    color: Colors.white,
                  ),
                  () {
                    print(jouney.uuid);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 2),
                  child: chip(
                    const Icon(
                      Icons.edit,
                      size: 17,
                      color: Colors.white,
                    ),
                    () {
                      print(jouney.uuid);
                    },
                  ),
                ),
              ],
            )
          ],
        );

        return jouneyItem;
      },
      itemCount: jouneys.length,
    );
  }

  Widget chip(Icon icon, Function() onClick) {
    return InkWell(
      onTap: onClick,
      splashColor: Colors.brown.withOpacity(0.5),
      child: Badge(
        toAnimate: false,
        shape: BadgeShape.circle,
        badgeColor: Colors.purple,
        badgeContent: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocConsumer<JouneyCubit, JouneyState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        if (state is FetchJouneysFailed) {
          return Text(state.message.toString());
        } else if (state is FetchJouneysSuccessed) {
          return _generateJouneyListWidget(state.jouneys, theme);
        } else if (state is FetchingJouney) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          context.read<JouneyCubit>().fetchJouneys(FetchJouneyDto());
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
