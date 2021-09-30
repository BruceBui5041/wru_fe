import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/dto/create_marker.dto.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/widgets/form_field_custom.widget.dart';

class CreateMarkerBottomSheet extends StatelessWidget {
  CreateMarkerBottomSheet({
    Key? key,
    required this.jouneyId,
  }) : super(key: key);

  final String jouneyId;
  final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submit(BuildContext context) {
    final CreateMarkerDto createMarkerDto = CreateMarkerDto(
      name: _nameController.text,
      lat: 106.430417,
      lng: 10.521607,
      description: _descriptionController.text,
      jouneyId: "2673a2f7-aaf2-444b-a8f5-cec3d52e9b9e",
    );

    FocusScope.of(context).unfocus();
    context.read<MarkerCubit>().createMarker(createMarkerDto);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MarkerCubit, MarkerState>(
      listener: (_, MarkerState state) {
        if (state is CreateMarkerSuccessed) {
          Navigator.of(context).pop();

          context
              .read<MarkerCubit>()
              .fetchMarkers(FetchMarkerDto(jouneyId: jouneyId));
        }
      },
      child: Form(
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
      ),
    );
  }
}
