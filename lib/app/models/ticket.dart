import 'package:flutter/material.dart';

enum TicketStatus { open, inProgress, resolved }

enum TicketPriority { low, medium, high, urgent }

enum TicketUpdateKind { requester, agent, system }

class TicketUpdate {
  const TicketUpdate({
    required this.author,
    required this.message,
    required this.createdAt,
    required this.kind,
  });

  final String author;
  final String message;
  final DateTime createdAt;
  final TicketUpdateKind kind;
}

class Ticket {
  const Ticket({
    required this.id,
    required this.title,
    required this.requester,
    required this.description,
    required this.category,
    required this.assignedTo,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.updates = const <TicketUpdate>[],
  });

  final String id;
  final String title;
  final String requester;
  final String description;
  final String category;
  final String assignedTo;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;
  final List<TicketUpdate> updates;

  Ticket copyWith({
    String? id,
    String? title,
    String? requester,
    String? description,
    String? category,
    String? assignedTo,
    TicketStatus? status,
    TicketPriority? priority,
    DateTime? createdAt,
    List<TicketUpdate>? updates,
  }) {
    return Ticket(
      id: id ?? this.id,
      title: title ?? this.title,
      requester: requester ?? this.requester,
      description: description ?? this.description,
      category: category ?? this.category,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updates: updates ?? this.updates,
    );
  }

  String get summary {
    final compactDescription = description.replaceAll('\n', ' ').trim();
    if (compactDescription.length <= 110) {
      return compactDescription;
    }

    return '${compactDescription.substring(0, 107)}...';
  }

  String get requesterInitials {
    final parts = requester
        .split(' ')
        .where((part) => part.trim().isNotEmpty)
        .take(2)
        .toList();

    if (parts.isEmpty) {
      return 'HD';
    }

    return parts.map((part) => part[0].toUpperCase()).join();
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

  String get dashboardLabel {
    switch (this) {
      case TicketStatus.open:
        return 'Abertos';
      case TicketStatus.inProgress:
        return 'Pendentes';
      case TicketStatus.resolved:
        return 'Concluídos';
    }
  }

  IconData get icon {
    switch (this) {
      case TicketStatus.open:
        return Icons.mark_email_unread_outlined;
      case TicketStatus.inProgress:
        return Icons.pending_actions_outlined;
      case TicketStatus.resolved:
        return Icons.verified_outlined;
    }
  }

  Color get accentColor {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFF005FB8);
      case TicketStatus.inProgress:
        return const Color(0xFFD32F2F);
      case TicketStatus.resolved:
        return const Color(0xFF546E7A);
    }
  }

  Color get containerColor {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFFE0EDFB);
      case TicketStatus.inProgress:
        return const Color(0xFFFBE2E2);
      case TicketStatus.resolved:
        return const Color(0xFFE3EAEE);
    }
  }
}

extension TicketPriorityPresentation on TicketPriority {
  String get label {
    switch (this) {
      case TicketPriority.low:
        return 'Baixa';
      case TicketPriority.medium:
        return 'Média';
      case TicketPriority.high:
        return 'Alta';
      case TicketPriority.urgent:
        return 'Urgente';
    }
  }

  IconData get icon {
    switch (this) {
      case TicketPriority.low:
        return Icons.keyboard_arrow_down_rounded;
      case TicketPriority.medium:
        return Icons.remove_rounded;
      case TicketPriority.high:
        return Icons.keyboard_arrow_up_rounded;
      case TicketPriority.urgent:
        return Icons.priority_high_rounded;
    }
  }

  Color get accentColor {
    switch (this) {
      case TicketPriority.low:
        return const Color(0xFF546E7A);
      case TicketPriority.medium:
        return const Color(0xFF005FB8);
      case TicketPriority.high:
        return const Color(0xFFB71C1C);
      case TicketPriority.urgent:
        return const Color(0xFF8A1022);
    }
  }

  Color get containerColor {
    switch (this) {
      case TicketPriority.low:
        return const Color(0xFFE6EDF1);
      case TicketPriority.medium:
        return const Color(0xFFDDECFB);
      case TicketPriority.high:
        return const Color(0xFFFBE4E4);
      case TicketPriority.urgent:
        return const Color(0xFFF8D6DD);
    }
  }
}

extension TicketUpdateKindPresentation on TicketUpdateKind {
  bool get alignsRight => this == TicketUpdateKind.requester;

  Color get bubbleColor {
    switch (this) {
      case TicketUpdateKind.requester:
        return const Color(0xFFE5F1FF);
      case TicketUpdateKind.agent:
        return Colors.white;
      case TicketUpdateKind.system:
        return const Color(0xFFF2F5F9);
    }
  }

  Color get textColor {
    switch (this) {
      case TicketUpdateKind.requester:
        return const Color(0xFF124A82);
      case TicketUpdateKind.agent:
        return const Color(0xFF1E2835);
      case TicketUpdateKind.system:
        return const Color(0xFF546272);
    }
  }

  Color get accentColor {
    switch (this) {
      case TicketUpdateKind.requester:
        return const Color(0xFF005FB8);
      case TicketUpdateKind.agent:
        return const Color(0xFF546E7A);
      case TicketUpdateKind.system:
        return const Color(0xFF8893A0);
    }
  }
}

String formatTicketDate(DateTime dateTime) {
  final day = _twoDigits(dateTime.day);
  final month = _twoDigits(dateTime.month);
  final year = dateTime.year;
  final hour = _twoDigits(dateTime.hour);
  final minute = _twoDigits(dateTime.minute);

  return '$day/$month/$year - $hour:$minute';
}

String formatShortDate(DateTime dateTime) {
  final day = _twoDigits(dateTime.day);
  final month = _twoDigits(dateTime.month);
  return '$day/$month';
}

String formatRelativeTime(DateTime dateTime) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Agora';
  }

  if (difference.inMinutes < 60) {
    return 'Há ${difference.inMinutes} minutos';
  }

  if (difference.inHours < 24) {
    return 'Há ${difference.inHours} horas';
  }

  if (difference.inDays < 7) {
    return 'Há ${difference.inDays} dias';
  }

  return formatShortDate(dateTime);
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');
