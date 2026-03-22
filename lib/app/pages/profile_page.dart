import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.openTickets,
    required this.inProgressTickets,
    required this.resolvedRate,
  });

  final int openTickets;
  final int inProgressTickets;
  final int resolvedRate;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _pushNotifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        const AppTopBar(
          title: 'Perfil do Usuário',
          subtitle: 'Ajustes da conta, preferências do app e segurança.',
          leadingIcon: Icons.person_pin_rounded,
          actions: [
            TopBarIconButton(icon: Icons.tune_rounded),
            AvatarBadge(initials: 'CA'),
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
            children: [
              Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 34,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Camila Scholl',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text('camila.scholl@helpdesk.com'),
                        const SizedBox(height: 6),
                        AppBadge(
                          label: 'Auxiliar de Suporte',
                          backgroundColor: AppColors.secondary.withOpacity(
                            0.12,
                          ),
                          foregroundColor: AppColors.secondary,
                          icon: Icons.workspace_premium_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ProfileMetricCard(
                      label: 'Chamados abertos',
                      value: widget.openTickets.toString(),
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileMetricCard(
                      label: 'Em andamento',
                      value: widget.inProgressTickets.toString(),
                      color: AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileMetricCard(
                      label: 'Concluídos',
                      value: '${widget.resolvedRate}%',
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Configuracoes do app', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _pushNotifications,
                title: const Text('Alerta de notifiações'),
                subtitle: const Text('Receber alertas de novos chamados'),
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              const Divider(),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _darkMode,
                title: const Text('Modo escuro'),
                subtitle: const Text('Disponível em breve'),
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
              const Divider(),
              const _ProfileActionTile(
                icon: Icons.language_rounded,
                title: 'Idioma',
                subtitle: 'Português (Brasil)',
              ),
              const Divider(),
              const _ProfileActionTile(
                icon: Icons.security_rounded,
                title: 'Gerenciar segurança',
                subtitle: 'Senha e dispositivos confiáveis',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ações da conta', style: theme.textTheme.titleMedium),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.manage_accounts_outlined),
                  label: const Text('Atualizar perfil'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.tertiary,
                    side: const BorderSide(color: Color(0xFFF2C9C9)),
                  ),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sair da conta'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMetricCard extends StatelessWidget {
  const _ProfileMetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.textMuted,
        ),
      ],
    );
  }
}
