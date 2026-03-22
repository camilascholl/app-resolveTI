import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_widgets.dart';
import '../models/ticket.dart';

class NewTicketPage extends StatefulWidget {
  const NewTicketPage({super.key, required this.onCreateTicket});

  final ValueChanged<Ticket> onCreateTicket;

  @override
  State<NewTicketPage> createState() => _NewTicketPageState();
}

class _NewTicketPageState extends State<NewTicketPage> {
  static const _categories = [
    'Infra',
    'Acesso',
    'Pagamentos',
    'Relatórios',
    'Hardware',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = _categories.first;
  TicketPriority _selectedPriority = TicketPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = _categories.first;
      _selectedPriority = TicketPriority.medium;
    });
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final suffix = (DateTime.now().millisecondsSinceEpoch % 10000)
        .toString()
        .padLeft(4, '0');

    final ticket = Ticket(
      id: 'HD-$suffix',
      title: _titleController.text.trim(),
      requester: 'Camila Scholl',
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      assignedTo: _selectedCategory == 'Infra'
          ? 'Ananda Santos'
          : _selectedCategory == 'Hardware'
          ? 'Shaiane Silva'
          : 'Guilherme Maranho',
      status: TicketStatus.open,
      priority: _selectedPriority,
      createdAt: DateTime.now(),
      updates: [
        TicketUpdate(
          author: 'Sistema',
          message: 'Chamado criado e enviado para triagem inicial.',
          createdAt: DateTime.now(),
          kind: TicketUpdateKind.system,
        ),
      ],
    );

    widget.onCreateTicket(ticket);
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const AppTopBar(
            title: 'Novo Chamado',
            subtitle:
                'Registre a ocorrência com contexto claro para acelerar a fila.',
            leadingIcon: Icons.post_add_rounded,
            actions: [
              TopBarIconButton(icon: Icons.help_outline_rounded),
              AvatarBadge(initials: 'CS'),
            ],
          ),
          const SizedBox(height: 20),
          AppPanel(
            gradient: const LinearGradient(
              colors: [Color(0xFFEDF4FF), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBadge(
                  label: 'Solicitação de suporte',
                  backgroundColor: AppColors.primary.withOpacity(0.10),
                  foregroundColor: AppColors.primary,
                  icon: Icons.flash_on_rounded,
                ),
                const SizedBox(height: 14),
                Text('Novo chamado', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Descreva o problema para que nossa equipe possa agir mais rápido e priorizar o atendimento certo.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Título do problema', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Erro ao acessar o servidor de arquivos',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Informe um título para o chamado.';
                    }
                    if (text.length < 8) {
                      return 'Deixe o título um pouco mais descritivo.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text('Categoria', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    hintText: 'Selecione uma categoria',
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text('Prioridade', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final priority in TicketPriority.values)
                      ChoiceChip(
                        label: Text(priority.label),
                        avatar: Icon(priority.icon, size: 18),
                        selected: _selectedPriority == priority,
                        selectedColor: priority.containerColor,
                        side: BorderSide.none,
                        onSelected: (_) {
                          setState(() {
                            _selectedPriority = priority;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Descrição detalhada', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 6,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText:
                        'Forneca o máximo de contexto possível, incluindo impacto no negócio, horário e evidências.',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Explique o problema para a equipe.';
                    }
                    if (text.length < 20) {
                      return 'Adicione um pouco mais de contexto.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text('Anexos', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Arraste um arquivo, vídeo ou print para fortalecer a triagem.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'MP4, PNG, JPG, PDF max 10 MB',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Enviar solicitação'),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Categoria e prioridade ajudam a mapear o chamado.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dicas rápidas', style: theme.textTheme.titleMedium),
                const SizedBox(height: 14),
                const _TipRow(
                  icon: Icons.check_circle_outline_rounded,
                  text:
                      'Inclua mensagens de erro, horário e impacto no negócio.',
                ),
                const SizedBox(height: 10),
                const _TipRow(
                  icon: Icons.rule_folder_outlined,
                  text:
                      'Informe o sistema ou a área afetada para agilizar o mapeamento.',
                ),
                const SizedBox(height: 10),
                const _TipRow(
                  icon: Icons.shield_outlined,
                  text:
                      'Marque prioridade alta apenas quando houver impacto operacional real.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}
