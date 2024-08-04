import 'package:flutter/material.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';

class SelectedEntityWidget extends StatelessWidget {
  final EntityViewModel entity;
  final VoidCallback onTap;

  const SelectedEntityWidget({
    super.key,
    required this.entity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              const SizedBox(width: 4),
              Text(
                entity.name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 8),
              const Spacer(),
              Icon(
                Icons.arrow_drop_down_sharp,
                color: colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
