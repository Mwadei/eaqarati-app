import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/presentation/blocs/lease/lease_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/scheduled_payment/scheduled_payment_bloc.dart';
import 'package:eaqarati_app/features/presentation/widgets/card_loading_shimmer.dart';
import 'package:eaqarati_app/features/presentation/widgets/summary_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecentActivityItemData {
  final ActivityType type;
  final String title;
  final String subtitle;
  final String time;
  RecentActivityItemData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class ReminderItemData {
  final ReminderType type;
  final String title;
  final String details;
  ReminderItemData({
    required this.type,
    required this.title,
    required this.details,
  });
}

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final overallAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );

    final listEntranceAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    useEffect(() {
      context.read<PropertyBloc>().add(LoadAllProperties());
      context.read<LeaseBloc>().add(LoadActiveLeases());
      context.read<ScheduledPaymentBloc>().add(LoadOverdueScheduledPayments());
      context.read<ScheduledPaymentBloc>().add(
        LoadScheduledPaymentsByLeaseId(-1),
      );
      context.read<ScheduledPaymentBloc>().add(
        LoadUpcomingScheduledPayments(
          fromDate: DateTime.now(),
          toDate: DateTime.now().add(const Duration(days: 7)),
        ),
      );

      overallAnimationController.forward();
      Future.delayed(
        const Duration(milliseconds: 200),
        () => listEntranceAnimationController.forward(),
      );
      return null;
    }, const []);

    // Placeholder data for sections not yet fully integrated with BLoCs
    final recentActivities = useState<List<RecentActivityItemData>>([
      RecentActivityItemData(
        type: ActivityType.payment,
        title: "Payment received from S. Johnson",
        subtitle: "Unit 4B - \$1,200",
        time: "2h ago",
      ),
      RecentActivityItemData(
        type: ActivityType.lease,
        title: "New lease: Unit 2A",
        subtitle: "Michael Chen",
        time: "5h ago",
      ),
    ]);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, textTheme, colorScheme),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPagePadding,
                  vertical: kVerticalSpaceMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSummaryCards(context, overallAnimationController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAppBar(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      floating: true,
      pinned: false,
      snap: true,
      titleSpacing: kPagePadding,
      centerTitle: false,
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard.title'.tr(),
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
          Text(
            'dashboard.welcome'.tr(),
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: kPagePadding - 8),
          child: IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 35,
            ),
            onPressed: () {
              /* TODO: Handle notification tap */
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    AnimationController animationController,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth * 0.38;
    final cardWidth =
        (screenWidth / 2 - kPagePadding - (kVerticalSpaceMedium / 2));
    final cardAspectRatio =
        cardWidth > 0 && cardHeight > 0 ? cardWidth / cardHeight : 1.0;

    return GridView.count(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: kVerticalSpaceMedium,
      mainAxisSpacing: kVerticalSpaceMedium,
      childAspectRatio: cardAspectRatio,
      children: [
        BlocBuilder<PropertyBloc, PropertyState>(
          builder: (context, state) {
            String count = "0";
            Widget? loadingWidget;
            if (state is PropertyLoading) {
              loadingWidget = const CardLoadingShimmer();
            }
            if (state is PropertiesLoaded) {
              count = state.properties.length.toString();
            }
            return SummaryCard(
              icon: Icons.home_work_outlined,
              iconColor: Theme.of(context).primaryColor,
              iconBgColor: Colors.blue.shade50,
              count: count,
              label: 'dashboard.total_properties'.tr(),
              animationController: animationController,
              itemIndex: 0,
              loadingWidget: loadingWidget,
            );
          },
        ),
        BlocBuilder<LeaseBloc, LeaseState>(
          builder: (context, state) {
            String count = "0";
            Widget? loadingWidget;
            if (state is LeaseLoading) {
              loadingWidget = const CardLoadingShimmer();
            }
            if (state is LeasesLoaded) {
              final occupiedUnit =
                  state.leases
                      .where((lease) => lease.isActive)
                      .map((lease) => lease.unitId)
                      .toSet();
              count = occupiedUnit.length.toString();
            }
            return SummaryCard(
              icon: Icons.people_alt_outlined,
              iconColor: Colors.green.shade700,
              iconBgColor: Colors.green.shade50,
              count: count,
              label: 'dashboard.occupied_units'.tr(),
              animationController: animationController,
              itemIndex: 1,
              loadingWidget: loadingWidget,
            );
          },
        ),
        BlocBuilder<ScheduledPaymentBloc, ScheduledPaymentState>(
          builder: (context, state) {
            String count = "0";
            Widget? loadingWidget;
            if (state is ScheduledPaymentsLoaded && state.props.isNotEmpty) {
              // Check props for specific list if bloc handles multiple
              final overdue =
                  state.scheduledPayments
                      .where(
                        (p) =>
                            p.dueDate.isBefore(DateTime.now()) &&
                            (p.status == ScheduledPaymentStatus.pending ||
                                p.status ==
                                    ScheduledPaymentStatus.partiallyPaid),
                      )
                      .toList();
              count = overdue.length.toString();
            }
            if (state is ScheduledPaymentLoading) {
              loadingWidget = const CardLoadingShimmer();
            }
            return SummaryCard(
              icon: Icons.timer_off_outlined, // Changed icon
              iconColor: Colors.orange.shade700,
              iconBgColor: Colors.orange.shade50,
              count: count,
              label: 'dashboard.overdue_payments'.tr(),
              animationController: animationController,
              itemIndex: 2,
              loadingWidget: loadingWidget,
            );
          },
        ),
        BlocBuilder<ScheduledPaymentBloc, ScheduledPaymentState>(
          builder: (context, state) {
            double revenue = 0.0;
            String countText = "\$0";
            Widget? loadingWidget;

            if (state is ScheduledPaymentsLoaded && state.props.isNotEmpty) {
              final now = DateTime.now();
              revenue = state.scheduledPayments
                  .where(
                    (p) =>
                        p.dueDate.year == now.year &&
                        p.dueDate.month == now.month &&
                        (p.status == ScheduledPaymentStatus.paid ||
                            p.status == ScheduledPaymentStatus.partiallyPaid),
                  )
                  .fold(0.0, (sum, item) => sum + item.amountPaidSoFar);
              countText = '${NumberFormat("#,##0", "en_US").format(revenue)}';
            }
            if (state is ScheduledPaymentLoading) {
              loadingWidget = const CardLoadingShimmer();
            }
            return SummaryCard(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: Theme.of(context).colorScheme.primary,
              iconBgColor: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.2),
              count: countText,
              label: 'dashboard.monthly_recipient'.tr(),
              animationController: animationController,
              itemIndex: 3,
              loadingWidget: loadingWidget,
            );
          },
        ),
      ],
    );
  }
}
