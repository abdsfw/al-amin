import 'package:alaminedu/core/utils/color_app.dart';
import 'package:alaminedu/core/utils/styles.dart';
import 'package:alaminedu/features/inbox/presentation/data/send_api.dart';
import 'package:flutter/material.dart';

import '../data/amdin_api.dart';
import '../data/message_api.dart';
import '../data/message_model.dart';
import '../data/teatcher_message.dart';

class ChatScreen extends StatefulWidget {
  final int selectedTeacher;
  final String nameT;

  const ChatScreen(
      {super.key, required this.selectedTeacher, required this.nameT});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> _chatMessages = [];
  // Store chat messages here
  List<Message> allmessage = [];
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //! Fetch teacher replies when the chat screen is first opened and scrol it to down
    _fetchTeacherReplies();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _fetchTeacherReplies() async {
    try {
      final chatMessages =
          await MessageApi.fetchMessages(widget.selectedTeacher);
      setState(() {
        _chatMessages = chatMessages;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.kPrimaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  maxRadius: 20,
                  child: Icon(
                    Icons.person,
                    color: AppColor.kPrimaryColor,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.nameT,
                        style: Styles.textStyle18White,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            _chatMessages.isEmpty
                ? Center(
                    child: Text(
                      "no messages",
                      style: Styles.textStyle18grey,
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _chatMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChatMessage(
                          text: _chatMessages[index].message,
                          isUserMessage: true,
                          mangerId: widget.selectedTeacher,
                          sender_id: _chatMessages[index].senderId,
                        ); // Display chat messages
                      },
                    ),
                  ),
            _buildMessageInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your message...',
                  hintStyle: Styles.textStyle14),
            ),
          ),
          IconButton(
            icon: _isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Sending...',
                      style: Styles.textStyle14.copyWith(
                          color: AppColor
                              .kPrimaryColor), // Customize the text style
                    ),
                  )
                : const Icon(
                    Icons.send,
                    size: 18,
                    color: AppColor.kPrimaryColor,
                  ),
            onPressed: _isLoading
                ? null
                : () async {
                    final messageText = _messageController.text;
                    if (messageText.trim().isNotEmpty) {
                      setState(() {
                        _isLoading = true; // Set loading state to true
                      });

                      try {
                        final response = await SendMessageApi.sendMessage(
                            messageText, widget.selectedTeacher);

                        if (response.statusCode == 200) {
                          setState(() {
                            _chatMessages.add(Message(
                              message: messageText,
                              receiverId: widget.selectedTeacher,
                              senderId: -100,

                              // text: messageText,
                              // isUserMessage: true,
                              // mangerId: 1,
                              // sender_id: 2,
                            ));
                            //! Scroll to the bottom when a new message is added
                            _messageController.clear();
                            _isLoading = false; // Set loading state to false
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to send message: ${response.reasonPhrase}'),
                            ),
                          );
                          setState(() {
                            _isLoading = false; // Set loading state to false
                          });
                        }
                      } catch (e) {
                        setState(() {
                          _isLoading = false; // Set loading state to false
                        });
                        // Handle exceptions, such as network errors or timeouts
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final int mangerId;
  final int sender_id;

  ChatMessage(
      {required this.text,
      required this.isUserMessage,
      required this.mangerId,
      required this.sender_id});
  bool isFromManger() {
    if (mangerId == sender_id) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isFromManger() ? Alignment.centerLeft : Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ChatBubble(
        textMessage: text,
        isUserMessage: isUserMessage,
        mangerId: mangerId,
        sender_id: sender_id,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String textMessage;

  final bool isUserMessage;
  final int mangerId;
  final int sender_id;

  ChatBubble(
      {required this.textMessage,
      required this.isUserMessage,
      required this.mangerId,
      required this.sender_id});
  bool isFromManger() {
    if (mangerId == sender_id) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isFromManger() ? AppColor.kPrimaryColor : Colors.grey,
      ),
      child: Text(
        textMessage,
        style: Styles.textStyle14White,
      ),
    );
  }
}
