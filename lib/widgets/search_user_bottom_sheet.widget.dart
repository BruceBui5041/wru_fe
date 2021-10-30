import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wru_fe/cubit/user/user_cubit.dart';
import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/models/user.model.dart';
import 'package:wru_fe/widgets/search_user_item.widget.dart';

class SearchUserBottomSheet extends StatefulWidget {
  const SearchUserBottomSheet({
    Key? key,
    required this.selectedJourney,
  }) : super(key: key);

  final Journey selectedJourney;

  @override
  _SearchUserBottomSheetState createState() => _SearchUserBottomSheetState();
}

class _SearchUserBottomSheetState extends State<SearchUserBottomSheet> {
  _SearchUserBottomSheetState();

  static final _form = GlobalKey<FormState>();
  final _searchAccountController = TextEditingController();
  final _searchTerms = BehaviorSubject<String>();
  late StreamSubscription<String> _searchListener;
  String? prevSearchText = '';

  @override
  void didChangeDependencies() {
    _searchListener = _searchTerms
        .debounceTime(const Duration(milliseconds: 500))
        .where((searchText) => prevSearchText != searchText)
        .listen(
      (searchText) {
        prevSearchText = searchText;
        context.read<UserCubit>().searchUsers(searchText);
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    prevSearchText = "";
    _searchListener.cancel();
    _searchAccountController.dispose();
    _searchTerms.close();
    super.dispose();
  }

  void _searchForUser(String searchText) {
    _searchTerms.add(searchText);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        List<User> users = [];
        if (state is SearchUserSuccessed) {
          users = state.users;
        }
        return SizedBox(
          height: media.size.height * 0.8,
          child: Container(
            margin: const EdgeInsets.fromLTRB(7, 0, 7, 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      maxLines: 1,
                      controller: _searchAccountController,
                      onChanged: _searchForUser,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Search account',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, index) {
                        return SearchUserItem(
                          key: Key(users[index].uuid!),
                          user: users[index],
                          selectedJourney: widget.selectedJourney,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
