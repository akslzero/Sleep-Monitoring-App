/// Konfigurasi pesan notifikasi kualitas tidur
class QualityNotificationMessages {
  static const Map<String, QualityMessage> messages = {
    'kurang': QualityMessage(
      emoji: '⚠️',
      title: 'Kondisi Kurang Nyaman',
      body:
          'Tidur anda akan kurang berkualitas. Perbaiki kondisi kenyamanan ini.',
      color: 0xFFE53935, // Red
    ),
    'cukup': QualityMessage(
      emoji: '😴',
      title: 'Kondisi Cukup Nyaman',
      body:
          'Tidur anda akan cukup berkualitas. Coba tingkatkan kondisi kenyamanan.',
      color: 0xFFFB8C00, // Orange
    ),
    'nyaman': QualityMessage(
      emoji: '✨',
      title: 'Kondisi Nyaman',
      body: 'Tidur anda berkualitas baik. Pertahankan kondisi ini!',
      color: 0xFF43A047, // Green
    ),
  };

  static QualityMessage getMessageFor(String quality) {
    return messages[quality.toLowerCase()]!;
  }
}

class QualityMessage {
  final String emoji;
  final String title;
  final String body;
  final int color;

  const QualityMessage({
    required this.emoji,
    required this.title,
    required this.body,
    required this.color,
  });
}
