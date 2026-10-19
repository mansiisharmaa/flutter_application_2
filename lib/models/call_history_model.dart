enum CallType { audio, video }
enum CallStatus { incoming, outgoing, missed, declined }

class CallRecord {
  final String id;
  final String userName;
  final CallType type;
  final CallStatus status;
  final DateTime timestamp;
  final String duration;

  CallRecord({
    required this.id,
    required this.userName,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.duration,
  });
}