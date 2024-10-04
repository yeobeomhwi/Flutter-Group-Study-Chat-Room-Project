import 'package:app_team2/Screen/s_mainScreen.dart';
import 'package:app_team2/components/w_subheading.dart';
import 'package:app_team2/services/sv_createRoom.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _titleController = TextEditingController(); // 방 제목 입력 컨트롤러
  final _contentController = TextEditingController(); // 방 설명 입력 컨트롤러
  final _maxParticipantsController = TextEditingController(); // 최대 인원 입력 컨트롤러

  final CreateRoom _createRoom = CreateRoom(); // CreateRoom 인스턴스 생성

  String? _selectedTopic; // 선택된 주제
  final List<String> _topics = [
    // 주제 리스트
    '수학',
    '영어 회화',
    '토익',
    '프로그래밍',
    '디자인',
    '스포츠',
    '과학',
    '독서',
    '자격증'
  ];

  // 시작 시간 변수
  tz.TZDateTime? _startDate;
  TimeOfDay? _startTime;

  // 종료 시간 변수
  tz.TZDateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // 시간대 초기화
  }

  // TZDateTime을 포맷하는 헬퍼 메서드
  String _formatTZDate(tz.TZDateTime? date) {
    if (date == null) return '선택된 날짜 및 시간 없음'; // 날짜가 없을 경우 메시지 반환
    return date.toLocal().toString().split(' ')[0]; // 날짜 포맷
  }

  // TimeOfDay을 포맷하는 헬퍼 메서드
  String _formatTime(TimeOfDay? time) {
    if (time == null) return ''; // 시간 선택이 없을 경우 빈 문자열 반환
    return time.format(context); // 시간 포맷
  }

  // 시작 날짜 및 시간 선택 메서드
  Future<void> _selectStartDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // 오늘 날짜로 초기화
      firstDate: DateTime.now(), // 오늘부터 선택 가능
      lastDate: DateTime(2030), // 최대 2030년까지
    );

    if (pickedDate != null) {
      // 날짜 선택 후 시간 선택
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _startDate = tz.TZDateTime.from(pickedDate, tz.local); // 시작 날짜 설정
          _startTime = pickedTime; // 시작 시간 설정
        });
      }
    }
  }

  // 종료 날짜 및 시간 선택 메서드
  Future<void> _selectEndDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // 오늘 날짜로 초기화
      firstDate: DateTime.now(), // 오늘부터 선택 가능
      lastDate: DateTime(2030), // 최대 2030년까지
    );

    if (pickedDate != null) {
      // 날짜 선택 후 시간 선택
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _endDate = tz.TZDateTime.from(pickedDate, tz.local); // 종료 날짜 설정
          _endTime = pickedTime; // 종료 시간 설정
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('방 만들기'), // 앱바 제목
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // 전체 여백 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const subheading(title: '방 제목'), // 방 제목 서브헤딩
            TextField(
              controller: _titleController, // 제목 입력 필드
              decoration: const InputDecoration(labelText: '방 제목'),
            ),
            const SizedBox(height: 10),
            const subheading(title: '방 주제'), // 방 주제 서브헤딩
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedTopic,
              decoration: const InputDecoration(labelText: '방 주제 선택'),
              items: _topics.map((String topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic), // 주제 리스트 표시
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTopic = newValue; // 주제 선택
                });
              },
            ),
            const SizedBox(height: 20),
            const subheading(title: '방 설명'), // 방 설명 서브헤딩
            TextField(
              controller: _contentController, // 설명 입력 필드
              decoration: const InputDecoration(labelText: '방 설명'),
            ),
            const SizedBox(height: 10),
            const subheading(title: '시작 시간'), // 시작 시간 서브헤딩
            ElevatedButton(
                onPressed: _selectStartDateTime, // 시작 시간 선택 버튼
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36),
                ),
                child: const Text('날짜 및 시간 선택')), // 버튼 텍스트
            Text(
              '${_formatTZDate(_startDate)} ${_formatTime(_startTime)}', // 선택된 날짜 및 시간 표시
            ),
            const SizedBox(height: 20),
            const subheading(title: '종료 시간'), // 종료 시간 서브헤딩
            ElevatedButton(
                onPressed: _selectEndDateTime, // 종료 시간 선택 버튼
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36),
                ),
                child: const Text('날짜 및 시간 선택')), // 버튼 텍스트
            Text(
              '${_formatTZDate(_endDate)} ${_formatTime(_endTime)}', // 선택된 날짜 및 시간 표시
            ),
            const SizedBox(height: 20),
            const subheading(title: '최대 인원'), // 최대 인원 서브헤딩
            TextField(
              controller: _maxParticipantsController, // 최대 인원 입력 필드
              keyboardType: TextInputType.number, // 숫자 입력 키보드
              decoration: const InputDecoration(labelText: '최대인원 (숫자 입력)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print(
                    'Start Date: $_startDate, Start Time: $_startTime'); // 선택된 시작 시간 로그
                print(
                    'End Date: $_endDate, End Time: $_endTime'); // 선택된 종료 시간 로그
                int? maxParticipants = int.tryParse(
                    _maxParticipantsController.text); // 최대 인원 숫자로 변환
                if (maxParticipants != null &&
                    _startDate != null &&
                    _endDate != null &&
                    _startTime != null &&
                    _endTime != null) {
                  // 모든 시간 변수가 유효한지 확인
                  try {
                    // 방 생성
                    await _createRoom.createStudyRoom(
                      title: _titleController.text,
                      // 방 제목
                      topic: _selectedTopic ?? '',
                      // 주제가 선택되지 않았다면 빈 문자열
                      content: _contentController.text,
                      // 방 설명
                      startTime: tz.TZDateTime(
                              tz.local,
                              _startDate!.year,
                              _startDate!.month,
                              _startDate!.day,
                              _startTime!.hour,
                              _startTime!.minute)
                          .toDate(),
                      // DateTime으로 변환
                      endTime: tz.TZDateTime(
                              tz.local,
                              _endDate!.year,
                              _endDate!.month,
                              _endDate!.day,
                              _endTime!.hour,
                              _endTime!.minute)
                          .toDate(),
                      // DateTime으로 변환
                      maxParticipants: maxParticipants,
                      attendee: 1,
                      reservations: {},
                      startStudy: false, // 최대 인원
                    );

                    // 방 생성 완료 후 알림
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('방이 생성되었습니다!')), // 방 생성 성공 메시지
                    );

                    // 입력 필드 초기화
                    _titleController.clear(); // 제목 필드 초기화
                    _contentController.clear(); // 설명 필드 초기화
                    _maxParticipantsController.clear(); // 최대 인원 필드 초기화
                    setState(() {
                      _selectedTopic = null; // 선택된 주제 초기화
                      _startDate = null; // 시작 날짜 초기화
                      _endDate = null; // 종료 날짜 초기화
                      _startTime = null; // 시작 시간 초기화
                      _endTime = null; // 종료 시간 초기화
                    });

                    // MainScreen으로 이동
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              MainScreen()), // MainScreen으로 이동
                    );
                  } catch (e) {
                    // 오류 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('방 생성 실패: $e')), // 방 생성 실패 메시지
                    );
                  }
                } else {
                  // 입력값이 유효하지 않을 경우 경고
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('모든 필드를 올바르게 입력해주세요.')), // 입력 오류 메시지
                  );
                }
              },
              child: const Text('방 생성'), // 버튼 텍스트
            ),
          ],
        ),
      ),
    );
  }
}

extension on tz.TZDateTime {
  DateTime toDate() {
    return DateTime(year, month, day, hour, minute);
  }
}
