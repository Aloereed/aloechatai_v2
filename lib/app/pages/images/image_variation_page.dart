import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:demux_app/app/pages/images/cubit/image_api_cubit.dart';
import 'package:demux_app/app/pages/settings/cubit/app_settings_cubit.dart';
import 'package:demux_app/domain/constants.dart';
import 'package:demux_app/app/pages/images/utils/image_processing.dart';
import 'package:demux_app/app/pages/images/widgets/image_api_settings.dart';
import 'package:demux_app/app/pages/images/widgets/image_results_widget.dart';
import 'package:demux_app/app/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class ImageVariationPage extends StatefulWidget {
  const ImageVariationPage({super.key});

  @override
  State<ImageVariationPage> createState() => _ImageVariationPageState();
}

class _ImageVariationPageState extends State<ImageVariationPage> {
  final TextEditingController imageQuantityController =
      TextEditingController(text: "1");
  List<String> imageSizeList = OPENAI_IMAGE_SIZE_LIST;
  late String selectedImageSize = imageSizeList.first;

  Uint8List? selectedImage;

  bool loadingResults = false;
  bool loadingSelectedImage = false;

  List<String> imageUrls = [];

  VariationImageApiCubit imageResultsCubit = VariationImageApiCubit();
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
        getImageVariationAPISettings(
            loadingResults: loadingResults,
            loadingSelectedImage: loadingSelectedImage,
            selectedImageSize: selectedImageSize,
            sendButtonText: "生成图像变体",
            sendButtonEnabled: selectedImage != null && !loadingSelectedImage,
            selectedImage: selectedImage,
            imageQuantityController: imageQuantityController,
            imageSizeOnChanged: imageSizeOnChanged,
            galleryOnPressed: galleryOnPressed,
            cameraOnPressed: cameraOnPressed,
            sendButtonOnPressed: getImageVariations,
            closeButtonOnPressed: closeButtonOnPressed),
        ImageResultsWidget(imageResultsCubit),
      ],
    );
  }

  @override
  void dispose() {
    imageQuantityController.dispose();
    super.dispose();
  }

  void closeButtonOnPressed() {
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

  void getImageVariations() async {
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
      await imageResultsCubit.getImageVariations(
        image: selectedImage!,
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
