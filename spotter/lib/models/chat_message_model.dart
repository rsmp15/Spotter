class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? text;
  final String? imageUrl;
  final bool read;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.text,
    this.imageUrl,
    this.read = false,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      text: json['text'] as String?,
      imageUrl: json['imageUrl'] as String?,
      read: json['read'] as bool? ?? false,
      sentAt: DateTime.parse(json['sentAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        'imageUrl': imageUrl,
        'read': read,
        'sentAt': sentAt.toIso8601String(),
      };

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? text,
    String? imageUrl,
    bool? read,
    DateTime? sentAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      read: read ?? this.read,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}

