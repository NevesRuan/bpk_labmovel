import 'package:flutter/material.dart';
import '../../../models/emprestimo_model.dart';
import '../../../utils/app_colors.dart';

// widget para exibir um badge de status do emprestimo
class EmprestimoStatusBadge extends StatelessWidget {
  final EmprestimoModel emprestimo;
  final double fontSize;
  final bool showIcon;

  const EmprestimoStatusBadge({
    super.key,
    required this.emprestimo,
    this.fontSize = 11,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusData.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(statusData.icon, color: AppColors.white, size: fontSize + 2),
            const SizedBox(width: 4),
          ],
          Text(
            statusData.text,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  _StatusData _getStatusData() {
    if (emprestimo.isPendente) {
      return _StatusData(
        color: AppColors.warning,
        text: 'Pendente',
        icon: Icons.pending,
      );
    } else if (emprestimo.isRecusado) {
      return _StatusData(
        color: AppColors.error,
        text: 'Recusado',
        icon: Icons.cancel,
      );
    } else if (emprestimo.isDevolvido) {
      return _StatusData(
        color: AppColors.success,
        text: 'Devolvido',
        icon: Icons.check_circle,
      );
    } else if (emprestimo.isAtivo) {
      return _StatusData(
        color: AppColors.primary,
        text: 'Ativo',
        icon: Icons.check_circle,
      );
    } else {
      return _StatusData(
        color: AppColors.grey,
        text: '?',
        icon: Icons.help,
      );
    }
  }
}

/// Badge de status mais elaborado com borda e fundo semi-transparente
/// 
/// Versão alternativa do badge com design mais destacado,
/// usado em páginas de detalhes.
class EmprestimoStatusBadgeLarge extends StatelessWidget {
  final EmprestimoModel emprestimo;

  const EmprestimoStatusBadgeLarge({
    super.key,
    required this.emprestimo,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusData.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusData.color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusData.icon, color: statusData.color, size: 16),
          const SizedBox(width: 8),
          Text(
            statusData.text,
            style: TextStyle(
              color: statusData.color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  _StatusData _getStatusData() {
    if (emprestimo.isPendente) {
      return _StatusData(
        color: AppColors.warning,
        text: 'Pendente',
        icon: Icons.pending,
      );
    } else if (emprestimo.isRecusado) {
      return _StatusData(
        color: AppColors.error,
        text: 'Recusado',
        icon: Icons.cancel,
      );
    } else if (emprestimo.isDevolvido) {
      return _StatusData(
        color: AppColors.success,
        text: 'Devolvido',
        icon: Icons.check_circle,
      );
    } else if (emprestimo.isAtivo) {
      return _StatusData(
        color: AppColors.info,
        text: 'Ativo',
        icon: Icons.check_circle,
      );
    } else {
      return _StatusData(
        color: AppColors.grey,
        text: 'Desconhecido',
        icon: Icons.help,
      );
    }
  }
}

/// Classe auxiliar para dados de status
class _StatusData {
  final Color color;
  final String text;
  final IconData icon;

  _StatusData({
    required this.color,
    required this.text,
    required this.icon,
  });
}

/// Utilitário para obter a cor de status do empréstimo
/// 
/// Função helper para widgets que precisam apenas da cor
Color getEmprestimoStatusColor(EmprestimoModel emprestimo) {
  if (emprestimo.isPendente) {
    return AppColors.warning;
  } else if (emprestimo.isRecusado) {
    return AppColors.error;
  } else if (emprestimo.isDevolvido) {
    return AppColors.success;
  } else if (emprestimo.isAtivo) {
    return AppColors.primary;
  } else {
    return AppColors.grey;
  }
}
