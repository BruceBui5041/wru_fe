import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/dto/create_group.dto.dart';
import 'package:wru_fe/screens/group_details.screen.dart';
import 'package:wru_fe/widgets/form_field_custom.widget.dart';

class CreateGroupBottomSheet extends StatelessWidget {
  final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submit(BuildContext context) {
    final CreateGroupDto createGroupDto = CreateGroupDto(
      groupName: _groupNameController.text,
      description: _descriptionController.text,
    );
    FocusScope.of(context).unfocus();
    context.read<GroupCubit>().createGroup(createGroupDto);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCubit, GroupState>(
      listener: (_, GroupState state) {
        if (state is CreateNewGroupSuccessed) {
          // Close the bottom sheet after create group successed
          Navigator.of(context).pop();

          Navigator.of(context).pushReplacementNamed(
            GroupDetailsScreen.routeName,
            arguments: state.group.uuid,
          );
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          color: Colors.white,
          child: Center(
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Group Infomation",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  FormFieldCustomWidget(
                    textInputAction: TextInputAction.next,
                    labelText: "Name",
                    controller: _groupNameController,
                    obscureText: false,
                  ),
                  FormFieldCustomWidget(
                    textInputAction: TextInputAction.done,
                    labelText: "Description",
                    controller: _descriptionController,
                    obscureText: false,
                    onFieldSubmitted: (_) {
                      _submit(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      _submit(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
