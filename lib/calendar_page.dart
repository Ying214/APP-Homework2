import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'day_detail_page.dart';
import 'event.dart';
import 'add_event_dialog.dart';
import 'event_storage.dart';

class CalendarPage extends StatefulWidget {
  final Map<DateTime, List<Event>> events;
  final DateTime? initialDate;

  const CalendarPage({
    super.key,
    required this.events,
    this.initialDate,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    if (widget.initialDate != null) {
      _focusedDay = dateKey(widget.initialDate!);
      _selectedDay = dateKey(widget.initialDate!);
    }
  }

  void _addEvent(Event event) {
    final key = dateKey(event.date);

    setState(() {
      widget.events.putIfAbsent(key, () => []);
      widget.events[key]!.add(event);
    });
    EventStorage.save(widget.events);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('行事曆'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay, day),

            eventLoader: (day) {
              return widget.events[dateKey(day)] ?? [];
            },

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              final dayEvents =
                  widget.events[dateKey(selectedDay)] ?? [];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DayDetailPage(
                    date: selectedDay,
                    events: dayEvents,
                  ),
                ),
              );
            },

            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
            ),

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;

                return Positioned(
                  bottom: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.take(3).map((e) {
                      final event = e as Event;
                      return Container(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 1),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: event.type == EventType.schedule
                              ? Colors.orange
                              : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_selectedDay == null) return;

          final newEvent = await showDialog<Event>(
            context: context,
            builder: (_) => AddEventDialog(date: _selectedDay!),
          );

          if (newEvent != null) {
            _addEvent(newEvent);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

