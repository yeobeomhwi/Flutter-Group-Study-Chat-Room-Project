class Message {
  // int message_id;
  String room_id;
  String user_id;
  String message_text;
  DateTime sent_at;

  Message({
    // required this.message_id,
    required this.room_id,
    required this.user_id,
    required this.message_text,
    required this.sent_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'room_id': room_id,
      'user_id': user_id,
      'message_text': message_text,
      'sent_at': sent_at,
    };
  }

  // Map을 사용하여 클래스 인스턴스를 생성하는 메서드
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      room_id: map['room_id'],
      user_id: map['user_id'],
      message_text: map['message_text'],
      sent_at: map['sent_at'],
    );
  }
}
