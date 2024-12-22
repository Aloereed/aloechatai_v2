/*
 * @Author: 
 * @Date: 2024-12-22 18:25:30
 * @LastEditors: 
 * @LastEditTime: 2024-12-22 21:35:06
 * @Description: file content
 */
import 'package:demux_app/app/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> copyMessage(BuildContext context, String message) async {
  try {
    await Clipboard.setData(ClipboardData(text: message));
    showSnackbar('复制成功', context);
  } catch (e) {
    showSnackbar('复制失败', context,
        criticality: MessageCriticality.error);
  }
}
