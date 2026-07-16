import 'package:flutter/material.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';

/// أنواع المركبات المتاحة للسائق.
const List<String> kVehicleTypes = [
  'شاحنة صغيرة',
  'سيارة',
  'دراجة نارية',
];

/// قائمة منسدلة لاختيار نوع المركبة بنفس تنسيق حقول الإدخال.
class VehicleTypeDropdown extends StatelessWidget {
  const VehicleTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
          style: AppTheme.titleM,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          validator: (selected) {
            if (selected == null) {
              return 'Vehicle type is required';
            }

            return null;
          },
          style: AppTheme.bodyL,
          dropdownColor: AppColors.bgCard,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textHint,
          ),
          hint: Text(
            'Select your vehicle type',
            style: AppTheme.bodyM,
          ),
          items: kVehicleTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.local_shipping_outlined,
            ),
            filled: true,
            fillColor: AppColors.bgCard,
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(18),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.divider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
