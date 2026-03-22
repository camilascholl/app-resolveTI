import 'package:flutter/material.dart';

enum TicketStatus { open, inProgress, resolved }

class Ticket {
  const Ticket({
    required this.id,
    required this.title,
    required this.requester,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String requester;
  final String description;
  final TicketStatus status;
  final DateTime createdAt;

  Ticket copyWith({
    String? id,
    String? title,
    String? requester,
    String? description,
    TicketStatus? status,
    DateTime? createdAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      requester: requester ?? this.requester,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get summary {
    final compactDescription = description.replaceAll('\n', ' ').trim();
    if (compactDescription.length <= 96) {
      return compactDescription;
    }

    return '${compactDescription.substring(0, 93)}...';
  }
}

extension TicketStatusPresentation on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.open:
        return 'Aberto';
      case TicketStatus.inProgress:
        return 'Em andamento';
      case TicketStatus.resolved:
        return 'Resolvido';
    }
  }

  IconData get icon {
    switch (this) {
      case TicketStatus.open:
        return Icons.mark_email_unread_outlined;
      case TicketStatus.inProgress:
        return Icons.pending_actions_outlined;
      case TicketStatus.resolved:
        return Icons.task_alt_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFFCF6A15);
      case TicketStatus.inProgress:
        return const Color(0xFF126E82);
      case TicketStatus.resolved:
        return const Color(0xFF2D8A47);
    }
  }

  Color get containerColor {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFFFFE9D6);
      case TicketStatus.inProgress:
        return const Color(0xFFDDF3F7);
      case TicketStatus.resolved:
        return const Color(0xFFDDF5E3);
    }
  }
}

String formatTicketDate(DateTime dateTime) {
  String twoDigits(int value) => value.toString().padLeft(2, '0');

  final day = twoDigits(dateTime.day);
  final month = twoDigits(dateTime.month);
  final year = dateTime.year;
  final hour = twoDigits(dateTime.hour);
  final minute = twoDigits(dateTime.minute);

  return '$day/$month/$year as $hour:$minute';
}
