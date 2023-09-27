import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class MyOpenChannelHandler extends OpenChannelHandler {
  // Add this class through
  // SendbirdChat.addChannelHandler('UNIQUE_HANDLER_ID', this).

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    print(message);
  }
}
