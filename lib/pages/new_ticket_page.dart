import 'package:flutter/material.dart';

import '../models/ticket.dart';

class NewTicketPage extends StatefulWidget {
  const NewTicketPage({super.key});

  @override
  State<NewTicketPage> createState() => _NewTicketPageState();
}

class _NewTicketPageState extends State<NewTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _requesterController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _requesterController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final suffix = (DateTime.now().millisecondsSinceEpoch % 100000)
        .toString()
        .padLeft(5, '0');

    final ticket = Ticket(
      id: 'HD-$suffix',
      title: _titleController.text.trim(),
      requester: _requesterController.text.trim(),
      description: _descriptionController.text.trim(),
      status: TicketStatus.open,
      createdAt: DateTime.now(),
    );

    Navigator.of(context).pop(ticket);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Novo chamado',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5F2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Abra um novo atendimento',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF163A30),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preencha as informacoes abaixo. O chamado sera criado com status inicial Aberto.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF58716A),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Titulo',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Ex.: Computador sem acesso a internet',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Informe o titulo do chamado.';
                    }
                    if (text.length < 5) {
                      return 'Use um titulo um pouco mais descritivo.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Text(
                  'Solicitante',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _requesterController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Nome de quem abriu o chamado',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Informe o nome do solicitante.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                Text(
                  'Descricao',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  minLines: 5,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    hintText: 'Descreva o problema, contexto e impacto.',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Descreva o problema do chamado.';
                    }
                    if (text.length < 10) {
                      return 'Adicione um pouco mais de contexto.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send_outlined),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Criar chamado'),
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
