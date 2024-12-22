/*
 * @Author: 
 * @Date: 2024-12-22 20:37:20
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2024-12-22 21:38:04
 * @Description: file content
 */
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ??
          DEFAULT_TEXT_SCALE_FACTOR,
      openAiApiKey: json['openAiApiKey'] as String? ?? '',
      openAiApiEndpoint: json['openAiApiEndpoint'] as String? ?? 'https://api.openai.com/',
      stabilityAiApiKey: json['stabilityAiApiKey'] as String? ?? '',
      showIntroductionMessages:
          json['showIntroductionMessages'] as bool? ?? true,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'isDarkMode': instance.isDarkMode,
      'textScaleFactor': instance.textScaleFactor,
      'openAiApiKey': instance.openAiApiKey,
      'openAiApiEndpoint': instance.openAiApiEndpoint,
      'stabilityAiApiKey': instance.stabilityAiApiKey,
      'showIntroductionMessages': instance.showIntroductionMessages,
    };
