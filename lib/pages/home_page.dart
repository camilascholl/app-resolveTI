import 'package:flutter/material.dart';

import '../models/ticket.dart';
import 'new_ticket_page.dart';
import 'ticket_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Ticket> _tickets = _seedTickets();
  TicketStatus? _selectedStatus;

  List<Ticket> get _filteredTickets {
    if (_selectedStatus == null) {
      return _tickets;
    }

    return _tickets
        .where((ticket) => ticket.status == _selectedStatus)
        .toList();
  }

  int _countByStatus(TicketStatus status) {
    return _tickets.where((ticket) => ticket.status == status).length;
  }

  Future<void> _createTicket() async {
    final newTicket = await Navigator.of(
      context,
    ).push<Ticket>(MaterialPageRoute(builder: (_) => const NewTicketPage()));

    if (newTicket == null) {
      return;
    }

    setState(() {
      _tickets.insert(0, newTicket);
    });
  }

  Future<void> _openTicketDetails(Ticket ticket) async {
    final updatedTicket = await Navigator.of(context).push<Ticket>(
      MaterialPageRoute(builder: (_) => TicketDetailPage(ticket: ticket)),
    );

    if (updatedTicket == null) {
      return;
    }

    final index = _tickets.indexWhere((item) => item.id == updatedTicket.id);
    if (index == -1) {
      return;
    }

    setState(() {
      _tickets[index] = updatedTicket;
    });
  }

  List<Ticket> _seedTickets() {
    final now = DateTime.now();

    return [
      Ticket(
        id: 'HD-1058',
        title: 'Sem acesso ao e-mail corporativo',
        requester: 'Ana Souza',
        description:
            'A usuária relata falha de autenticação ao acessar o e-mail da empresa pelo celular e pelo navegador.',
        status: TicketStatus.inProgress,
        createdAt: now.subtract(const Duration(hours: 2, minutes: 10)),
      ),
      Ticket(
        id: 'HD-1057',
        title: 'Notebook não conecta ao Wi-Fi',
        requester: 'Carlos Lima',
        description:
            'O equipamento encontra a rede, mas não conclui a conexão após a troca da senha da filial.',
        status: TicketStatus.open,
        createdAt: now.subtract(const Duration(hours: 4, minutes: 35)),
      ),
      Ticket(
        id: 'HD-1051',
        title: 'Solicitação de instalação do Adobe Reader',
        requester: 'Fernanda Rocha',
        description:
            'Chamado solicitado para leitura de documentos fiscais em PDF no computador do financeiro.',
        status: TicketStatus.resolved,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      Ticket(
        id: 'HD-1048',
        title: 'Erro ao imprimir etiquetas',
        requester: 'Ricardo Alves',
        description:
            'A impressora Zebra parou de responder após a troca do rolo e apresenta erro intermitente.',
        status: TicketStatus.open,
        createdAt: now.subtract(const Duration(days: 1, hours: 8)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredTickets = _filteredTickets;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resolve TI',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createTicket,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text('Novo chamado'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 4, 20, 18),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF15382F), Color(0xFF1F6958)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Central de chamados',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Abra solicitações, acompanhe o andamento e veja tudo em uma única fila.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFDCEFE9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MetricCard(
                      label: 'Total',
                      value: _tickets.length.toString(),
                    ),
                    _MetricCard(
                      label: 'Abertos',
                      value: _countByStatus(TicketStatus.open).toString(),
                    ),
                    _MetricCard(
                      label: 'Andamento',
                      value: _countByStatus(TicketStatus.inProgress).toString(),
                    ),
                    _MetricCard(
                      label: 'Resolvidos',
                      value: _countByStatus(TicketStatus.resolved).toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtrar por status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF17352E),
                  ),
                ),
                const SizedBox(height: 12),
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
                          label: Text(status.label),
                          selected: _selectedStatus == status,
                          avatar: Icon(status.icon, size: 18),
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
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: filteredTickets.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                    itemCount: filteredTickets.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final ticket = filteredTickets[index];
                      return _TicketCard(
                        ticket: ticket,
                        onTap: () => _openTicketDetails(ticket),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x18FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x24FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFD6ECE5)),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final Ticket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF14342B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ticket.id} • ${ticket.requester}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF61736E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Color(0xFF97AAA4),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                ticket.summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  color: const Color(0xFF48605A),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _StatusBadge(status: ticket.status),
                  Text(
                    formatTicketDate(ticket.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF718782),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F0EC),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.filter_alt_off_outlined,
                size: 36,
                color: Color(0xFF3C655A),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum chamado encontrado',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF183830),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajuste o filtro selecionado ou crie um novo chamado para começar.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF667A74),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
