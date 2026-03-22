import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_widgets.dart';
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
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _applyTicketUpdate(Ticket updatedTicket) {
    setState(() {
      _ticket = updatedTicket;
    });
    widget.onTicketChanged(updatedTicket);
  }

  void _setStatus(TicketStatus status) {
    if (_ticket.status == status) {
      return;
    }

    _applyTicketUpdate(
      _ticket.copyWith(
        status: status,
        updates: [
          ..._ticket.updates,
          TicketUpdate(
            author: 'Sistema',
            message: 'Status alterado para ${status.label.toLowerCase()}.',
            createdAt: DateTime.now(),
            kind: TicketUpdateKind.system,
          ),
        ],
      ),
    );
  }

  void _sendReply() {
    final message = _replyController.text.trim();
    if (message.isEmpty) {
      return;
    }

    _applyTicketUpdate(
      _ticket.copyWith(
        updates: [
          ..._ticket.updates,
          TicketUpdate(
            author: 'Camila Scholl',
            message: message,
            createdAt: DateTime.now(),
            kind: TicketUpdateKind.requester,
          ),
        ],
      ),
    );

    _replyController.clear();
  }

  void _showActionFeedback(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label em breve.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.background, Color(0xFFEAF1FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    Row(
                      children: [
                        TopBarIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalhes do Chamado',
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _ticket.id,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const TopBarIconButton(icon: Icons.more_horiz_rounded),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              AppBadge(
                                label: _ticket.status.label,
                                backgroundColor: _ticket.status.containerColor,
                                foregroundColor: _ticket.status.accentColor,
                                icon: _ticket.status.icon,
                              ),
                              AppBadge(
                                label: _ticket.priority.label,
                                backgroundColor:
                                    _ticket.priority.containerColor,
                                foregroundColor: _ticket.priority.accentColor,
                                icon: _ticket.priority.icon,
                              ),
                              AppBadge(
                                label: _ticket.category,
                                backgroundColor: AppColors.backgroundAlt,
                                foregroundColor: AppColors.text,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _ticket.title,
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _ticket.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.primary.withOpacity(
                                  0.12,
                                ),
                                child: Text(
                                  _ticket.requesterInitials,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _ticket.requester,
                                      style: theme.textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Responsavel: ${_ticket.assignedTo}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                formatTicketDate(_ticket.createdAt),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Atualizar status',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (final status in TicketStatus.values)
                                ChoiceChip(
                                  label: Text(status.label),
                                  avatar: Icon(status.icon, size: 18),
                                  selected: _ticket.status == status,
                                  selectedColor: status.containerColor,
                                  side: BorderSide.none,
                                  onSelected: (_) => _setStatus(status),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Timeline', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 16),
                          for (final update in _ticket.updates) ...[
                            _UpdateBubble(update: update),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Acoes rapidas',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              FilledButton.icon(
                                onPressed: () =>
                                    _showActionFeedback('Adicionar nota'),
                                icon: const Icon(Icons.note_add_outlined),
                                label: const Text('Adicionar nota'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _showActionFeedback('Compartilhar ticket'),
                                icon: const Icon(Icons.share_outlined),
                                label: const Text('Compartilhar'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _setStatus(TicketStatus.resolved),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.tertiary,
                                  side: const BorderSide(
                                    color: Color(0xFFF2C9C9),
                                  ),
                                ),
                                icon: const Icon(Icons.task_alt_rounded),
                                label: const Text('Encerrar ticket'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informacoes do ticket',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          _InfoRow(
                            label: 'Criado em',
                            value: formatTicketDate(_ticket.createdAt),
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(label: 'Categoria', value: _ticket.category),
                          const SizedBox(height: 12),
                          _InfoRow(
                            label: 'Prioridade',
                            value: _ticket.priority.label,
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            label: 'Responsavel',
                            value: _ticket.assignedTo,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Anexos e evidencias',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: const [
                              Expanded(
                                child: _AttachmentPreview(
                                  title: 'Print 01',
                                  subtitle: 'Erro no gateway',
                                  icon: Icons.image_outlined,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _AttachmentPreview(
                                  title: 'Logs',
                                  subtitle: 'Stack resumida',
                                  icon: Icons.description_outlined,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.stroke)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText:
                              'Escreva uma atualizacao para este chamado...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _sendReply,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpdateBubble extends StatelessWidget {
  const _UpdateBubble({required this.update});

  final TicketUpdate update;

  @override
  Widget build(BuildContext context) {
    final alignsRight = update.kind.alignsRight;

    return Align(
      alignment: alignsRight ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: update.kind.bubbleColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: alignsRight
                  ? update.kind.accentColor.withOpacity(0.10)
                  : AppColors.stroke,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: update.kind.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      update.kind == TicketUpdateKind.agent
                          ? Icons.support_agent_rounded
                          : update.kind == TicketUpdateKind.requester
                          ? Icons.person_rounded
                          : Icons.auto_awesome_rounded,
                      size: 16,
                      color: update.kind.accentColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          update.author,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          formatRelativeTime(update.createdAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                update.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: update.kind.textColor),
              ),
            ],
          ),
        ),
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
    return Row(
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  const _AttachmentPreview({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(subtitle),
            ],
          ),
        ],
      ),
    );
  }
}
