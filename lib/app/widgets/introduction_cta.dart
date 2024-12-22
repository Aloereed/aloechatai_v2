import 'package:demux_app/app/pages/settings/cubit/app_settings_cubit.dart';
import 'package:demux_app/app/widgets/pages_drawer/cubit/api_pages_cubit.dart';
import 'package:demux_app/app/widgets/pages_drawer/cubit/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntrodutionCTAWidget extends StatelessWidget {
  const IntrodutionCTAWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ApiPagesCubit pagesDrawerCubit =
        BlocProvider.of<ApiPagesCubit>(context);
    AppSettingsCubit appSettingsCubit =
        BlocProvider.of<AppSettingsCubit>(context);
    return Container(
      color: Colors.black54,
      child: Stack(
        children: [
          // Close button
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                appSettingsCubit.toggleShowIntroductionMessages(false);
              },
            ),
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '欢迎使用 AloeChat.AI!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "在设置页面设置您的 OpenAI-兼容 API 端点和密钥，然后就可以开始使用我们的应用了。",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    pagesDrawerCubit.navigateTo(DemuxPageRoute.appSettings);
                  },
                  child: const Text('应用设置'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
