import 'package:flutter/material.dart';
import 'event.dart';
import 'event_storage.dart';

class TasksPage extends StatefulWidget {
  final Map<DateTime, List<Event>> events;

  const TasksPage({
    super.key,
    required this.events,
  });

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool _showDone = false;

  @override
  Widget build(BuildContext context) {
    final undone = widget.events.values
        .expand((list) => list)
        .where((e) => !e.isDone)
        .toList();
    final done = widget.events.values
        .expand((list) => list)
        .where((e) => e.isDone)
        .toList();
    undone.sort((a, b) => a.date.compareTo(b.date));
    final Map<int, List<Event>> byMonth = {};
    for (final event in undone) {
      byMonth.putIfAbsent(event.date.month, () => []);
      byMonth[event.date.month]!.add(event);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('全部待辦'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '未完成',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          if (undone.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('沒有未完成的事項'),
            ),

          ...byMonth.entries.map((entry) {
            final month = entry.key;
            final events = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  '$month 月',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                ...events.map(_buildTaskTile),
              ],
            );
          }),

          const Divider(height: 32),

          InkWell(
            onTap: () {
              setState(() {
                _showDone = !_showDone;
              });
            },
            child: Row(
              children: [
                const Text(
                  '已完成',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  _showDone ? Icons.expand_less : Icons.expand_more,
                ),
              ],
            ),
          ),

          if (_showDone) ...[
            if (done.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('尚未完成任何事項'),
              ),
            ...done.map(_buildTaskTile),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskTile(Event event) {
    return Card(
      child: CheckboxListTile(
        value: event.isDone,
        onChanged: (value) {
          setState(() {
            event.isDone = value ?? false;
          });
          EventStorage.save(widget.events);
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          event.title,
          style: TextStyle(
            decoration:
            event.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(_subtitleText(event)),
        secondary: Icon(
          event.type == EventType.schedule
              ? Icons.schedule
              : Icons.checklist,
          size: 18,
        ),
      ),
    );
  }

  String _subtitleText(Event event) {
    if (event.type == EventType.schedule &&
        event.startTime != null &&
        event.endTime != null) {
      return
        '${event.date.month}/${event.date.day} '
            '(${event.startTime!.format(context)}–'
            '${event.endTime!.format(context)})';
    }

    return '${event.date.month}/${event.date.day}（待辦）';
  }
}
