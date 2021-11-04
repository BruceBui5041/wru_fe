import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wru_fe/cubit/journey/journey_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/update_journey.dto.dart';
import 'package:wru_fe/enums.dart';
import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/custom_cached_image.widget.dart';

class JourneyDetailScreen extends StatefulWidget {
  JourneyDetailScreen({Key? key, this.journeyId}) : super(key: key);
  static const routeName = "/journey-details-screen";
  String? journeyId;

  @override
  _JourneyDetailScreenState createState() => _JourneyDetailScreenState();
}

class _JourneyDetailScreenState extends State<JourneyDetailScreen> {
  Journey? journey;
  static String visibilityValue = 'Public';
  String? localImagePath;
  String? uploadedFileName;

  static final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    context.read<FetchJourneyByIdCubit>().fetchJourneyById(
          widget.journeyId.toString(),
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

  FlexibleSpaceBar _sliverAppbar(Journey? journey) {
    return FlexibleSpaceBar(
      title: Text(journey?.name ?? ""),
      centerTitle: true,
      background: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [
              Colors.black54,
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
            : CustomCachedImage(imageUrl: journey!.image),
      ),
    );
  }

  Widget _journeyVisibilitySelector(ThemeData theme) {
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

  void _updateData(Journey? newJourney) {
    _nameController.text = newJourney?.name ?? "";
    _descriptionController.text = newJourney?.description ?? "";

    setState(() {
      journey = newJourney;

      visibilityValue = newJourney?.visibility == JourneyVisibility.private
          ? "Private"
          : "Public";
      uploadedFileName = newJourney?.imageName;
    });
  }

  void _submit() {
    var updateDto = UpdateJourneyDto(journeyId: journey!.uuid.toString());
    updateDto.name = _nameController.text;
    updateDto.description = _descriptionController.text;
    updateDto.image = uploadedFileName;
    updateDto.visibility = visibilityValue == "Private"
        ? JourneyVisibility.private
        : JourneyVisibility.public;

    context.read<UpdateJourneyCubit>().updateJourney(updateDto).then((value) {
      _updateData(value);
      context.read<JourneyCubit>().fetchJourneys(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocListener<FetchJourneyByIdCubit, FetchJourneyByIdState>(
      listener: (context, state) {
        if (state is FetchJourneyByIdSuccessed) {
          _updateData(state.journey);
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
              flexibleSpace: journey != null
                  ? _sliverAppbar(journey)
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
                                    child: _journeyVisibilitySelector(
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
                                      _updateData(journey);
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
