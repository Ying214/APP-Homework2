import 'package:flutter/material.dart';
import 'calendar_page.dart';
import 'today_page.dart';
import 'tasks_page.dart';
import 'settings_page.dart';
import 'event.dart';
import 'event_storage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  Map<DateTime, List<Event>> events = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loaded = await EventStorage.load();
    setState(() {
      events = loaded;
    });
  }

  void _saveData() {
    EventStorage.save(events);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      TodayPage(events: events),
      CalendarPage(events: events),
      TasksPage(events: events),
      SettingsPage(events: events),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: '今天',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '行事曆',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: '待辦',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
