import 'package:flutter/material.dart';
import 'event.dart';

class SettingsPage extends StatelessWidget {
  final Map<DateTime, List<Event>> events;

  const SettingsPage({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '資料管理',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('清除已完成事項'),
            subtitle: const Text('刪除所有已勾選完成的事項'),
            onTap: () => _confirmClearDone(context),
          ),

          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('清除所有資料'),
            subtitle: const Text('刪除所有行程與待辦'),
            onTap: () => _confirmClearAll(context),
          ),

          const Divider(height: 32),

          const Text(
            '關於',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          const ListTile(
            leading: Icon(Icons.event_note),
            title: Text('手機行事曆 App'),
            subtitle: Text('APP程式設計 期末專題作業'),
          ),

          const ListTile(
            leading: Icon(Icons.school),
            title: Text('課程'),
            subtitle: Text('Android Studio / Flutter'),
          ),

          const ListTile(
            leading: Icon(Icons.person),
            title: Text('組員'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('黃世穎'),
                Text('林郁蕙'),
              ],
            ),
          ),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text('版本'),
            subtitle: Text('baseline'),
          ),
        ],
      ),
    );
  }

  void _confirmClearDone(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('清除已完成事項'),
        content: const Text('確定要刪除所有已完成的事項嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              _clearDone();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已完成事項已清除')),
              );
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }

  void _clearDone() {
    for (final key in events.keys) {
      events[key]!.removeWhere((e) => e.isDone);
    }
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('清除所有資料'),
        content: const Text('這個動作無法復原，確定要清除嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              events.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('所有資料已清除')),
              );
            },
            child: const Text('刪除'),
          ),
        ],
      ),
    );
  }
}
