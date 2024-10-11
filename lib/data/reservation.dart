class Reservation {
  // int message_id;
  String user_id;
  String room_id;
  DateTime reservation_time;
  bool notification_sent;

  Reservation({
    // required this.message_id,
    required this.user_id,
    required this.room_id,
    required this.reservation_time,
    required this.notification_sent,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'room_id': room_id,
      'reservation_time': reservation_time,
      'notification_sent': notification_sent,
    };
  }

  // Map을 사용하여 클래스 인스턴스를 생성하는 메서드
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      user_id: map['user_id'],
      room_id: map['room_id'],
      reservation_time: map['reservation_time'],
      notification_sent: map['notification_sent'],
    );
  }
}
