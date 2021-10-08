import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/update_jouney.dto.dart';
import 'package:wru_fe/enums.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/custom_cached_image.widget.dart';

class JouneyDetailScreen extends StatefulWidget {
  JouneyDetailScreen({Key? key, this.jouneyId}) : super(key: key);
  static const routeName = "/jouney-details-screen";
  String? jouneyId;

  @override
  _JouneyDetailScreenState createState() => _JouneyDetailScreenState();
}

class _JouneyDetailScreenState extends State<JouneyDetailScreen> {
  Jouney? jouney;
  static String visibilityValue = 'Public';
  String? localImagePath;
  String? uploadedFileName;

  static final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    context.read<FetchJouneyByIdCubit>().fetchJouneyById(
          widget.jouneyId.toString(),
          details: true,
        );

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  FlexibleSpaceBar _sliverAppbar(Jouney? jouney) {
    return FlexibleSpaceBar(
      title: Text(jouney?.name ?? ""),
      centerTitle: true,
      background: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [
              Colors.blue,
              Colors.transparent,
            ],
          ),
        ),
        child: localImagePath != null
            ? Image.file(
                File(
                  localImagePath!,
                ),
                fit: BoxFit.cover,
              )
            : CustomCachedImage(imageUrl: jouney!.image),
      ),
    );
  }

  Widget _jouneyVisibilitySelector(ThemeData theme) {
    return DropdownButton(
      value: visibilityValue,
      alignment: Alignment.bottomRight,
      style: TextStyle(
        color: theme.textTheme.headline4!.color,
        fontSize: theme.textTheme.headline4!.fontSize,
      ),
      underline: Container(
        color: Colors.transparent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          visibilityValue = newValue!;
        });
      },
      items: ['Public', 'Private'].map<DropdownMenuItem<String>>((
        String value,
      ) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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

  void _updateData(Jouney? newJouney) {
    _nameController.text = newJouney!.name ?? "";
    _descriptionController.text = newJouney.description ?? "";
    setState(() {
      jouney = newJouney;

      visibilityValue = newJouney.visibility == JouneyVisibility.private
          ? "Private"
          : "Public";
      uploadedFileName = newJouney.imageName;
    });
  }

  void _submit() {
    var updateDto = UpdateJouneyDto(jouneyId: jouney!.uuid.toString());
    updateDto.name = _nameController.text;
    updateDto.description = _descriptionController.text;
    updateDto.image = uploadedFileName;
    updateDto.visibility = visibilityValue == "Private"
        ? JouneyVisibility.private
        : JouneyVisibility.public;

    context.read<UpdateJouneyCubit>().updateJouney(updateDto).then((value) {
      _updateData(value);
      context.read<JouneyCubit>().fetchJouneys(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocListener<FetchJouneyByIdCubit, FetchJouneyByIdState>(
      listener: (context, state) {
        if (state is FetchJouneyByIdSuccessed) {
          _updateData(state.jouney);
        } else if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              backgroundColor: Colors.blue[300],
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _selectImage,
                    ),
                  ),
                ),
              ],
              flexibleSpace: jouney != null
                  ? _sliverAppbar(jouney)
                  : const Center(child: CircularProgressIndicator()),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: SizedBox(
                      height: 1000,
                      child: Form(
                        key: _form,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextField(
                                    maxLines: 1,
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                    ),
                                    child: _jouneyVisibilitySelector(
                                      theme,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            TextField(
                              minLines: 2,
                              maxLines: 3,
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _updateData(jouney);
                                    },
                                    child: Text(
                                      "Reset",
                                      style: theme.textTheme.headline4,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _submit,
                                    child: Text(
                                      "Save",
                                      style: theme.textTheme.headline4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
