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

class InAppNotificationWrapperState extends State<InAppNotificationWrapper> {
  late List<Widget> _notificationStack;

  @override
  void initState() {
    super.initState();

    _notificationStack = [];
  }

  void addNotification(Widget notification, {int? howLong}) {
    HapticFeedback.lightImpact();

    setState(() {
      _notificationStack.add(notification);
    });

    Future.delayed(Duration(seconds: howLong ?? 7), removeNotification);
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
        ..._notificationStack,
      ],
    );
  }
}
