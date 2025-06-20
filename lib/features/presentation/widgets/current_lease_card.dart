import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/entities/tenant_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CurrentLeaseCard extends StatelessWidget {
  final LeaseEntity lease;
  final TenantEntity tenant;
  const CurrentLeaseCard({
    super.key,
    required this.lease,
    required this.tenant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final DateFormat dateFormat = DateFormat(
      'MMM d, yyyy',
      context.locale.toString(),
    );

    return Card(
      elevation: 1,
      shadowColor: colorScheme.shadow.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(kPagePadding / 1.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: const Color(0xFF16A34A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: kVerticalSpaceSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'unit_details.current_lease_title'.tr(),
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'unit_details.active_lease_info'.tr(),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: kVerticalSpaceMedium),
            Container(
              padding: const EdgeInsets.all(kPagePadding / 1.5),
              decoration: BoxDecoration(
                color:
                    colorScheme
                        .background, // Slightly different background for inner card
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLeaseDetailItem(
                        context,
                        'unit_details.tenant_name'.tr(),
                        tenant.fullName,
                      ),
                      _buildLeaseDetailItem(
                        context,
                        'unit_details.monthly_rent'.tr(),
                        NumberFormat.currency(
                          locale: context.locale.toString(),
                          symbol: 'unit_details.currency'.tr(),
                          decimalDigits: 0,
                        ).format(lease.rentAmount),
                        valueColor: const Color(0xFF16A34A),
                      ),
                    ],
                  ),
                  const SizedBox(height: kVerticalSpaceMedium * 0.75),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLeaseDetailItem(
                        context,
                        'unit_details.lease_start'.tr(),
                        dateFormat.format(lease.startDate),
                      ),
                      _buildLeaseDetailItem(
                        context,
                        'unit_details.lease_end'.tr(),
                        dateFormat.format(lease.endDate),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kVerticalSpaceMedium),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Lease Details Screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor, // blue-500
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'unit_details.view_lease_details_button'.tr(),
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaseDetailItem(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: valueColor ?? colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
