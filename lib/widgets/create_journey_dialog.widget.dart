import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wru_fe/cubit/journey/journey_cubit.dart';
import 'package:wru_fe/dto/create_jouney.dto.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/utils.dart';

class CreateJourneyDialog extends StatefulWidget {
  const CreateJourneyDialog({Key? key}) : super(key: key);

  @override
  _CreateJourneyDialogState createState() => _CreateJourneyDialogState();
}

class _CreateJourneyDialogState extends State<CreateJourneyDialog> {
  String? localImagePath;
  String? uploadedFileName;

  static final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
            const Center(
              child: Icon(
                Icons.add_a_photo,
                color: Colors.purple,
              ),
            ),
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<JourneyCubit, JourneyState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return AlertDialog(
          elevation: 0,
          scrollable: true,
          content: SizedBox(
            height: screenHeight * 0.5,
            width: screenWidth * 1,
            child: Form(
              key: _form,
              child: Column(
                children: [
                  _imageSelector(localImagePath),
                  TextField(
                    maxLines: 1,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      focusColor: Colors.red,
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    minLines: 2,
                    maxLines: 3,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      focusColor: Colors.red,
                      labelText: 'Description',
                    ),
                  ),
                  TextButton(
                    child: const Text("Create Journey"),
                    onPressed: () {
                      var createJourneyDto = CreateJourneyDto(
                        name: _nameController.text,
                        description: _descriptionController.text,
                        image: uploadedFileName,
                      );

                      context
                          .read<CreateJourneyCubit>()
                          .createJourney(createJourneyDto)
                          .then((journey) {
                        setValueToStore(
                          LAST_SEEN_JOURNEY,
                          journey!.uuid.toString(),
                        );
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
