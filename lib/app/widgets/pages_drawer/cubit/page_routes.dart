import 'package:demux_app/domain/constants.dart';

class DemuxPageRoute {
  static DemuxPageRoute getRouteFromPath(String path) {
    switch (path) {
      // OpenAI
      case '/openai-chat-completion':
        return DemuxPageRoute.openAiChatCompletion;
      case '/openai-image-generation':
        return DemuxPageRoute.openAiImageGeneration;
      case '/openai-image-variation':
        return DemuxPageRoute.openAiImageVariation;
      case '/openai-image-edit':
        return DemuxPageRoute.openAiImageEdit;
      
      // Stability AI
      case '/stability-ai-image-generation':
        return DemuxPageRoute.stabilityAiImageGeneration;

      // App
      case '/app-settings':
        return DemuxPageRoute.appSettings;
      default:
        return DemuxPageRoute.openAiChatCompletion;
    }
  }

  // OpenAI
  static const openAiChatCompletion = DemuxPageRoute._(
    path: '/openai-chat-completion',
    pageName: '对话聊天',
    pageEndpoint: OPENAI_CHAT_COMPLETION_ENDPOINT,
    apiReferenceUrl: OPENAI_CHAT_COMPLETION_REFERENCE,
    classification: 'Text to Text',
  );
  static const openAiImageGeneration = DemuxPageRoute._(
    path: '/openai-image-generation',
    pageName: '文生图',
    pageEndpoint: OPENAI_IMAGE_GENERATION_ENDPOINT,
    apiReferenceUrl: OPENAI_IMAGE_GENERATION_REFERENCE,
    classification: 'Text to Image',
  );
  static const openAiImageVariation = DemuxPageRoute._(
    path: '/openai-image-variation',
    pageName: '图像变体',
    pageEndpoint: OPENAI_IMAGE_VARIATION_ENDPOINT,
    apiReferenceUrl: OPENAI_IMAGE_VARIATION_REFERENCE,
    classification: 'Image to Image',
  );
  static const openAiImageEdit = DemuxPageRoute._(
    path: '/openai-image-edit',
    pageName: '图像编辑',
    pageEndpoint: OPENAI_IMAGE_EDIT_ENDPOINT,
    apiReferenceUrl: OPENAI_IMAGE_EDIT_REFERENCE,
    classification: 'Text & Image to Image',
  );
  static const List<DemuxPageRoute> openAiPages = [
    openAiChatCompletion,
    openAiImageGeneration,
    openAiImageVariation,
    openAiImageEdit,
  ];

  // Stability AI
  static const stabilityAiImageGeneration = DemuxPageRoute._(
    path: '/stability-ai-image-generation',
    pageName: '文生图',
    pageEndpoint: STABILITY_AI_TEXT_TO_IMAGE_ENDPOINT,
    apiReferenceUrl: STABILITY_AI_IMAGE_GENERATION_REFERENCE,
    classification: 'Text to Image',
  );
  static const stabilityAiImageEditing = DemuxPageRoute._(
    path: '/stability-ai-image-editing',
    pageName: '图像编辑',
    pageEndpoint: STABILITY_AI_IMAGE_TO_IMAGE_ENDPOINT,
    apiReferenceUrl: STABILITY_AI_IMAGE_GENERATION_REFERENCE,
    classification: 'Text & Image to Image',
  );
  static const stabilityAiImageUpscaling = DemuxPageRoute._(
    path: '/stability-ai-image-upscaling',
    pageName: '图像超分',
    pageEndpoint: STABILITY_AI_IMAGE_UPSCALE_ENDPOINT,
    apiReferenceUrl: STABILITY_AI_IMAGE_GENERATION_REFERENCE,
    classification: 'Image to Image',
  );
  static const stabilityAiImageMasking = DemuxPageRoute._(
    path: '/stability-ai-image-masking',
    pageName: '图像掩码',
    pageEndpoint: STABILITY_AI_IMAGE_MASKING_ENDPOINT,
    apiReferenceUrl: STABILITY_AI_IMAGE_GENERATION_REFERENCE,
    classification: 'Text & Image to Image',
  );
  static const List<DemuxPageRoute> stabilityAiPages = [
    stabilityAiImageGeneration,
    // stabilityAiImageEditing,
    // stabilityAiImageUpscaling,
    // stabilityAiImageMasking,
  ];

  // App
  static const appSettings = DemuxPageRoute._(
    path: '/app-settings',
    pageName: '应用设置',
    pageEndpoint: null,
    apiReferenceUrl: null,
    classification: null,
  );

  final String path;
  final String pageName;
  final String? pageEndpoint;
  final String? apiReferenceUrl;
  final String? classification;

  const DemuxPageRoute._({
    required this.path,
    required this.pageName,
    required this.pageEndpoint,
    required this.apiReferenceUrl,
    required this.classification,
  });
}
