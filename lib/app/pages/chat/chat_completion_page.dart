import 'package:auto_route/auto_route.dart';
import 'package:demux_app/app/pages/chat/cubit/chat_completion_cubit.dart';
import 'package:demux_app/app/pages/chat/cubit/chat_completion_states.dart';
import 'package:demux_app/app/pages/chat/widgets/chat_widget.dart';
import 'package:demux_app/app/pages/chat/widgets/chat_settings_widget.dart';
import 'package:demux_app/app/pages/settings/cubit/app_settings_cubit.dart';
import 'package:demux_app/app/widgets/introduction_cta.dart';
import 'package:demux_app/data/models/app_settings.dart';
import 'package:demux_app/data/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChatCompletionPage extends StatefulWidget {
  const ChatCompletionPage({super.key});

  @override
  State<ChatCompletionPage> createState() => _ChatCompletionPageState();
}

class _ChatCompletionPageState extends State<ChatCompletionPage>
    with SingleTickerProviderStateMixin {
  late AppSettingsCubit appSettingsCubit;
  late ChatCompletionCubit chatCompletionCubit;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<Chat> chats = [];
  List<Chat> selectedChats = [];
  Chat currentChat = Chat.initial();

  bool _showCheckbox = false;

  TextEditingController chatRenameController = TextEditingController();
  Chat? chatBeingRenamed;

  @override
  void initState() {
    appSettingsCubit = BlocProvider.of<AppSettingsCubit>(context);
    chatCompletionCubit = BlocProvider.of<ChatCompletionCubit>(context);
    chatCompletionCubit.setApiKey(appSettingsCubit.getOpenAiApiKey());
    chatCompletionCubit.setApiEndpoint(appSettingsCubit.getOpenAiApiEndpoint());

    updateChatsFromState(chatCompletionCubit.state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        endDrawer: BlocListener<ChatCompletionCubit, ChatCompletionState>(
          listenWhen: (previous, current) =>
              !(previous is ChatCompletionMessagesSaved &&
                  current is ChatCompletionMessagesSaved),
          listener: (context, state) {
            updateChatsFromState(state);
          },
          child: getChatListDrawer(context),
        ),
        onEndDrawerChanged: (isOpened) {
          setState(() {});
          if (!isOpened) {
            setState(() {
              _showCheckbox = false;
              selectedChats.clear();
            });
            finishEditingChatName();
          }
        },
        backgroundColor: Colors.transparent,
        body: DefaultTabController(
            length: 2,
            child: Column(children: [
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                      child: Row(children: [
                        const Expanded(
                            child: TabBar(
                          indicatorPadding: EdgeInsets.all(3),
                          dividerColor: Colors.lightGreen,
                          labelColor: Colors.white,
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            Tab(
                              text: "聊天",
                            ),
                            Tab(
                              text: "对话设置",
                            )
                          ],
                        )),
                        getChatListIconButton()
                      ]))),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                    BlocBuilder<AppSettingsCubit, AppSettings>(
                        builder: (context, state) {
                      return Stack(
                        children: [
                          const ChatWidget(),
                          if (appSettingsCubit.showIntroductionMessages() &&
                              appSettingsCubit.openAiApiKeyIsMissing())
                            const IntrodutionCTAWidget(),
                        ],
                      );
                    }),

                    // ChatWidget(),
                    const ChatSettingsWidget(),
                  ])),
            ])));
  }

  Widget getChatListIconButton() {
    return IconButton(
        onPressed: () {
          scaffoldKey.currentState!.openEndDrawer();
        },
        icon: const Icon(
          Icons.chat,
          color: Colors.white,
        ));
  }

  Drawer getChatListDrawer(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Container(
          color: Colors.white,
          child: _showCheckbox
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Expanded(
                          child: Center(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  chatCompletionCubit
                                      .deleteMultipleChats(selectedChats);
                                  setState(() {
                                    selectedChats.clear();
                                    _showCheckbox = false;
                                  });
                                },
                                child: const Text("删除")),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedChats.clear();
                                    _showCheckbox = false;
                                  });
                                },
                                child: const Text("取消")),
                          ]))),
                      Checkbox(
                          value: selectedChats.length == chats.length,
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedChats.clear();
                                selectedChats.addAll(chats);
                              } else {
                                selectedChats.clear();
                              }
                            });
                          }),
                    ])
              : Center(
                  child: TextButton(
                      onPressed: () {
                        chatCompletionCubit.createNewChat();
                        setState(() {});
                      },
                      child: const Text("新对话"))),
        ),
        // Expanded(
        //     child: ListView.builder(
        //   padding: EdgeInsets.zero,
        //   itemCount: chats.length,
        //   itemBuilder: getChatListItem,
        // )),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children:
                chats.map((chat) => getChatListItem(context, chat)).toList(),
          ),
        ))
      ]),
    );
  }

  void updateChatsFromState(ChatCompletionState state) {
    setState(() {
      chats = state.chats;
      currentChat = state.currentChat;
    });
  }

  Widget getChatListItem(BuildContext context, Chat chat) {
    bool isCurrent = chat == currentChat;
    GlobalKey expansionTileKey = GlobalKey();
    GlobalKey listTileKey = GlobalKey();
    GlobalKey gestureDetectorKey = GlobalKey();
    return GestureDetector(
        key: gestureDetectorKey,
        onLongPress: () {
          setState(() {
            _showCheckbox = !_showCheckbox;
          });
          if (_showCheckbox) {
            selectedChats.add(chat);
          } else {
            selectedChats.clear();
          }
        },
        child: _showCheckbox
            ? getChatListItemListTile(listTileKey, isCurrent, chat)
            : getChatListItemExpansionTile(
                expansionTileKey, listTileKey, isCurrent, chat));
  }

  Widget getChatListItemListTile(
      GlobalKey listTileKey, bool isCurrent, Chat chat) {
    return ListTile(
      key: listTileKey,
      selectedColor: Colors.white,
      selectedTileColor: Colors.lightGreen,
      contentPadding: const EdgeInsets.only(left: 8),
      trailing: Checkbox(
        value: selectedChats.contains(chat),
        onChanged: (value) {
          setState(() {
            if (value!) {
              selectedChats.add(chat);
            } else {
              selectedChats.remove(chat);
            }
          });
        },
      ),
      onTap: () {
        setState(() {
          bool chatIsSelected = selectedChats.contains(chat);
          if (chatIsSelected) {
            selectedChats.remove(chat);
          } else {
            selectedChats.add(chat);
          }
        });
      },
      title: Text(
        chat.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        chat.lastUpdated.toLocal().timeAgo(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      selected: isCurrent,
    );
  }

  Widget getChatListItemExpansionTile(GlobalKey expansionTileKey,
      GlobalKey listTileKey, bool isCurrent, Chat chat) {
    return ExpansionTile(
      key: expansionTileKey,
      collapsedTextColor: isCurrent ? Colors.white : Colors.black,
      collapsedIconColor: isCurrent ? Colors.white : Colors.black,
      collapsedBackgroundColor: isCurrent ? Colors.lightGreen : Colors.white,
      textColor: isCurrent ? Colors.white : Colors.black,
      iconColor: isCurrent ? Colors.white : Colors.black,
      backgroundColor: isCurrent ? Colors.lightGreen : Colors.white,
      tilePadding: const EdgeInsets.only(right: 8),
      title: ListTile(
        key: listTileKey,
        selectedColor: Colors.white,
        selectedTileColor: Colors.lightGreen,
        title: chatBeingRenamed == chat
            ? getChatRenameField(chat)
            : Text(
                chat.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        subtitle: Text(
          chat.lastUpdated.toLocal().timeAgo(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        selected: isCurrent,
        onTap: isCurrent
            ? null
            : () {
                chatCompletionCubit.selectChat(chat);
                Navigator.of(context).pop();
              },
      ),
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    onPressed: () {
                      chatCompletionCubit.deleteChat(chat);
                    },
                    child: const Text("删除")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        chatRenameController.text = chat.name;
                        chatBeingRenamed = chat;
                      });
                    },
                    child: const Text("重命名")),
              ],
            ))
      ],
    );
  }

  void finishEditingChatName() {
    setState(() {
      chatRenameController.text = "";
      chatBeingRenamed = null;
    });
  }

  Widget getChatRenameField(Chat chat) {
    return TextField(
      controller: chatRenameController,
      maxLength: 100,
      maxLines: 1,
      textCapitalization: TextCapitalization.sentences,
      onEditingComplete: () {
        chatCompletionCubit.renameChat(chat, chatRenameController.text);
        setState(() {
          chatRenameController.text = "";
          chatBeingRenamed = null;
        });
      },
      cursorColor: currentChat == chat ? Colors.white : Colors.black,
      style: TextStyle(
        color: currentChat == chat ? Colors.white : Colors.black,
      ),
    );
  }
}
