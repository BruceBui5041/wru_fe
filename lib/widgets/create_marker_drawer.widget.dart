import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/dto/create_marker.dto.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/form_field_custom.widget.dart';

class CreateMarkerBottomSheet extends StatefulWidget {
  const CreateMarkerBottomSheet({
    Key? key,
    required this.journeyId,
    required this.loadLastSeenJourney,
  }) : super(key: key);

  final String journeyId;
  final Function loadLastSeenJourney;

  @override
  _CreateMarkerBottomSheetState createState() =>
      _CreateMarkerBottomSheetState();
}

class _CreateMarkerBottomSheetState extends State<CreateMarkerBottomSheet> {
  _CreateMarkerBottomSheetState();

  static final GlobalKey _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? localImagePath;
  String? uploadedFileName;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, String journeyId,
      Function loadLastSeenJourney) async {
    Position useLocation = await getUserLocation();

    final CreateMarkerDto createMarkerDto = CreateMarkerDto(
      name: _nameController.text,
      lat: useLocation.latitude,
      lng: useLocation.longitude,
      description: _descriptionController.text,
      journeyId: journeyId,
      image: uploadedFileName,
    );

    FocusScope.of(context).unfocus();
    context.read<MarkerCubit>().createMarker(createMarkerDto).then((value) {
      loadLastSeenJourney();
      Navigator.of(context).pop();
    });
  }

  Widget _imageSelector(String? localImagePath) {
    return InkWell(
      onTap: _selectImage,
      splashColor: Colors.brown.withOpacity(0.5),
      child: SizedBox(
        height: 150,
        width: 200,
        child: Stack(
          children: [
            const Center(child: Icon(Icons.add_a_photo)),
            localImagePath == null
                ? Container()
                : Center(
                    child: Image.file(
                      File(
                        localImagePath,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      Upload.uploadSingleImage(image, (
        String? filename,
      ) {
        setState(() {
          uploadedFileName = filename;
        });
      });
    }

    if (image?.path != null) {
      setState(() {
        localImagePath = image!.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _imageSelector(localImagePath),
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
                _submit(context, widget.journeyId, widget.loadLastSeenJourney);
              },
            ),
            TextButton(
              child: const Text('Checkin'),
              onPressed: () {
                _submit(context, widget.journeyId, widget.loadLastSeenJourney);
              },
            )
          ],
        ),
      ),
    );
  }
}
