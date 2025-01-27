/*
 * @Author: 
 * @Date: 2024-12-22 18:25:30
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2024-12-22 18:54:41
 * @Description: file content
 */
import 'package:demux_app/domain/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

@JsonSerializable()
class AppSettings {
  bool isDarkMode;
  double textScaleFactor;
  String openAiApiKey;
  String openAiApiEndpoint;
  String stabilityAiApiKey;
  bool showIntroductionMessages;

  AppSettings({
    this.isDarkMode = false,
    this.textScaleFactor = DEFAULT_TEXT_SCALE_FACTOR,
    this.openAiApiKey = '',
    this.openAiApiEndpoint = 'https://api.openai.com/',
    this.stabilityAiApiKey = '',
    this.showIntroductionMessages = true,
  });

  copyWith({
    bool? isDarkMode,
    double? textScaleFactor,
    String? openAiApiKey,
    String? openAiApiEndpoint,
    String? stabilityAiApiKey,
    bool? showIntroductionMessages,
  }) {
    return AppSettings(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        openAiApiKey: openAiApiKey ?? this.openAiApiKey,
        openAiApiEndpoint: openAiApiEndpoint ?? this.openAiApiEndpoint,
        stabilityAiApiKey: stabilityAiApiKey ?? this.stabilityAiApiKey,
        showIntroductionMessages:
            showIntroductionMessages ?? this.showIntroductionMessages);
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

List<Map<String, dynamic>> appSettingsListToJson(List<AppSettings> settings) {
  return settings.map((setting) => setting.toJson()).toList();
}

List<AppSettings> jsonToAppSettingsList(List<dynamic> settingsJson) {
  return settingsJson
      .map((settingJson) => AppSettings.fromJson(settingJson))
      .toList();
}
