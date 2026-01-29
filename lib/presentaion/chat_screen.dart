import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_chat_application/bloc/api_resp_state.dart';
import 'package:mini_chat_application/bloc/cubit/chat_cubit.dart';
import 'package:mini_chat_application/data/repository/chat_repositary.dart';
import 'package:mini_chat_application/dto/dictionary_dto.dart';
import 'package:mini_chat_application/dto/reciever_response.dart';
import 'package:mini_chat_application/utils/chat_utils.dart';

class ChatScreen extends StatefulWidget {
  final String name;

  const ChatScreen({super.key, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatCubit? chatCubit;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_Message> _messages = [];
  List<Comment> comments = [];
  int _replyIndex = 0;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    chatCubit = ChatCubit(ChatRepository());
    _addWelcomeMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        _Message(
          text: "Hello! Welcome to MySivi. I'm here to chat with you. Feel free to send me a message! 😊",
          isMe: false,
          time: _timeNow(),
        ),
      );
    });
    _scrollToBottom();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _Message(text: text, isMe: true, time: _timeNow()),
      );
      _controller.clear();
      _isTyping = true;
    });
    _scrollToBottom();
    await _fetchReceiverMessage();
  }

  _fetchReceiverMessage() {
    chatCubit?.getComments();
  }


  String _timeNow() {
    final now = TimeOfDay.now();
    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.period == DayPeriod.am ? 'AM' : 'PM';

    return "$hour:$minute $period";
  }

  @override
  void dispose() {
    _scrollController.dispose();
    chatCubit?.close();
    chatCubit = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChatCubit, ResponseState>(
            bloc: chatCubit,
            listener: (context, state) {
              if (state is ResponseStateLoading) {
                  _isTyping = true;
              }
              else if (state is ResponseStateEmpty) {
                  _isTyping = false;
                   Utils.showFlushBar(context: context, message: "No comments found");
              }
              else if (state is ResponseStateNoInternet) {
                  _isTyping = false;
                  Utils.showFlushBar(context: context, message: "No internet connection. Please check your network.");
              }
              else if (state is ResponseStateError) {
                  _isTyping = false;
                  Utils.showFlushBar(context: context, message: "Sorry, couldn't fetch message. Please try again.");
              }
              else if (state is ResponseStateSuccess) {
                var data = state.data as RecieverResponse;

                if (data.comments != null && data.comments!.isNotEmpty) {
                  comments = data.comments!;
                  final reply = comments[_replyIndex % comments.length].body ?? "No message";
                  _replyIndex++;

                  setState(() {
                    _isTyping = false;
                    _messages.add(
                      _Message(
                        text: reply,
                        isMe: false,
                        time: _timeNow(),
                      ),
                    );
                  });
                  _scrollToBottom();
                } else {
                  setState(() {
                    _isTyping = false;
                    Utils.showFlushBar(context: context, message: "No comments received from API.");
                  });
                }
              }
            },
          ),
        ],
        child: Column(
          children: [
            Expanded(child: _buildMessages()),
            if (_isTyping)
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  "Typing...",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple,
            radius: 15,
            child: Text(widget.name[0],
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
              const Text("Online",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (_, index) {
        final msg = _messages[index];
        return _buildBubble(msg.text, msg.isMe, msg.time);
      },
    );
  }

  Widget _buildBubble(String text, bool isSender, String time) {
    return Column(
      crossAxisAlignment:
      isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment:
          isSender ? CrossAxisAlignment.start : CrossAxisAlignment.start,
          children: [
            if (!isSender)
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.purple,
                child: Text(widget.name[0],
                    style: const TextStyle(fontSize: 10, color: Colors.white)),
              ),
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(maxWidth: 260),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: isSender ? Colors.blue[700] : Colors.grey[200],
                  borderRadius: isSender
                      ? const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16))
                      : const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(0))),
              child:_SelectableMessageText(
                text: text,
                isSender: isSender,
                onWordSelected: (DictionaryDto data) {
                  Utils.showBottomSheet(
                    context: context,
                    title: data.word ?? "",
                    subtitle: "${data.partOfSpeech ?? ""}\n\n${data.definition ?? ""}",

                  );
                },
              )

            ),
            if (isSender) const SizedBox(width: 8),
            if (isSender)
              const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.pink,
                child: Text("P", style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 4, bottom: 12),
          child: Text(time,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: CircleAvatar(
              backgroundColor: Colors.blue[800],
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isMe;
  final String time;

  _Message({
    required this.text,
    required this.isMe,
    required this.time,
  });
}


class _SelectableMessageText extends StatefulWidget {
  final String text;
  final bool isSender;
  final void Function(DictionaryDto data) onWordSelected;

  const _SelectableMessageText({
    required this.text,
    required this.isSender,
    required this.onWordSelected,
  });

  @override
  State<_SelectableMessageText> createState() => _SelectableMessageTextState();
}

class _SelectableMessageTextState extends State<_SelectableMessageText> {
  ChatCubit? dictionaryCubit;
  String _selectedText = "";

  @override
  void initState() {
    super.initState();
    dictionaryCubit = ChatCubit(ChatRepository());
  }

  @override
  void dispose() {

    dictionaryCubit?.close();
    dictionaryCubit = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ResponseState>(
      bloc: dictionaryCubit,
      listener: (context, state) {
        if (state is ResponseStateLoading) {}
        else if (state is ResponseStateEmpty) {
          Utils.showFlushBar(
            context: context,
            message: "No meaning found",
          );
        }
        else if (state is ResponseStateNoInternet) {
          Utils.showFlushBar(
            context: context,
            message: "No internet connection",
          );
        }

        else if (state is ResponseStateError) {
          Utils.showFlushBar(
            context: context,
            message: "Something went wrong",
          );
        }
        else if (state is ResponseStateSuccess) {
          final DictionaryDto data = state.data as DictionaryDto;
           widget.onWordSelected(data);
        }
      },

      child: SelectableText(
        widget.text,
        style: TextStyle(
          color: widget.isSender ? Colors.white : Colors.black87,
          fontSize: 14,
        ),

        onSelectionChanged: (selection, cause) {
          if (selection.start != selection.end) {
            _selectedText = widget.text.substring(selection.start, selection.end).trim();
          }
        },

        contextMenuBuilder: (context, editableTextState) {
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: [
              ContextMenuButtonItem(
                label: "Meaning",
                onPressed: () {
                  if (_selectedText.isEmpty) return;
                  final request = {"word": _selectedText};
                  dictionaryCubit?.getDictionary(request);
                  editableTextState.hideToolbar();
                },
              ),

              ...editableTextState.contextMenuButtonItems,
            ],
          );
        },
      ),
    );
  }
}
