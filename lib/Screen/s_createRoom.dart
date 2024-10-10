import 'package:app_team2/Screen/s_mainScreen.dart';
import 'package:app_team2/components/w_subheading.dart';
import 'package:app_team2/services/sv_createRoom.dart';
import 'package:flutter/material.dart';

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
    '영어',
    '프로그래밍',
    '디자인',
    '스포츠',
    '과학',
    '독서',
    '자격증'
  ];

  // 시작 시간 변수
  DateTime? _startDate;
  TimeOfDay? _startTime;

  // 종료 시간 변수
  DateTime? _endDate;
  TimeOfDay? _endTime;

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
          _startDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ); // 시작 날짜 및 시간을 설정
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
          _endDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ); // 종료 날짜 및 시간을 설정
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
              child: const Text('날짜 및 시간 선택'), // 버튼 텍스트
            ),
            Text(
              _startDate != null
                  ? '${_startDate!.toLocal().toString().split(' ')[0]} ${_formatTime(_startTime)}'
                  : '선택된 날짜 및 시간 없음', // 선택된 날짜 및 시간 표시
            ),
            const SizedBox(height: 20),
            const subheading(title: '종료 시간'), // 종료 시간 서브헤딩
            ElevatedButton(
              onPressed: _selectEndDateTime, // 종료 시간 선택 버튼
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('날짜 및 시간 선택'), // 버튼 텍스트
            ),
            Text(
              _endDate != null
                  ? '${_endDate!.toLocal().toString().split(' ')[0]} ${_formatTime(_endTime)}'
                  : '선택된 날짜 및 시간 없음', // 선택된 날짜 및 시간 표시
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
                int? maxParticipants = int.tryParse(_maxParticipantsController
                    .text); // Convert max participants to int

                if (maxParticipants != null &&
                    _startDate != null &&
                    _endDate != null) {
                  // Check if both start and end dates are selected
                  try {
                    // Create room
                    await _createRoom.createStudyRoom(
                      title: _titleController.text,
                      topic: _selectedTopic ?? '',
                      content: _contentController.text,
                      startTime: _startDate!, // Pass the DateTime directly
                      endTime: _endDate!, // Pass the DateTime directly
                      maxParticipants: maxParticipants,
                      attendee: 1,
                      reservations: {},
                      startStudy: false, // Additional parameters
                    );

                    // Success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('방이 생성되었습니다!')),
                    );

                    // Clear input fields
                    _titleController.clear();
                    _contentController.clear();
                    _maxParticipantsController.clear();
                    setState(() {
                      _selectedTopic = null;
                      _startDate = null;
                      _endDate = null;
                      _startTime = null;
                      _endTime = null;
                    });

                    // Navigate to MainScreen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('방 생성 중 오류 발생: $e')),
                    );
                    print(e);
                  }
                } else {
                  // Validation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 필드를 입력해주세요.')),
                  );
                }
              },
              child: const Text('방 만들기'), // 버튼 텍스트
            ),
          ],
        ),
      ),
    );
  }
}
