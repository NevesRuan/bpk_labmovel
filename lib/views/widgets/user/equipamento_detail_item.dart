import 'package:flutter/material.dart';
import '../../../models/equipamento.dart';
import '../../../utils/app_colors.dart';

// item de equipamento para lista de detalhes do emprestimo
class EquipamentoDetailItem extends StatelessWidget {
  final Equipamento? equipamento;
  final int numero;

  const EquipamentoDetailItem({
    super.key,
    required this.equipamento,
    required this.numero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Número sequencial
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$numero',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // informacoes do equipamento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equipamento?.displayName ?? 'Equipamento',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'CÓD: ${equipamento?.codigo ?? '—'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
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

/// Widget de loading para quando os equipamentos estão sendo carregados
class EquipamentoListLoading extends StatelessWidget {
  const EquipamentoListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Título da seção de equipamentos
class EquipamentoSectionTitle extends StatelessWidget {
  const EquipamentoSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Equipamentos',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}
