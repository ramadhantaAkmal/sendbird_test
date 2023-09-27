import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_test/chat_getx_controller.dart';
import 'package:sendbird_test/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatNode extends StatefulWidget {
  const ChatNode({super.key});

  @override
  State<ChatNode> createState() => _ChatNodeState();
}

class _ChatNodeState extends State<ChatNode> {
  Color blue = Colors.blue.shade300;
  Color black = const Color(0xFF191919);
  TextEditingController msgInputController = TextEditingController();
  ChatController chatController = ChatController();
  late IO.Socket socket;

  @override
  void initState() {
    socket = IO.io(
        'http://localhost:4000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
    setUpSocketListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: _widgetBuildBody(context),
    );
  }

  Widget _widgetBuildBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: Obx(
            () => Text(
              "Connected User ${chatController.connectedUser}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          )),
          Expanded(
              flex: 9,
              child: Obx(
                () => ListView.builder(
                  itemCount: chatController.chatMessages.length,
                  itemBuilder: ((context, index) {
                    var currentItem = chatController.chatMessages[index];
                    return ChatBubble(
                      sentBy: currentItem.sentBy == socket.id,
                      message: currentItem.message,
                    );
                  }),
                ),
              )),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: msgInputController,
                cursorColor: blue,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: blue,
                    ),
                    child: IconButton(
                      onPressed: () {
                        sendMessage(msgInputController.text);
                        msgInputController.text = "";
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String text) {
    var messageJson = {"message": text, "sentBy": socket.id};
    chatController.chatMessages.add(Message.fromJson(messageJson));
    socket.emit('message', messageJson);
  }

  void setUpSocketListener() {
    socket.on('message-received', (data) {
      print(data);
      chatController.chatMessages.add(Message.fromJson(data));
    });
    socket.on('connected-user', (data) {
      print(data);
      chatController.connectedUser.value = data;
    });
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.sentBy, required this.message});
  final bool sentBy;
  final String message;

  @override
  Widget build(BuildContext context) {
    Color blue = Colors.blue.shade800;
    Color black = const Color(0xFF191919);
    return Align(
      alignment: sentBy ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        // color: sentBy ? blue : Colors.red,
        decoration: BoxDecoration(
          color: sentBy ? blue : Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          textBaseline: TextBaseline.alphabetic,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style:
                  TextStyle(color: sentBy ? Colors.white : blue, fontSize: 18),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "1:10 AM",
              style: TextStyle(
                color: (sentBy ? Colors.white : blue).withOpacity(0.7),
                fontSize: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
