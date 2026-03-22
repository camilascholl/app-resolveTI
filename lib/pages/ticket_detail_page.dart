import 'package:flutter/material.dart';

import '../models/ticket.dart';

class TicketDetailPage extends StatefulWidget {
  const TicketDetailPage({
    super.key,
    required this.ticket,
    required this.onTicketChanged,
  });

  final Ticket ticket;
  final ValueChanged<Ticket> onTicketChanged;

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late Ticket _ticket;

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _ticket.id,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: _ticket.status),
                    const SizedBox(height: 16),
                    Text(
                      _ticket.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF14342B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Solicitante: ${_ticket.requester}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF5D726C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Criado em ${formatTicketDate(_ticket.createdAt)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF5D726C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Descricao do chamado',
                child: Text(
                  _ticket.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: const Color(0xFF44615A),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Atualizar status',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toque em uma opcao para mudar o andamento do atendimento.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF667872),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final status in TicketStatus.values)
                          ChoiceChip(
                            selectedColor: status.containerColor,
                            side: BorderSide.none,
                            avatar: Icon(status.icon, size: 18),
                            label: Text(status.label),
                            selected: _ticket.status == status,
                            onSelected: (_) {
                              setState(() {
                                _ticket = _ticket.copyWith(status: status);
                              });
                              widget.onTicketChanged(_ticket);
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Resumo rapido',
                child: Column(
                  children: [
                    _InfoRow(label: 'Codigo', value: _ticket.id),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Status atual',
                      value: _ticket.status.label,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      label: 'Ultima atualizacao',
                      value: formatTicketDate(DateTime.now()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Voltar para a lista'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF14342B),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6A7E78),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF193931),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: status.containerColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: status.accentColor),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: status.accentColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
