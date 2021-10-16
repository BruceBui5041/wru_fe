import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:wru_fe/cubit/journey/journey_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/fetch_journey.dto.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';
import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/screens/journey_details.screen.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/journey.widget.dart';
import 'package:wru_fe/widgets/share_journey.widget.dart';

class JourneyList extends StatefulWidget {
  const JourneyList({
    Key? key,
  }) : super(key: key);

  @override
  _JourneyListState createState() => _JourneyListState();
}

class _JourneyListState extends State<JourneyList> {
  StreamSubscription<BoxEvent>? watchLastSeenJourney;
  var hiveConfig = getIt<HiveConfig>();
  var selectedJourneyId = getIt<HiveConfig>().storeBox!.get(LAST_SEEN_JOURNEY);

  @override
  void initState() {
    super.initState();
    context.read<JourneyCubit>().fetchJourneys(FetchJourneyDto());
    watchLastSeenJourney =
        hiveConfig.storeBox!.watch(key: LAST_SEEN_JOURNEY).listen((event) {
      context.read<JourneyCubit>().fetchJourneys(FetchJourneyDto());
      setState(() {
        selectedJourneyId = event.value;
      });
    });
  }

  @override
  void dispose() {
    if (watchLastSeenJourney != null) {
      watchLastSeenJourney!.cancel();
    }
    super.dispose();
  }

  Widget customJourneyItem(Journey journey) {
    return Stack(
      key: Key(journey.uuid.toString()),
      children: [
        JourneyItem(
            journey: journey, selected: journey.uuid == selectedJourneyId),
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
              () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return ShareJourney(
                        selectedJourney: journey.uuid ?? "",
                      );
                    });
              },
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
                    JourneyDetailScreen(
                      journeyId: journey.uuid.toString(),
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

  Widget _generateJourneyListWidget(List<Journey> journeys, ThemeData theme) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final journey = journeys[index];
        return customJourneyItem(journey);
      },
      itemCount: journeys.length,
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

    return BlocConsumer<JourneyCubit, JourneyState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        if (state is FetchJourneysFailed) {
          return Text(state.message.toString());
        } else if (state is FetchJourneysSuccessed) {
          return _generateJourneyListWidget(state.journeys, theme);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
