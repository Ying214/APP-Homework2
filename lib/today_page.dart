import 'package:flutter/material.dart';
import 'day_detail_page.dart';
import 'event.dart';
import 'add_event_dialog.dart';
import 'event_storage.dart';

class TodayPage extends StatefulWidget {
  final Map<DateTime, List<Event>> events;

  const TodayPage({
    super.key,
    required this.events,
  });

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  void _addTodayEvent() async {
    final today = DateTime.now();

    final newEvent = await showDialog<Event>(
      context: context,
      builder: (_) => AddEventDialog(date: today),
    );

    if (newEvent != null) {
      final key = dateKey(newEvent.date);

      setState(() {
        widget.events.putIfAbsent(key, () => []);
        widget.events[key]!.add(newEvent);
      });
      EventStorage.save(widget.events);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayKey = dateKey(today);
    final todayEvents = widget.events[todayKey] ?? [];

    return Scaffold(
      body: DayDetailPage(
        date: today,
        events: todayEvents,
        showBackButton: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodayEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
