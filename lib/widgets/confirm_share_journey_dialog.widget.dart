import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:wru_fe/cubit/journey/journey_cubit.dart';
import 'package:wru_fe/dto/share_journey.dto.dart';
import 'package:wru_fe/dto/update_journey.dto.dart';
import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/models/user.model.dart';

class ConfirmShareJourneyDialog extends StatelessWidget {
  const ConfirmShareJourneyDialog({
    Key? key,
    required this.sharedUser,
    required this.journey,
  }) : super(key: key);

  final User sharedUser;
  final Journey journey;

  void _shareJourney(BuildContext context) {
    ShareJourneyDto updateJourneyDto = ShareJourneyDto(
        jouneyId: journey.uuid!, userSharedName: sharedUser.username!);
    context.read<ShareJourneyCubit>().shareJourney(updateJourneyDto);
  }

  void _showSnackBar(BuildContext context, ShareJourneyState state) {
    Widget content = Container();
    var textTheme = Theme.of(context).textTheme;

    if (state is ShareJourneySuccessed) {
      Navigator.of(context).pop();

      content = Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Share journey'),
            TextSpan(
              text: ' ${journey.name} ',
              style: textTheme.headline4,
            ),
            const TextSpan(text: 'to'),
            TextSpan(
              text: ' ${sharedUser.username}',
              style: textTheme.headline4,
            ),
            const TextSpan(text: ' successfully!'),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: content),
      );
    } else if (state is ShareJourneyFailed) {
      Navigator.of(context).pop();

      content = Text(
        state.message!,
        style: const TextStyle(color: Colors.red),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: content),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return BlocListener<ShareJourneyCubit, ShareJourneyState>(
      listener: (_, state) {
        _showSnackBar(context, state);
      },
      child: AlertDialog(
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              _shareJourney(context);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("No"),
          )
        ],
        content: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Do you want to share'),
              TextSpan(
                text: ' ${journey.name} ',
                style: textTheme.headline4,
              ),
              const TextSpan(text: 'to'),
              TextSpan(
                text: ' ${sharedUser.username}',
                style: textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
