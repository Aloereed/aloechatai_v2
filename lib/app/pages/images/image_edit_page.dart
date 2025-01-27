import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:demux_app/app/pages/images/cubit/image_api_cubit.dart';
import 'package:demux_app/app/pages/settings/cubit/app_settings_cubit.dart';
import 'package:demux_app/domain/constants.dart';
import 'package:demux_app/app/pages/images/utils/image_processing.dart';
import 'package:demux_app/app/pages/images/widgets/edit_area_painter.dart';
import 'package:demux_app/app/pages/images/widgets/image_api_settings.dart';
import 'package:demux_app/app/pages/images/widgets/image_results_widget.dart';
import 'package:demux_app/app/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class ImageEditPage extends StatefulWidget {
  const ImageEditPage({super.key});

  @override
  State<ImageEditPage> createState() => _ImageEditPageState();
}

class _ImageEditPageState extends State<ImageEditPage> {
  final TextEditingController imageQuantityController =
      TextEditingController(text: "1");
  final TextEditingController descriptionController = TextEditingController();
  late String selectedImageSize = OPENAI_IMAGE_SIZE_LIST.first;

  Uint8List? selectedImage;
  Uint8List? mask;
  EditAreaPainter editAreaPainter = EditAreaPainter();

  bool loadingResults = false;
  bool loadingSelectedImage = false;

  List<String> imageUrls = [];

  EditImageApiCubit imageResultsCubit = EditImageApiCubit();
  late AppSettingsCubit appSettingsCubit;

  @override
  void initState() {
    appSettingsCubit = BlocProvider.of<AppSettingsCubit>(context);
    imageResultsCubit.setOpenAiApiKey(appSettingsCubit.getOpenAiApiKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        getImageEditAPISettings(
          loadingResults: loadingResults,
          loadingSelectedImage: loadingSelectedImage,
          selectedImageSize: selectedImageSize,
          sendButtonText: "生成图像编辑",
          selectedImage: selectedImage,
          editAreaPainter: editAreaPainter,
          sendButtonEnabled: selectedImage != null && !loadingSelectedImage,
          imageQuantityController: imageQuantityController,
          descriptionController: descriptionController,
          imageSizeOnChanged: imageSizeOnChanged,
          galleryOnPressed: galleryOnPressed,
          cameraOnPressed: cameraOnPressed,
          sendButtonOnPressed: getImageEdits,
          removeSelectedImage: removeSelectedImage,
        ),
        ImageResultsWidget(imageResultsCubit),
      ],
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    imageQuantityController.dispose();
    super.dispose();
  }

  void removeSelectedImage() {
    setState(() {
      selectedImage = null;
    });
  }

  void imageSizeOnChanged(String? value) {
    setState(() {
      selectedImageSize = value!;
    });
  }

  void galleryOnPressed() {
    selectImage(ImageSource.gallery);
  }

  void cameraOnPressed() {
    selectImage(ImageSource.camera);
  }

  void selectImage(ImageSource source) async {
    setState(() {
      loadingSelectedImage = true;
    });

    try {
      XFile? imageFile = await pickImage(source);

      if (imageFile != null) {
        Uint8List pngBytes = await processImageFile(imageFile);
        await editAreaPainter.updateImage(pngBytes);

        setState(() {
          selectedImage = pngBytes;
        });
      }
    } catch (e) {
      showSnackbar(e.toString(), context,
          criticality: MessageCriticality.error);
    }

    setState(() {
      loadingSelectedImage = false;
    });
  }

  void getImageEdits() async {
    setState(() {
      loadingResults = true;
    });

    if (selectedImage == null) {
      showSnackbar("No image selected", context,
          criticality: MessageCriticality.warning);
      setState(() {
        loadingResults = false;
      });
      return;
    }

    String description = descriptionController.text;

    late int quantity;
    try {
      quantity = int.parse(imageQuantityController.text);
    } catch (e) {
      showSnackbar("Invalid quantity", context,
          criticality: MessageCriticality.warning);
      setState(() {
        loadingResults = false;
      });
      return;
    }

    try {
      mask = await editAreaPainter.exportMask();
    } catch (e) {
      showSnackbar("Unable to obtain mask", context,
          criticality: MessageCriticality.warning);
      setState(() {
        loadingResults = false;
      });
      return;
    }

    setState(() {});

    try {
      await imageResultsCubit.getImageEdits(
        image: selectedImage!,
        mask: mask!,
        prompt: description,
        quantity: quantity,
        size: selectedImageSize,
      );

      setState(() {});
    } catch (e) {
      showSnackbar(e.toString(), context,
          criticality: MessageCriticality.error);
    }
    setState(() {
      loadingResults = false;
    });
  }
}
