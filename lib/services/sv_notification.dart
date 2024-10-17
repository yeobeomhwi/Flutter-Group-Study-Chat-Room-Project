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
    var statuses = await [
      Permission.notification,
      Permission.storage,
      Permission.mediaLibrary,
      Permission.camera,
    ].request();

  }

  void _initializeTimezone() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
  }

  void initializeNotification() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings ios = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    InitializationSettings settings =
        InitializationSettings(android: android, iOS: ios);
    await _local.initialize(settings);
    _initializeTimezone();
  }

  void setNotification(DateTime date, int roomId) async {
    await _firestore.collection('reservations').doc(roomId.toString()).set(
        Reservation(
                user_id: [], reservation_time: date, notification_sent: false)
            .toMap());
  }

  void reserveNotification(DateTime date, String roomId) async {
    tz.TZDateTime schedule = tz.TZDateTime.from(date, tz.local);

    NotificationDetails details = const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails("show_test", "show_test",
          importance: Importance.max, priority: Priority.high),
    );

    await _firestore.collection('reservations').doc(roomId).update({
      'user_id': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });

    await _local.zonedSchedule(
        int.parse(roomId), "방 시작", "예약한 방이 시작되었습니다.", schedule, details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotification(String roomId) async {
    try {
      await _local.cancel(int.parse(roomId));

      await _firestore.collection('reservations').doc(roomId).update({
        'user_id': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    } catch (e) {
      print("Error canceling notification and updating Firestore: $e");
    }
  }
}
