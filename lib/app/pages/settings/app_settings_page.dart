import 'package:auto_route/auto_route.dart';
import 'package:demux_app/app/pages/chat/widgets/chat_widget.dart';
import 'package:demux_app/app/pages/chat/widgets/double_slider_widget.dart';
import 'package:demux_app/app/pages/settings/cubit/app_settings_cubit.dart';
import 'package:demux_app/data/models/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';

@RoutePage()
class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  late AppSettingsCubit appSettingsCubit;
  final TextEditingController openAiApiKeyController = TextEditingController();
  final TextEditingController openAiApiEndpointController = TextEditingController();
  final TextEditingController stabilityAiApiKeyController =
      TextEditingController();
  bool showIntroMessages = true;

  @override
  void initState() {
    appSettingsCubit = BlocProvider.of<AppSettingsCubit>(context);
    openAiApiKeyController.text = appSettingsCubit.getOpenAiApiKey();
    openAiApiEndpointController.text = appSettingsCubit.getOpenAiApiEndpoint();
    stabilityAiApiKeyController.text = appSettingsCubit.getStabilityAiApiKey();
    showIntroMessages = appSettingsCubit.showIntroductionMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettings>(
      builder: (context, settings) {
        return Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        obscureText: false,
                        controller: openAiApiEndpointController,
                        decoration:
                            const InputDecoration(labelText: "OpenAI API 端点网址（图像功能目前只支持OpenAI官方端点）"),
                        onChanged: (value) {
                          appSettingsCubit.updateOpenAiApiEndpoint(value);
                        },
                      ),
                    ),
                    if (openAiApiEndpointController.text.isNotEmpty)
                      IconButton(
                          onPressed: () {
                            openAiApiEndpointController.clear();
                            appSettingsCubit.resetOpenAiApiEndpoint();
                          },
                          icon: const Icon(Icons.close))
                  ],
                ),
              ),
              const SizedBox(height: 16),
    // return BlocBuilder<AppSettingsCubit, AppSettings>(
    //   builder: (context, settings) {
    //     return Container(
    //       color: Colors.lightGreen.shade200,
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        obscureText: true,
                        controller: openAiApiKeyController,
                        decoration:
                            const InputDecoration(labelText: "OpenAI API 密钥"),
                        onChanged: (value) {
                          appSettingsCubit.updateOpenAiApiKey(value);
                        },
                      ),
                    ),
                    if (openAiApiKeyController.text.isNotEmpty)
                      IconButton(
                          onPressed: () {
                            openAiApiKeyController.clear();
                            appSettingsCubit.resetOpenAiApiKey();
                          },
                          icon: const Icon(Icons.close))
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        obscureText: true,
                        controller: stabilityAiApiKeyController,
                        decoration:
                            const InputDecoration(labelText: "Stability AI API 密钥（暂不支持调整端点）"),
                        onChanged: (value) {
                          appSettingsCubit.updateStabilityAiApiKey(value);
                        },
                      ),
                    ),
                    if (stabilityAiApiKeyController.text.isNotEmpty)
                      IconButton(
                          onPressed: () {
                            stabilityAiApiKeyController.clear();
                            appSettingsCubit.resetStabilityAiApiKey();
                          },
                          icon: const Icon(Icons.close))
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("显示介绍消息"),
                  value: showIntroMessages,
                  onChanged: (newValue) {
                    setState(() {
                      showIntroMessages = newValue!;
                      appSettingsCubit.toggleShowIntroductionMessages(newValue);
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              DoubleSliderWidget(
                  label: "文本大小",
                  min: 0.5,
                  max: 3,
                  divisions: 25,
                  defaultValue: 1,
                  currentValue: settings.textScaleFactor,
                  onChanged: (value) =>
                      appSettingsCubit.updateTextScaleFactor(value),),
              const SizedBox(height: 16),
              Expanded(
                  child: ListView(
                children: [
                  chatExampleMessageWidget("user", settings.textScaleFactor),
                  chatExampleMessageWidget(
                      "assistant", settings.textScaleFactor),
                ],
              )),
            ],
          ),
        );
      },
    );
  }

  String getExampleUserMessage() {
    return "请介绍一下鸿蒙系统。";
  }

  String getExampleAssistantMessage() {
    return """鸿蒙系统（HarmonyOS）是由华为自主研发的一款分布式操作系统，于2019年8月9日正式发布。
    
    鸿蒙系统的设计初衷是面向万物互联时代，构建一个覆盖多种设备的统一操作系统，主要应用于智能终端设备，
    
    包括智能手机、平板电脑、智能穿戴设备、智能家居设备、车载系统等。""";
  }

  Widget chatExampleMessageWidget(String role, double textScaleFactor) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 8, top: 0, bottom: 8, right: 8),
      // horizontalTitleGap: 0,
      tileColor: getMessageColor(role),
      leading: Column(children: [
        Expanded(
            child: Icon(
          getMessageIcon(role),
          color: Colors.lightGreen,
        )),
        // Expanded(
        //     child: Icon(
        //   Icons.more_horiz,
        //   color: Colors.black,
        // ))
      ]),
      titleAlignment: ListTileTitleAlignment.top,
      title: SelectionArea(
          child: MarkdownBody(
        data: role == "user"
            ? getExampleUserMessage()
            : getExampleAssistantMessage(),
        styleSheet: MarkdownStyleSheet(
            textScaleFactor: textScaleFactor,
            code: TextStyle(
              color: Colors.lightGreen.shade100,
              backgroundColor: Colors.grey.shade800,
            ),
            codeblockDecoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(5))),
      )),
    );
  }
}
