import 'package:flutter/material.dart';
import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/models/user.model.dart';
import 'package:wru_fe/widgets/confirm_share_journey_dialog.widget.dart';

class SearchUserItem extends StatelessWidget {
  const SearchUserItem({
    Key? key,
    required this.user,
    required this.selectedJourney,
  }) : super(key: key);

  final User user;
  final Journey selectedJourney;

  void _openConfirmShareJourneyDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => ConfirmShareJourneyDialog(
        sharedUser: user,
        journey: selectedJourney,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _openConfirmShareJourneyDialog(context);
      },
      splashColor: Colors.brown.withOpacity(0.5),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.blue.withOpacity(0.3),
        ),
        child: Row(
          children: [
            //Expanded(child: Text(user.profile!.image ?? "")),
            Expanded(
              child: Column(
                children: [
                  Text(user.username ?? ""),
                  Text(user.email ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
