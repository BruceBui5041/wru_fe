import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/dto/create_marker.dto.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/form_field_custom.widget.dart';

class CreateMarkerBottomSheet extends StatelessWidget {
  CreateMarkerBottomSheet({
    Key? key,
    required this.jouneyId,
    required this.loadLastSeenJouney,
  }) : super(key: key);

  final String jouneyId;
  final Function loadLastSeenJouney;
  final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submit(BuildContext context) async {
    Position useLocation = await getUserLocation();

    final CreateMarkerDto createMarkerDto = CreateMarkerDto(
      name: _nameController.text,
      lat: useLocation.latitude,
      lng: useLocation.longitude,
      description: _descriptionController.text,
      jouneyId: jouneyId,
    );

    FocusScope.of(context).unfocus();
    context.read<MarkerCubit>().createMarker(createMarkerDto).then((value) {
      loadLastSeenJouney();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Checkin",
            style: Theme.of(context).textTheme.headline5,
          ),
          FormFieldCustomWidget(
            textInputAction: TextInputAction.next,
            labelText: "Name",
            controller: _nameController,
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
          const Text("Image"),
          ElevatedButton(
            child: const Text('Submit'),
            onPressed: () {
              _submit(context);
            },
          )
        ],
      ),
    );
  }
}
