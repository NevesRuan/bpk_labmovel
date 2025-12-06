import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

// widget para exibir um filtro de data no historico
class DateFilterButton extends StatelessWidget {
  final DateTime? selectedDate;
  final String label;
  final VoidCallback onPressed;

  const DateFilterButton({
    super.key,
    required this.selectedDate,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calendar_today),
      label: Text(
        selectedDate != null
            ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
            : label,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}

// widget para exibir botao de limpar filtros
class ClearFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ClearFiltersButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.clear),
      label: const Text('Limpar Filtros'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
      ),
    );
  }
}

// widget para exibir filtros de data completos (data inicial e final)
class DateRangeFilter extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectEndDate;
  final VoidCallback onClearFilters;

  const DateRangeFilter({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onSelectStartDate,
    required this.onSelectEndDate,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DateFilterButton(
                  selectedDate: startDate,
                  label: 'Data Inicial',
                  onPressed: onSelectStartDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DateFilterButton(
                  selectedDate: endDate,
                  label: 'Data Final',
                  onPressed: onSelectEndDate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (startDate != null || endDate != null)
            Align(
              alignment: Alignment.centerRight,
              child: ClearFiltersButton(onPressed: onClearFilters),
            ),
        ],
      ),
    );
  }
}
