import 'package:flutter/foundation.dart';
import '../models/call_history_model.dart';

class CallHistoryService extends ChangeNotifier {
  static final CallHistoryService instance = CallHistoryService._internal();
  CallHistoryService._internal();

  final List<CallRecord> _records = [];

  List<CallRecord> get records => List.unmodifiable(_records);

  void addRecord({
    required String userName,
    required CallType type,
    required CallStatus status,
    required String duration,
  }) {
    _records.insert(
      0,
      CallRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: userName,
        type: type,
        status: status,
        timestamp: DateTime.now(),
        duration: duration,
      ),
    );
    notifyListeners();
  }
}