import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../models/ticket.dart';
import 'dashboard_page.dart';
import 'new_ticket_page.dart';
import 'profile_page.dart';
import 'ticket_detail_page.dart';
import 'tickets_page.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  late final List<Ticket> _tickets = _seedTickets();
  int _currentIndex = 0;

  int _countByStatus(TicketStatus status) {
    return _tickets.where((ticket) => ticket.status == status).length;
  }

  int get _resolutionRate {
    if (_tickets.isEmpty) {
      return 0;
    }

    return ((_countByStatus(TicketStatus.resolved) / _tickets.length) * 100)
        .round();
  }

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _createTicket(Ticket ticket) {
    setState(() {
      _tickets.insert(0, ticket);
      _currentIndex = 1;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Chamado ${ticket.id} criado e enviado para triagem.'),
        ),
      );
  }

  void _updateTicket(Ticket updatedTicket) {
    final index = _tickets.indexWhere(
      (ticket) => ticket.id == updatedTicket.id,
    );
    if (index == -1) {
      return;
    }

    setState(() {
      _tickets[index] = updatedTicket;
    });
  }

  Future<void> _openTicketDetails(Ticket ticket) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            TicketDetailPage(ticket: ticket, onTicketChanged: _updateTicket),
      ),
    );
  }

  List<Ticket> _seedTickets() {
    final now = DateTime.now();

    return [
      Ticket(
        id: 'HD-8842',
        title: 'Erro crítico na integracao de pagamentos - Produção',
        requester: 'Ananda Santos',
        description:
            'Pedidos de alto valor estão falhando na finalização e a operação não consegue concluir pagamentos com PIX e cartão desde o início da tarde.',
        category: 'Pagamentos',
        assignedTo: 'Shaiane Silva',
        status: TicketStatus.inProgress,
        priority: TicketPriority.urgent,
        createdAt: now.subtract(const Duration(minutes: 35)),
        updates: [
          TicketUpdate(
            author: 'Sistema',
            message: 'Chamado criado e roteado automaticamente para o NOC.',
            createdAt: now.subtract(const Duration(minutes: 35)),
            kind: TicketUpdateKind.system,
          ),
          TicketUpdate(
            author: 'Guilherme Maranho',
            message:
                'Identificamos falha no pool de conexões do gateway. Equipe de pagamentos já iniciou a mitigação.',
            createdAt: now.subtract(const Duration(minutes: 21)),
            kind: TicketUpdateKind.agent,
          ),
          TicketUpdate(
            author: 'João Antonio',
            message:
                'A operação segue impactada em produção e ainda não conseguimos concluir os pedidos prioritários.',
            createdAt: now.subtract(const Duration(minutes: 9)),
            kind: TicketUpdateKind.requester,
          ),
        ],
      ),
      Ticket(
        id: 'HD-8810',
        title: 'Falha de acesso ao Servidor CRM',
        requester: 'Heitor',
        description:
            'Usuários do financeiro não conseguem autenticar no CRM depois da troca de senha do domínio e o sistema retorna erro 401.',
        category: 'Acesso',
        assignedTo: 'Thiago Rosa',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        createdAt: now.subtract(const Duration(hours: 1, minutes: 10)),
        updates: [
          TicketUpdate(
            author: 'Sistema',
            message: 'Chamado criado e aguardando classificação da fila.',
            createdAt: now.subtract(const Duration(hours: 1, minutes: 10)),
            kind: TicketUpdateKind.system,
          ),
        ],
      ),
      Ticket(
        id: 'HD-8798',
        title: 'Sem acesso ao e-mail corporativo',
        requester: 'Letícia Dreher',
        description:
            'A colaboradora não consegue autenticar no Outlook Web e no aplicativo do celular desde a troca de senha.',
        category: 'Acesso',
        assignedTo: 'Fabio',
        status: TicketStatus.open,
        priority: TicketPriority.medium,
        createdAt: now.subtract(const Duration(minutes: 50)),
        updates: [
          TicketUpdate(
            author: 'Sistema',
            message: 'Ticket priorizado para o time de identidade.',
            createdAt: now.subtract(const Duration(minutes: 42)),
            kind: TicketUpdateKind.system,
          ),
        ],
      ),
      Ticket(
        id: 'HD-8794',
        title: 'Instalação de novo periférico',
        requester: 'Ana Paula',
        description:
            'Nova leitora de código de barras precisa ser instalada no caixa 04 com o driver homologado pela operação.',
        category: 'Hardware',
        assignedTo: 'Rafael Santos',
        status: TicketStatus.inProgress,
        priority: TicketPriority.medium,
        createdAt: now.subtract(const Duration(hours: 3, minutes: 20)),
        updates: [
          TicketUpdate(
            author: 'Tadioto',
            message:
                'Driver validado e visita presencial agendada para o início da noite.',
            createdAt: now.subtract(const Duration(hours: 2, minutes: 12)),
            kind: TicketUpdateKind.agent,
          ),
        ],
      ),
      Ticket(
        id: 'HD-8736',
        title: 'Reset de senha - VPN',
        requester: 'José',
        description:
            'A colaboradora não consegue acessar a VPN apos o bloqueio de tentativas e precisa retomar o acesso remoto hoje.',
        category: 'Rede',
        assignedTo: 'Rafael',
        status: TicketStatus.resolved,
        priority: TicketPriority.low,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        updates: [
          TicketUpdate(
            author: 'Thais',
            message:
                'Senha redefinida, reconfigurado e acesso validado com a usuária.',
            createdAt: now.subtract(const Duration(hours: 18)),
            kind: TicketUpdateKind.agent,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        tickets: _tickets,
        onTicketSelected: _openTicketDetails,
        onOpenBoard: () => _selectTab(1),
        onOpenComposer: () => _selectTab(2),
      ),
      TicketsPage(tickets: _tickets, onTicketSelected: _openTicketDetails),
      NewTicketPage(onCreateTicket: _createTicket),
      ProfilePage(
        openTickets: _countByStatus(TicketStatus.open),
        inProgressTickets: _countByStatus(TicketStatus.inProgress),
        resolvedRate: _resolutionRate,
      ),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, Color(0xFFEAF1FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: IndexedStack(index: _currentIndex, children: pages),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.stroke),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _selectTab,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.space_dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.confirmation_num_outlined),
                label: 'Chamados',
              ),
              NavigationDestination(
                icon: Icon(Icons.add_box_rounded),
                label: 'Novo',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_rounded),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
