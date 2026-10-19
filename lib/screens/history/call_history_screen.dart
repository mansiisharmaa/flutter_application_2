import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/call_history_model.dart';
import '../../services/call_history_service.dart';

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CallHistoryService.instance,
      builder: (context, _) {
        final records = CallHistoryService.instance.records;

        if (records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_missed_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                const Text('No recent calls', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: records.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final record = records[index];
            final isMissed = record.status == CallStatus.missed ||
                record.status == CallStatus.declined;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isMissed ? Colors.red.shade50 : Colors.blue.shade50,
                child: Icon(
                  record.type == CallType.video ? Icons.videocam : Icons.call,
                  color: isMissed ? Colors.red : Colors.blue,
                ),
              ),
              title: Text(record.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Row(
                children: [
                  Icon(
                    isMissed ? Icons.call_missed : Icons.call_received,
                    size: 14,
                    color: isMissed ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(record.timestamp),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              trailing: Text(
                record.duration,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isMissed ? Colors.red : Colors.grey.shade600,
                ),
              ),
            );
          },
        );
      },
    );
  }
}