import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/home_cubit.dart';
import '../../../widgets/filter_chips_row.dart';
import '../../../../../../core/theme/app_theme.dart';

class FiltersSection extends StatelessWidget {
  final HomeLoaded state;

  const FiltersSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'BY TYPE',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5),
          ),
        ),
        FilterChipsRow(
          options: const [
            'fire',
            'water',
            'grass',
            'electric',
            'psychic',
            'dragon',
            'dark',
            'fighting',
          ],
          selected: state.selectedType,
          onSelected: (t) => context.read<HomeCubit>().onTypeFilterSelected(t),
          colorMap: AppTheme.typeColors,
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'BY ROLE',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5),
          ),
        ),
        FilterChipsRow(
          options: const ['Tank', 'Speedster', 'Glass Cannon', 'Balanced'],
          selected: state.selectedRole,
          onSelected: (r) => context.read<HomeCubit>().onRoleFilterSelected(r),
          colorMap: AppTheme.roleColors,
        ),
      ],
    );
  }
}
