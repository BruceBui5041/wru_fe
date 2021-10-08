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
import 'package:wru_fe/screens/jouney_details.screen.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/utils.dart';
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
  var hiveConfig = getIt<HiveConfig>();
  var selectedJouneyId = getIt<HiveConfig>().storeBox!.get(LAST_SEEN_JOUNEY);

  @override
  void initState() {
    super.initState();
    context.read<JouneyCubit>().fetchJouneys(FetchJouneyDto());
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

  Widget customJouneyItem(Jouney jouney) {
    return Stack(
      key: Key(jouney.uuid.toString()),
      children: [
        JouneyItem(jouney: jouney, selected: jouney.uuid == selectedJouneyId),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _chip(
              const Icon(
                Icons.share,
                size: 17,
                color: Colors.white,
              ),
              () {},
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 2),
              child: _chip(
                const Icon(
                  Icons.edit,
                  size: 17,
                  color: Colors.white,
                ),
                () {
                  Navigator.of(context).push(routeSlideFromBottomToTop(
                    JouneyDetailScreen(
                      jouneyId: jouney.uuid.toString(),
                    ),
                  ));
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _generateJouneyListWidget(List<Jouney> jouneys, ThemeData theme) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final Jouney jouney = jouneys[index];
        return customJouneyItem(jouney);
      },
      itemCount: jouneys.length,
    );
  }

  Widget _chip(Icon icon, Function() onClick) {
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
          var selectedJouney = state.jouneys.firstWhere((jouney) {
            return jouney.uuid == selectedJouneyId;
          });

          return _generateJouneyListWidget(state.jouneys, theme);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
