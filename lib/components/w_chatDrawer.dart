import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer(
      {super.key, required this.totalPeople, required this.currentPeople});

  final int totalPeople;
  final int currentPeople;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(children: [
          const Text('참여 인원', style: TextStyle(fontSize: 32)),
          Text('[$currentPeople / $totalPeople]',
              style: const TextStyle(fontSize: 28)),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 3,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: const BoxDecoration(
                                color: Colors.grey, shape: BoxShape.circle),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                          const Text('닉네임',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                      const Divider()
                    ],
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
