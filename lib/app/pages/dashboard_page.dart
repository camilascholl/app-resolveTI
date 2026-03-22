import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_widgets.dart';
import '../models/ticket.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.tickets,
    required this.onTicketSelected,
    required this.onOpenBoard,
    required this.onOpenComposer,
  });

  final List<Ticket> tickets;
  final ValueChanged<Ticket> onTicketSelected;
  final VoidCallback onOpenBoard;
  final VoidCallback onOpenComposer;

  Ticket? _featuredTicket() {
    if (tickets.isEmpty) {
      return null;
    }

    final sortedTickets = [...tickets]
      ..sort((first, second) {
        final priorityComparison = second.priority.index.compareTo(
          first.priority.index,
        );
        if (priorityComparison != 0) {
          return priorityComparison;
        }

        return second.createdAt.compareTo(first.createdAt);
      });

    for (final ticket in sortedTickets) {
      if (ticket.status != TicketStatus.resolved) {
        return ticket;
      }
    }

    return sortedTickets.first;
  }

  @override
  Widget build(BuildContext context) {
    final featuredTicket = _featuredTicket();
    final recentTickets = [...tickets]
      ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
    final openCount = tickets
        .where((ticket) => ticket.status == TicketStatus.open)
        .length;
    final pendingCount = tickets
        .where((ticket) => ticket.status == TicketStatus.inProgress)
        .length;
    final resolvedCount = tickets
        .where((ticket) => ticket.status == TicketStatus.resolved)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        const AppTopBar(
          title: 'Dashboard de Chamados',
          subtitle: 'Monitore os chamados do suporte.',
          actions: [
            TopBarIconButton(icon: Icons.notifications_none_rounded),
            AvatarBadge(initials: 'CS'),
          ],
        ),
        const SizedBox(height: 20),
        AppPanel(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D4D9F), Color(0xFF426583)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBadge(
                label: 'Painel',
                backgroundColor: Colors.white.withOpacity(0.16),
                foregroundColor: Colors.white,
                icon: Icons.auto_graph_rounded,
              ),
              const SizedBox(height: 18),
              Text(
                'Central de chamados',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Acompanhe os chamados, priorize incidentes e encaminhe novos chamados com um fluxo visual mais claro.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.88),
                ),
              ),
              const SizedBox(height: 18),
              AppSearchField(
                hint: 'Buscar por ID, título ou cliente...',
                readOnly: true,
                onTap: onOpenBoard,
                fillColor: Colors.white,
                trailing: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onOpenComposer,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Novo chamado'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenBoard,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.36)),
                      ),
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('Ver painel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Abertos',
                value: openCount.toString(),
                helper: 'estão na fila',
                icon: Icons.mark_email_unread_outlined,
                iconColor: TicketStatus.open.accentColor,
                surfaceColor: TicketStatus.open.containerColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                label: 'Pendentes',
                value: pendingCount.toString(),
                helper: 'em análise',
                icon: Icons.pending_actions_outlined,
                iconColor: TicketStatus.inProgress.accentColor,
                surfaceColor: TicketStatus.inProgress.containerColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: 'Concluídos',
                value: resolvedCount.toString(),
                helper: 'nas últimas 24h',
                icon: Icons.verified_outlined,
                iconColor: TicketStatus.resolved.accentColor,
                surfaceColor: TicketStatus.resolved.containerColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatusRingCard(
                openCount: openCount,
                pendingCount: pendingCount,
                resolvedCount: resolvedCount,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        AppSectionTitle(
          title: 'Chamados em destaque',
          actionLabel: 'Abrir painel',
          onAction: onOpenBoard,
        ),
        const SizedBox(height: 12),
        if (featuredTicket != null)
          _FeaturedTicketCard(
            ticket: featuredTicket,
            onTap: () => onTicketSelected(featuredTicket),
          ),
        const SizedBox(height: 22),
        AppSectionTitle(
          title: 'Atividade recente',
          actionLabel: 'Criar chamado',
          onAction: onOpenComposer,
        ),
        const SizedBox(height: 12),
        for (final ticket in recentTickets.take(3)) ...[
          _RecentTicketTile(
            ticket: ticket,
            onTap: () => onTicketSelected(ticket),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.helper,
    required this.icon,
    required this.iconColor,
    required this.surfaceColor,
  });

  final String label;
  final String value;
  final String helper;
  final IconData icon;
  final Color iconColor;
  final Color surfaceColor;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(helper),
        ],
      ),
    );
  }
}

