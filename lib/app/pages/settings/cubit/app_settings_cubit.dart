/*
 * @Author: 
 * @Date: 2024-12-22 18:25:30
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2024-12-22 18:56:42
 * @Description: file content
 */
import 'package:demux_app/data/models/app_settings.dart';
import 'package:demux_app/domain/constants.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AppSettingsCubit extends HydratedCubit<AppSettings> {
  AppSettingsCubit() : super(AppSettings());

  void updateDarkMode(bool isDarkMode) {
    AppSettings newState = state.copyWith(isDarkMode: isDarkMode);
    emit(newState);
  }

  void updateTextScaleFactor(double textScaleFactor) {
    AppSettings newState = state.copyWith(textScaleFactor: textScaleFactor);
    emit(newState);
  }

  void updateOpenAiApiKey(String apiKey) {
    AppSettings newState = state.copyWith(openAiApiKey: apiKey);
    emit(newState);
  }

  void updateOpenAiApiEndpoint(String apiEndpoint) {
    AppSettings newState = state.copyWith(openAiApiEndpoint: apiEndpoint);
    emit(newState);
  }

  void updateStabilityAiApiKey(String apiKey) {
    AppSettings newState = state.copyWith(stabilityAiApiKey: apiKey);
    emit(newState);
  }

  void resetTextScaleFactor() {
    AppSettings newState = state.copyWith(textScaleFactor: DEFAULT_TEXT_SCALE_FACTOR);
    emit(newState);
  }

  void resetOpenAiApiKey() {
    AppSettings newState = state.copyWith(openAiApiKey: "");
    emit(newState);
  }

  void resetOpenAiApiEndpoint() {
    AppSettings newState = state.copyWith(openAiApiEndpoint: "");
    emit(newState);
  }

  void resetStabilityAiApiKey() {
    AppSettings newState = state.copyWith(stabilityAiApiKey: "");
    emit(newState);
  }

  void toggleShowIntroductionMessages(bool value) {
    AppSettings newState = state.copyWith(showIntroductionMessages: value);
    emit(newState);
  }

  bool showIntroductionMessages() {
    return (state.showIntroductionMessages);
  }

  String getOpenAiApiKey() {
    return state.openAiApiKey;
  }

  String getOpenAiApiEndpoint() {
    return state.openAiApiEndpoint;
  }

  String getStabilityAiApiKey() {
    return state.stabilityAiApiKey;
  }

  bool openAiApiKeyIsMissing() {
    return state.openAiApiKey.isEmpty;
  }

  bool openAiApiEndpointIsMissing() {
    return state.openAiApiEndpoint.isEmpty;
  }

  bool stabilityAiApiKeyIsMissing() {
    return state.stabilityAiApiKey.isEmpty;
  }

  double getTextScaleFactor() {
    return state.textScaleFactor;
  }

  @override
  AppSettings? fromJson(Map<String, dynamic> json) {
    return AppSettings.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppSettings state) {
    return state.toJson();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print(error);
    super.onError(error, stackTrace);
  }
}
