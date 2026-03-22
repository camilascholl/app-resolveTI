import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_widgets.dart';
import '../models/ticket.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({
    super.key,
    required this.tickets,
    required this.onTicketSelected,
  });

  final List<Ticket> tickets;
  final ValueChanged<Ticket> onTicketSelected;

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  TicketStatus? _selectedStatus;
  String _query = '';

  List<Ticket> get _filteredTickets {
    final normalizedQuery = _query.trim().toLowerCase();

    return widget.tickets.where((ticket) {
        final matchesStatus =
            _selectedStatus == null || ticket.status == _selectedStatus;
        final matchesQuery =
            normalizedQuery.isEmpty ||
            ticket.id.toLowerCase().contains(normalizedQuery) ||
            ticket.title.toLowerCase().contains(normalizedQuery) ||
            ticket.requester.toLowerCase().contains(normalizedQuery) ||
            ticket.category.toLowerCase().contains(normalizedQuery);

        return matchesStatus && matchesQuery;
      }).toList()
      ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
  }

  int _countByStatus(TicketStatus status) {
    return widget.tickets.where((ticket) => ticket.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTickets = _filteredTickets;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        const AppTopBar(
          title: 'Painel de Chamados',
          subtitle:
              'Filtre a fila por status, prioridade e contexto do chamado.',
          leadingIcon: Icons.dashboard_customize_rounded,
          actions: [
            TopBarIconButton(icon: Icons.search_rounded),
            AvatarBadge(initials: 'CS'),
          ],
        ),
        const SizedBox(height: 20),
        AppSearchField(
          hint: 'Buscar por ticket, titulo, solicitante ou categoria',
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          trailing: const Icon(
            Icons.filter_alt_outlined,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ChoiceChip(
                label: const Text('Todos'),
                selected: _selectedStatus == null,
                onSelected: (_) {
                  setState(() {
                    _selectedStatus = null;
                  });
                },
              ),
              const SizedBox(width: 10),
              for (final status in TicketStatus.values) ...[
                ChoiceChip(
                  label: Text(status.dashboardLabel),
                  avatar: Icon(status.icon, size: 18),
                  selected: _selectedStatus == status,
                  selectedColor: status.containerColor,
                  side: BorderSide.none,
                  onSelected: (_) {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                ),
                const SizedBox(width: 10),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _BoardStatChip(
                label: 'Abertos',
                value: _countByStatus(TicketStatus.open),
                color: TicketStatus.open.accentColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BoardStatChip(
                label: 'Pendentes',
                value: _countByStatus(TicketStatus.inProgress),
                color: TicketStatus.inProgress.accentColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BoardStatChip(
                label: 'Concluídos',
                value: _countByStatus(TicketStatus.resolved),
                color: TicketStatus.resolved.accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        AppSectionTitle(
          title: 'Lista de chamados',
          actionLabel: '${filteredTickets.length} itens',
        ),
        const SizedBox(height: 12),
        if (filteredTickets.isEmpty)
          const _EmptyBoardState()
        else
          for (final ticket in filteredTickets) ...[
            _TicketBoardCard(
              ticket: ticket,
              onTap: () => widget.onTicketSelected(ticket),
            ),
            const SizedBox(height: 14),
          ],
      ],
    );
  }
}

class _BoardStatChip extends StatelessWidget {
  const _BoardStatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}

class _TicketBoardCard extends StatelessWidget {
  const _TicketBoardCard({required this.ticket, required this.onTap});

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
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  AppBadge(
                                    label: ticket.status.label,
                                    backgroundColor:
                                        ticket.status.containerColor,
                                    foregroundColor: ticket.status.accentColor,
                                    icon: ticket.status.icon,
                                  ),
                                  AppBadge(
                                    label: ticket.priority.label,
                                    backgroundColor:
                                        ticket.priority.containerColor,
                                    foregroundColor:
                                        ticket.priority.accentColor,
                                    icon: ticket.priority.icon,
                                  ),
                                  AppBadge(
                                    label: ticket.id,
                                    backgroundColor: AppColors.backgroundAlt,
                                    foregroundColor: AppColors.text,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              formatRelativeTime(ticket.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.requester,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${ticket.category}  •  ${ticket.assignedTo}',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: AppColors.textMuted,
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

class _EmptyBoardState extends StatelessWidget {
  const _EmptyBoardState();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.backgroundAlt,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 34,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum chamado encontrado',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Ajuste os filtros ou refine a busca para localizar os chamados desta fila.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
