import 'package:flutter/material.dart';

import '../helper.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotterScreen(
      title: 'Chat',
      subtitle: 'Amit Sharma',
      content: [
        SpotterCard(
          children: [
            Text(
              'For safety, chat is monitored. Keep payments inside Spotter.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
        SpotterCard(
          color: Color(0xFFEAF2FF),
          children: [Text('Hi, I am waiting near the main gate.')],
        ),
        SpotterCard(
          children: [
            Text(
              'Reached pickup gate. Please share OTP after checking the plate.',
            ),
          ],
        ),
        WhiteTextField(labelText: 'Message', hintText: 'Type a message'),
      ],
    );
  }
}
