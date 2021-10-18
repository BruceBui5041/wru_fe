import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wru_fe/cubit/user/user_cubit.dart';
import 'package:wru_fe/widgets/search_user_item.widget.dart';

class ShareJouney extends StatefulWidget {
  const ShareJouney({Key? key, required this.selectedJourney})
      : super(key: key);

  final String selectedJourney;

  @override
  _ShareJouneyState createState() => _ShareJouneyState();
}

class _ShareJouneyState extends State<ShareJouney> {
  _ShareJouneyState();

  static final _form = GlobalKey<FormState>();
  final _searchAccountController = TextEditingController();
  final _searchTerms = BehaviorSubject<String>();
  void _searchForUser(String searchText) => _searchTerms.add(searchText);

  @override
  void didChangeDependencies() {
    _searchTerms.debounceTime(const Duration(milliseconds: 500)).listen(
      (searchText) {
        context.read<UserCubit>().searchUsers(searchText);
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchAccountController.dispose();
    _searchTerms.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is SearchUserSuccessed) {
          state.users.forEach((element) {
            print("${element.email} ${element.username}");
          });
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
                  TextField(
                    maxLines: 1,
                    controller: _searchAccountController,
                    onChanged: _searchForUser,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Search account',
                    ),
                  ),
                  state is SearchUserSuccessed
                      ? SizedBox(
                          height: media.size.height * 0.3,
                          child: ListView.builder(
                            itemCount: state.users.length,
                            itemBuilder: (_, index) {
                              return SearchUserItem(user: state.users[index]);
                            },
                          ),
                        )
                      : const Text("Empty")
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
