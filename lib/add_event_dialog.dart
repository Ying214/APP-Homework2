import 'package:flutter/material.dart';
import 'event.dart';

class AddEventDialog extends StatefulWidget {
  final DateTime date;

  const AddEventDialog({super.key, required this.date});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _titleController = TextEditingController();
  EventType _type = EventType.schedule;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('新增 ${widget.date.month}/${widget.date.day} 事件'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '事件名稱',
            ),
          ),
          const SizedBox(height: 12),

          DropdownButton<EventType>(
            value: _type,
            onChanged: (value) {
              if (value != null) {
                setState(() => _type = value);
              }
            },
            items: const [
              DropdownMenuItem(
                value: EventType.schedule,
                child: Text('時間行程'),
              ),
              DropdownMenuItem(
                value: EventType.task,
                child: Text('日期待辦'),
              ),
            ],
          ),

          if (_type == EventType.schedule) ...[
            const SizedBox(height: 12),

            TextButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() => _startTime = time);
                }
              },
              child: Text(
                _startTime == null
                    ? '選擇開始時間'
                    : '開始：${_startTime!.format(context)}',
              ),
            ),

            TextButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() => _endTime = time);
                }
              },
              child: Text(
                _endTime == null
                    ? '選擇結束時間'
                    : '結束：${_endTime!.format(context)}',
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isEmpty) return;

            Navigator.pop(
              context,
              Event(
                title: _titleController.text,
                date: widget.date,
                type: _type,
                startTime: _type == EventType.schedule ? _startTime : null,
                endTime: _type == EventType.schedule ? _endTime : null,
              ),
            );
          },
          child: const Text('新增'),
        ),
      ],
    );
  }
}
