import 'package:flutter/material.dart';
import '../../../models/emprestimo_model.dart';
import '../../../utils/app_colors.dart';

// card de informacoes do emprestimo
class EmprestimoInfoCard extends StatelessWidget {
  final EmprestimoModel emprestimo;

  const EmprestimoInfoCard({
    super.key,
    required this.emprestimo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InfoRow(
            icon: Icons.calendar_today,
            label: 'Solicitado em',
            value: _formatarDataCompleta(emprestimo.criadoEm),
          ),
          if (emprestimo.confirmedoEm != null) ...[
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.check_circle_outline,
              label: emprestimo.isConfirmado ? 'Confirmado em' : 'Recusado em',
              value: _formatarDataCompleta(emprestimo.confirmedoEm!),
            ),
          ],
          if (emprestimo.devolvidoEm != null) ...[
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.assignment_turned_in,
              label: 'Devolvido em',
              value: _formatarDataCompleta(emprestimo.devolvidoEm!),
            ),
          ],
          if (emprestimo.isConfirmado && !emprestimo.isDevolvido) ...[
            const SizedBox(height: 12),
            PrazoWarningBox(emprestimo: emprestimo),
          ],
          if (emprestimo.atrasado) ...[
            const SizedBox(height: 12),
            const AtrasadoWarningBox(),
          ],
        ],
      ),
    );
  }

  String _formatarDataCompleta(DateTime data) {
    const meses = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];
    return '${data.day} ${meses[data.month - 1]} ${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }
}

/// Widget para exibir uma linha de informação no card
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Box de aviso de prazo (ativo ou atrasado)
class PrazoWarningBox extends StatelessWidget {
  final EmprestimoModel emprestimo;

  const PrazoWarningBox({
    super.key,
    required this.emprestimo,
  });

  @override
  Widget build(BuildContext context) {
    final isAtrasado = emprestimo.isAtrasadoAtual;
    final color = isAtrasado ? AppColors.error : AppColors.warning;
    final backgroundColor = isAtrasado ? AppColors.errorLight : AppColors.warningLight;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            isAtrasado ? Icons.warning : Icons.schedule,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAtrasado ? 'PRAZO VENCIDO!' : 'Prazo de devolução',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Até ${emprestimo.prazoLimiteDevolucao.day.toString().padLeft(2, '0')}/${emprestimo.prazoLimiteDevolucao.month.toString().padLeft(2, '0')} às 22:30',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Box de aviso para empréstimos devolvidos com atraso
class AtrasadoWarningBox extends StatelessWidget {
  const AtrasadoWarningBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error, width: 1),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning, color: AppColors.error, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Este empréstimo foi devolvido com atraso',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
