import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_test/chat_app_nodejs.dart';
import 'package:sendbird_test/chat_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SendbirdChat.init(appId: 'DCD5F067-8067-49BF-954E-CEB3631B555F');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'skibidi',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late OpenChannel openChannel;
  late GroupChannel groupChannel;
  final chatHandler = MyOpenChannelHandler();
  List<BaseMessage> messages = [];
  late BaseMessage pesan;

  void _enterChannel() async {
    SendbirdChat.addChannelHandler('handlerid', chatHandler);
    try {
      // openChannel = await OpenChannel.getChannel(
      //     'sendbird_open_channel_14964_a4d0fc0c400470a6202b7db4fe7db02ba631281d');
      // // Call the instance method of the result object in the openChannel parameter of the callback method.
      // await openChannel.enter();
      // The current user successfully enters the open channel as a participant,
      // and can chat with other users in the channel using APIs.
      groupChannel = await GroupChannel.getChannel(
          'sendbird_group_channel_404867426_39df991ff7c2dae3b9e9a347ce6bcdaf6adce067');
      // Call the instance method of the result object in the openChannel parameter of the callback method.
      await openChannel.enter();
    } catch (e) {
      // Handle error.
    }
  }

  void sendMessage() {
    try {
      final params = UserMessageCreateParams(message: 'pesan')
        ..data = 'DATA'
        ..customType = 'CUSTOM_TYPE';
      // openChannel.chat.getMessageQueue(
      //     'sendbird_open_channel_14964_a4d0fc0c400470a6202b7db4fe7db02ba631281d');
      // pesan = openChannel.sendUserMessage(params, handler: (pesan, e) {
      //   // The message is successfully sent to the channel.
      //   // The current user can receive messages from other users
      //   // through the onMessageReceived() method in event handlers.
      //   print(pesan.messageId);
      // });
      groupChannel.chat.getMessageQueue(
          'sendbird_group_channel_404867426_39df991ff7c2dae3b9e9a347ce6bcdaf6adce067');
      pesan = groupChannel.sendUserMessage(params, handler: (pesan, e) {
        // The message is successfully sent to the channel.
        // The current user can receive messages from other users
        // through the onMessageReceived() method in event handlers.
        print(pesan.messageId);
      });
    } catch (e) {
      print(e);
      // Handle error.
    }
  }

  void receiveMessage() async {
    messages = await openChannel.getMessagesByTimestamp(
        DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
    // chatHandler.onMessageReceived(openChannel, message);
    messages.forEach((element) {
      print(element.message);
    });
  }

//   void _receiveMessage() async {
//     try {
//   // Create a MessageRetrievalParams object.
//   final params = MessageRetrievalParams(
//     channelType: ChannelType.open,
//     channelUrl: 'CHANNEL_URL',
//     messageId: MESSAGE_ID,
//   );

//   // Pass the params to the parameter of the getMessage() method.
//   final message = await BaseMessage.getMessage(params);
//   // The specified message is successfully retrieved.
// } catch (e) {
//   // Handle error.
// }
//   }

  @override
  void initState() {
    runZonedGuarded(() async {
      // USER_ID should be a unique string to your Sendbird application.
      final user = await SendbirdChat.connect('akmal');
      // The user is connected to the Sendbird server.
      print(user);
    }, (e, s) {
      // Handle error.
      print(e);
    });
    super.initState();
  }

  void _createOpenChannel() async {
    try {
      // final openChannel =
      //     await OpenChannel.createChannel(OpenChannelCreateParams());
      final groupChannel = await GroupChannel.createChannel(
          GroupChannelCreateParams()..userIds = ['akmal', '795526']);

      // An open channel is successfully created.
      // You can get the open channel's data from the result object.
    } catch (e) {
      // Handle error.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                _enterChannel();
              },
              child: Container(
                color: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  'enter channel',
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                sendMessage();
              },
              child: Container(
                color: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  'send message',
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: receiveMessage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
