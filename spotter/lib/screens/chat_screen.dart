import 'package:flutter/material.dart';

import '../helper.dart';
import '../spotter_widgets.dart';
import '../white_text_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _sentMessages = [];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpotterScreen(
      title: 'Chat',
      subtitle: 'Amit Sharma',
      content: [
        const SpotterCard(
          children: [
            Text(
              'For safety, chat is monitored. Keep payments inside Spott.',
              style: TextStyle(color: Helper.muted),
            ),
          ],
        ),
        const SpotterCard(
          color: Helper.canvasSoft,
          children: [Text('Hi, I am waiting near the main gate.')],
        ),
        const SpotterCard(
          children: [
            Text(
              'Reached pickup gate. Please share OTP after checking the plate.',
            ),
          ],
        ),
        for (final message in _sentMessages)
          SpotterCard(color: Helper.canvasSoft, children: [Text(message)]),
        WhiteTextField(
          controller: _messageController,
          labelText: 'Message',
          hintText: 'Type a message',
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _sendMessage(context),
        ),
      ],
      bottom: PrimaryAction(
        label: 'Send message',
        onPressed: () => _sendMessage(context),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Type a message first')));
      return;
    }

    setState(() {
      _sentMessages.add(message);
      _messageController.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Message sent to driver')));
  }
}

