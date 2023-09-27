class Message {
  String message;
  String sentBy;

  Message({required this.message, required this.sentBy});
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(message: json["message"], sentBy: json["sentBy"]);
  }
}