class _StatusRingCard extends StatelessWidget {
  const _StatusRingCard({
    required this.openCount,
    required this.pendingCount,
    required this.resolvedCount,
  });

  final int openCount;
  final int pendingCount;
  final int resolvedCount;

  @override
  Widget build(BuildContext context) {
    final total = openCount + pendingCount + resolvedCount;

    return AppPanel(
      child: Row(
        children: [
          _StatusRingChart(
            openCount: openCount,
            pendingCount: pendingCount,
            resolvedCount: resolvedCount,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gráfico por status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text('$total chamados acompanhados'),
                const SizedBox(height: 14),
                _LegendRow(
                  color: TicketStatus.open.accentColor,
                  label: 'Abertos',
                  value: openCount,
                ),
                const SizedBox(height: 8),
                _LegendRow(
                  color: TicketStatus.inProgress.accentColor,
                  label: 'Pendentes',
                  value: pendingCount,
                ),
                const SizedBox(height: 8),
                _LegendRow(
                  color: TicketStatus.resolved.accentColor,
                  label: 'Concluídos',
                  value: resolvedCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(value.toString(), style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}

class _FeaturedTicketCard extends StatelessWidget {
  const _FeaturedTicketCard({required this.ticket, required this.onTap});

  final Ticket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.stroke),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: ticket.priority.accentColor,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(26),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            AppBadge(
                              label: ticket.priority.label,
                              backgroundColor: ticket.priority.containerColor,
                              foregroundColor: ticket.priority.accentColor,
                              icon: ticket.priority.icon,
                            ),
                            AppBadge(
                              label: ticket.status.label,
                              backgroundColor: ticket.status.containerColor,
                              foregroundColor: ticket.status.accentColor,
                              icon: ticket.status.icon,
                            ),
                            AppBadge(
                              label: ticket.id,
                              backgroundColor: AppColors.backgroundAlt,
                              foregroundColor: AppColors.text,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          ticket.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(ticket.summary),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.12,
                              ),
                              child: Text(
                                ticket.requesterInitials,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${ticket.requester}  •  ${formatRelativeTime(ticket.createdAt)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textMuted),
                              ),
                            ),
                            FilledButton(
                              onPressed: onTap,
                              child: const Text('Acessar chamado'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentTicketTile extends StatelessWidget {
  const _RecentTicketTile({required this.ticket, required this.onTap});

  final Ticket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: ticket.status.containerColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    ticket.status.icon,
                    color: ticket.status.accentColor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('${ticket.id}  •  ${ticket.category}'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          AppBadge(
                            label: ticket.priority.label,
                            backgroundColor: ticket.priority.containerColor,
                            foregroundColor: ticket.priority.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Text(formatRelativeTime(ticket.createdAt)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusRingChart extends StatelessWidget {
  const _StatusRingChart({
    required this.openCount,
    required this.pendingCount,
    required this.resolvedCount,
  });

  final int openCount;
  final int pendingCount;
  final int resolvedCount;

  @override
  Widget build(BuildContext context) {
    final total = openCount + pendingCount + resolvedCount;

    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(96),
            painter: _StatusRingPainter(
              segments: [
                _ChartSegment(openCount, TicketStatus.open.accentColor),
                _ChartSegment(
                  pendingCount,
                  TicketStatus.inProgress.accentColor,
                ),
                _ChartSegment(resolvedCount, TicketStatus.resolved.accentColor),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                total.toString(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'tickets',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusRingPainter extends CustomPainter {
  const _StatusRingPainter({required this.segments});

  final List<_ChartSegment> segments;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 11.0;
    const gapAngle = 0.18;
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = AppColors.backgroundAlt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, backgroundPaint);

    final total = segments.fold<int>(0, (sum, segment) => sum + segment.value);
    if (total == 0) {
      return;
    }

    var startAngle = -math.pi / 2;

    for (final segment in segments) {
      if (segment.value == 0) {
        continue;
      }

      final sweepAngle = ((segment.value / total) * math.pi * 2) - gapAngle;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _StatusRingPainter oldDelegate) {
    return oldDelegate.segments != segments;
  }
}

class _ChartSegment {
  const _ChartSegment(this.value, this.color);

  final int value;
  final Color color;
}
