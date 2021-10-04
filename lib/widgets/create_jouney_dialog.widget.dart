import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/dto/create_jouney.dto.dart';
import 'package:wru_fe/utils.dart';

class CreateJouneyDialog extends StatefulWidget {
  const CreateJouneyDialog({Key? key}) : super(key: key);

  @override
  _CreateJouneyDialogState createState() => _CreateJouneyDialogState();
}

class _CreateJouneyDialogState extends State<CreateJouneyDialog> {
  String? localImagePath;
  String? uploadedFileName;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final _form = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();

    return BlocConsumer<JouneyCubit, JouneyState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return AlertDialog(
          elevation: 0,
          content: SizedBox(
            height: screenHeight * 0.5,
            width: screenWidth * 1,
            child: Form(
              // key: _form,
              child: Column(
                children: [
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
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: localImagePath == null
                            ? Container()
                            : Image.file(
                                File(
                                  localImagePath as String,
                                ),
                                width: 100,
                                height: 100,
                              ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          child: const Text("Image"),
                          onPressed: () async {
                            final ImagePicker _picker = ImagePicker();
                            final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery,
                            );

                            if (image != null) {
                              Upload.uploadSingleImage(image,
                                  (String? filename) {
                                print(filename);

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
                          },
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    child: const Text("Create Jouney"),
                    onPressed: () {
                      var createJouneyDto = CreateJouneyDto(
                          // name: _nameController.text,
                          // description: _descriptionController.text,
                          name: "AAAABBBB",
                          description: "asdqqqqqqq",
                          image: uploadedFileName);

                      context.read<JouneyCubit>().createJouney(createJouneyDto);
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
