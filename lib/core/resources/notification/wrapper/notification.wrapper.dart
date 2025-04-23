import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InAppNotificationWrapper extends StatefulWidget {
  final Widget child;

  const InAppNotificationWrapper({
    required this.child,
    super.key,
  });

  static InAppNotificationWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<InAppNotificationWrapperState>()!;
  }

  @override
  InAppNotificationWrapperState createState() =>
      InAppNotificationWrapperState();
}

class NotificationEntry {
  final Widget notification;
  final String id;
  final DateTime addedTime;

  NotificationEntry({
    required this.notification,
    required this.id,
    required this.addedTime,
  });
}

class InAppNotificationWrapperState extends State<InAppNotificationWrapper> {
  late List<NotificationEntry> _notificationStack;
  final int _maxVisibleNotifications = 3;

  @override
  void initState() {
    super.initState();

    _notificationStack = [];
  }

  void addNotification(Widget notification) {
    HapticFeedback.lightImpact();

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      // Add new notification to the beginning of the list (FIFO)
      _notificationStack.insert(
        0,
        NotificationEntry(
          notification: notification,
          id: id,
          addedTime: DateTime.now(),
        ),
      );
    });

    while (_notificationStack.length > _maxVisibleNotifications) {
      _notificationStack.removeLast();
    }
  }

  void removeNotification() {
    setState(() {
      if (_notificationStack.isNotEmpty) {
        _notificationStack.removeAt(_notificationStack.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ...(_notificationStack.reversed.toList()).asMap().entries.map((entry) {
          // final index = entry.key;
          final notificationEntry = entry.value;

          return KeyedSubtree(
            key: Key('notification_${notificationEntry.id}'),
            child: notificationEntry.notification,
          );
        }),
      ],
    );
  }
}
