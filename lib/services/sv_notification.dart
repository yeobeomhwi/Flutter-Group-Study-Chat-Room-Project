import 'package:app_team2/data/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final instance = NotificationService();

  final _firestore = FirebaseFirestore.instance;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  void permissionRequest() async {
    await [Permission.notification].request();
  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  }

  void initializeNotification() async {
    AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
    _initializeTimezone();
  }

  void show() async {
    NotificationDetails details = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails("show_test", "show_test",
          importance: Importance.max, priority: Priority.high),
    );
    await _local.show(0, "제목", "내용", details);
  }

  void reserveNotification(DateTime date, String room_Id) async {
    tz.TZDateTime schedule = tz.TZDateTime.from(date, tz.local);

    NotificationDetails details = NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails("show_test", "show_test",
          importance: Importance.max, priority: Priority.high),
    );

    int newId = await getNextId();

    await _firestore.collection('reservations').doc(newId.toString()).set(
        Reservation(
                user_id: FirebaseAuth.instance.currentUser!.uid,
                room_id: room_Id,
                reservation_time: date,
                notification_sent: false)
            .toMap());

    await _local.zonedSchedule(
        newId, "방 시작", "예약한 방이 시작되었습니다.", schedule, details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<int> getNextId() async {
    QuerySnapshot snapshot = await _firestore
        .collection('reservations')
        .orderBy(FieldPath.documentId)
        .get();

    if (snapshot.docs.isEmpty) {
      return 1;
    } else {
      int lastId = int.parse(snapshot.docs.last.id);
      return lastId + 1;
    }
  }
}
