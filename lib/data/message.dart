class Message {
  // int message_id;
  String user;
  String message;
  DateTime createDate;

  Message({
    // required this.message_id,
    required this.user,
    required this.message,
    required this.createDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'message': message,
      'createDate': createDate,
    };
  }

  // Map을 사용하여 클래스 인스턴스를 생성하는 메서드
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      user: map['user'],
      message: map['message'],
      createDate: map['createDate'],
    );
  }
}
