import 'package:flutter/material.dart';
import 'event.dart';

class DayDetailPage extends StatefulWidget {
  final DateTime date;
  final List<Event> events;
  final bool showBackButton;

  const DayDetailPage({
    super.key,
    required this.date,
    required this.events,
    this.showBackButton = true,
  });

  @override
  State<DayDetailPage> createState() => _DayDetailPageState();
}

class _DayDetailPageState extends State<DayDetailPage> {
  @override
  Widget build(BuildContext context) {
    final schedules = widget.events
        .where((e) => e.type == EventType.schedule)
        .toList();

    final tasks = widget.events
        .where((e) => e.type == EventType.task)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: widget.showBackButton ? const BackButton() : null,
        title: Text('${widget.date.month}/${widget.date.day}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== 時間行程 =====
          const Text(
            '時間行程',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (schedules.isEmpty)
            const Text('沒有時間行程'),
          ...schedules.map(_buildEventTile),

          const Divider(height: 32),

          const Text(
            '日期待辦',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (tasks.isEmpty)
            const Text('沒有待辦事項'),
          ...tasks.map(_buildEventTile),
        ],
      ),
    );
  }

  Widget _buildEventTile(Event event) {
    return Card(
      child: CheckboxListTile(
        value: event.isDone,
        onChanged: (value) {
          setState(() {
            event.isDone = value ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          event.title,
          style: TextStyle(
            decoration:
            event.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: _buildSubtitle(event),
      ),
    );
  }

  Widget? _buildSubtitle(Event event) {
    if (event.type == EventType.schedule &&
        event.startTime != null &&
        event.endTime != null) {
      return Text(
        '${event.startTime!.format(context)} - ${event.endTime!.format(context)}',
      );
    }
    return null;
  }
}
