import 'package:flutter/material.dart';
import '../../../models/emprestimo_model.dart';
import '../../../utils/app_colors.dart';
import 'emprestimo_status_badge.dart';

// card de emprestimo para lista de historico
class HistoricoEmprestimoCard extends StatelessWidget {
  final EmprestimoModel emprestimo;
  final int numero;
  final VoidCallback onTap;

  const HistoricoEmprestimoCard({
    super.key,
    required this.emprestimo,
    required this.numero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // faixa de cor lateral indicando status
            Container(
              width: 6,
              height: 82,
              decoration: BoxDecoration(
                color: getEmprestimoStatusColor(emprestimo),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // conteudo do card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              EmprestimoStatusBadge(emprestimo: emprestimo),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _formatarTituloEmprestimo(emprestimo.criadoEm),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${emprestimo.codigosEquipamentos.length} ${emprestimo.codigosEquipamentos.length == 1 ? 'equipamento' : 'equipamentos'}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatarHora(emprestimo.criadoEm),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarTituloEmprestimo(DateTime data) {
    const meses = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return '${data.day} ${meses[data.month - 1]} ${data.year}';
  }

  String _formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }
}

/// Estado vazio para quando não há empréstimos
class HistoricoEmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;

  const HistoricoEmptyState({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.history,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.divider,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
