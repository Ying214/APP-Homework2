import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';

class EventStorage {
  static const _key = 'events_data';

  static Future<void> save(
      Map<DateTime, List<Event>> events,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    final map = events.map((key, value) {
      return MapEntry(
        key.toIso8601String(),
        value.map((e) => e.toJson()).toList(),
      );
    });

    prefs.setString(_key, jsonEncode(map));
  }

  static Future<Map<DateTime, List<Event>>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    final result = <DateTime, List<Event>>{};
    decoded.forEach((key, value) {
      result[DateTime.parse(key)] =
          (value as List)
              .map((e) => Event.fromJson(e))
              .toList();
    });

    return result;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_key);
  }
}
