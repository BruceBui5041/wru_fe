import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ShareJourney extends StatelessWidget {
  ShareJourney({Key? key, required this.selectedJourney}) : super(key: key);
  final String selectedJourney;

  final _searchAccountController = TextEditingController();
  final _searchTerms = BehaviorSubject<String>();
  void _searchForUser(String searchText) => _searchTerms.add(searchText);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    _searchTerms
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {
      print('abcd: $event');
    });

    return SizedBox(
      height: media.size.height * 0.5,
      child: Container(
        margin: const EdgeInsets.fromLTRB(7, 0, 7, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          child: TextField(
            maxLines: 1,
            controller: _searchAccountController,
            onChanged: _searchForUser,
            decoration: const InputDecoration(
              labelText: 'Search account',
            ),
          ),
        ),
      ),
    );
  }
}
