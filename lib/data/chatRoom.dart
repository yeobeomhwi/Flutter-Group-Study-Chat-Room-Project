class chatRoom {
  final String title;
  final String topic;
  final String content;
  final DateTime startTime;
  final DateTime endTime;
  final int maxParticipants;

  chatRoom({
    required this.title,
    required this.topic,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.maxParticipants,
  });
}

// 방 목록을 관리하는 리스트
List<chatRoom> roomList = [];
