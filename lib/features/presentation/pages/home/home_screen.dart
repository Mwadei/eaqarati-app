import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/domain/entities/scheduled_payment_entity.dart';
import 'package:eaqarati_app/features/presentation/blocs/lease/lease_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/scheduled_payment/scheduled_payment_bloc.dart';
import 'package:eaqarati_app/features/presentation/widgets/activity_list_item.dart';
import 'package:eaqarati_app/features/presentation/widgets/card_loading_shimmer.dart';
import 'package:eaqarati_app/features/presentation/widgets/quick_action_button.dart';
import 'package:eaqarati_app/features/presentation/widgets/reminder_card.dart';
import 'package:eaqarati_app/features/presentation/widgets/summary_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  void _refreshData(BuildContext context) {
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
  }

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
      _refreshData(context);

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
      RecentActivityItemData(
        type: ActivityType.maintenance,
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
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
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
                    const SizedBox(height: kVerticalSpaceMedium * 1.5),
                    _buildQuickActions(
                      context,
                      textTheme,
                      colorScheme,
                      overallAnimationController,
                    ),
                    const SizedBox(height: kVerticalSpaceMedium * 3.5),
                    _buildRecentActivity(
                      context,
                      textTheme,
                      colorScheme,
                      recentActivities.value,
                      listEntranceAnimationController,
                    ),
                    const SizedBox(height: kVerticalSpaceMedium * 3.5),
                    _buildUpcomingReminders(
                      context,
                      textTheme,
                      colorScheme,
                      listEntranceAnimationController,
                    ),
                    const SizedBox(height: kVerticalSpaceMedium * 2),
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
              iconBgColor: Theme.of(context).primaryColor.withOpacity(0.1),
              count: count,
              label: 'dashboard.total_properties'.tr(),
              animationController: animationController,
              itemIndex: 0,
              loadingWidget: loadingWidget,
              onTap: () => context.push('/properties'),
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
              iconBgColor: Colors.green.withOpacity(0.1),
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
            if (state is ScheduledPaymentLoading) {
              loadingWidget = const CardLoadingShimmer();
            }
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
            return SummaryCard(
              icon: Icons.timer_off_outlined, // Changed icon
              iconColor: Colors.orange.shade700,
              iconBgColor: Colors.orange.withOpacity(0.1),
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
            String countText = "SAR 0";
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
              countText = NumberFormat("#,##0", "en_US").format(revenue);
            }
            if (state is ScheduledPaymentLoading) {
              loadingWidget = const CardLoadingShimmer();
            }
            return SummaryCard(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: Theme.of(context).colorScheme.primary,
              iconBgColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
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

  _buildQuickActions(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AnimationController overallAnimationController,
  ) {
    final actionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: overallAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: actionAnimation,
      builder:
          (context, child) =>
              Opacity(opacity: actionAnimation.value, child: child),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: colorScheme.shadow,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'dashboard.quick_actions'.tr(),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: kVerticalSpaceMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickActionButton(
                    icon: Icons.add_home_outlined,
                    label: 'dashboard.add_property'.tr(),
                    onTap: () async {
                      final result = await context.pushNamed('propertyForm');
                      if (result == true && context.mounted) {
                        _refreshData(context);
                      }
                    },
                  ),
                  QuickActionButton(
                    icon: Icons.person_add_outlined,
                    label: 'dashboard.add_tenant'.tr(),
                    onTap: () {},
                  ),
                  QuickActionButton(
                    icon: Icons.payments_outlined,
                    label: 'dashboard.add_payment'.tr(),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
    VoidCallback onViewAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 26,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
          child: Text(
            'dashboard.view_all'.tr(),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  _buildRecentActivity(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    List<RecentActivityItemData> activities,
    AnimationController animationController,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: kVerticalSpaceSmall / 2,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              activities.isEmpty
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: kPagePadding,
                      ),
                      child: Text(
                        "dashboard.no_recent_activity".tr(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: _buildSectionHeader(
                          context,
                          textTheme,
                          colorScheme,
                          'dashboard.recent_activity'.tr(),
                          () {
                            /* TODO: Navigate to All Activities */
                          },
                        ),
                      ),
                      const SizedBox(height: kVerticalSpaceSmall),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            activities.length > 3 ? 3 : activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          final itemAnimation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                (0.1 * index).clamp(0.0, 1.0),
                                (0.1 * index + 0.7).clamp(0.0, 1.0),
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                          );
                          return AnimatedBuilder(
                            animation: itemAnimation,
                            builder:
                                (context, child) => Opacity(
                                  opacity: itemAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0.0,
                                      30 * (1.0 - itemAnimation.value),
                                    ),
                                    child: child,
                                  ),
                                ),
                            child: ActivityListItem(activity: activity),
                          );
                        },
                        separatorBuilder:
                            (context, index) => Divider(
                              height: 0.5,
                              thickness: 0.5,
                              indent: 60,
                              endIndent: 16,
                              color: Theme.of(context).dividerColor,
                            ),
                      ),
                    ],
                  ),
        ),
      ],
    );
  }

  _buildUpcomingReminders(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AnimationController animationController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          textTheme,
          colorScheme,
          'dashboard.upcoming_reminders'.tr(),
          () {
            /* TODO: Navigate to All Reminders */
          },
        ),
        const SizedBox(height: kVerticalSpaceSmall),
        BlocBuilder<ScheduledPaymentBloc, ScheduledPaymentState>(
          builder: (context, state) {
            Widget content;
            if (state is ScheduledPaymentLoading &&
                state.operationKey == 'upcoming') {
              content = const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            } else if (state is UpcomingScheduledPaymentsLoaded) {
              final now = DateTime.now();
              final upcomingRentPayments = state.upcomingPayments;

              // TODO: Integrate LeaseBloc for lease renewals and combine with upcomingRentPayments
              // For now, using placeholder for renewals
              // final placeholderRenewals = [
              //   if (upcomingRentPayments.length < 2)
              //     ReminderItemData(
              //       type: ReminderType.rent,
              //       title: "dashboard.sample_lease_renewal_due".tr(),
              //       details: "Unit 5A • Emily Davis • In 5 days",
              //     ),
              // ];

              List<ReminderItemData> displayReminders = [];

              if (upcomingRentPayments.isNotEmpty) {
                Map<DateTime, List<ScheduledPaymentEntity>> groupedByDate = {};
                for (var payment in upcomingRentPayments) {
                  final dayOnly = DateTime(
                    payment.dueDate.year,
                    payment.dueDate.month,
                    payment.dueDate.day,
                  );
                  groupedByDate.putIfAbsent(dayOnly, () => []).add(payment);
                }

                groupedByDate.forEach((date, payments) {
                  final int diffDays =
                      date
                          .difference(DateTime(now.year, now.month, now.day))
                          .inDays;
                  String title;
                  if (diffDays == 0) {
                    title = "dashboard.rent_due_today".tr();
                  } else if (diffDays == 1) {
                    title = "dashboard.rent_due_tomorrow".tr();
                  } else {
                    title = "dashboard.rent_due_in_days".tr(
                      args: [diffDays.toString()],
                    );
                  }

                  double totalAmount = payments.fold(
                    0.0,
                    (sum, p) => sum + (p.amountDue - p.amountPaidSoFar),
                  );
                  displayReminders.add(
                    ReminderItemData(
                      type: ReminderType.rent,
                      title: title,
                      details: 'dashboard.rent_reminder_details'.tr(
                        namedArgs: {
                          'count': payments.length.toString(),
                          'amount': NumberFormat.currency(
                            symbol: '/SAR',
                            decimalDigits: 0,
                          ).format(totalAmount),
                        },
                      ),
                    ),
                  );
                });
              }
              // Combine with lease renewal reminders when LeaseBloc is integrated
              // displayReminders.addAll(placeholderRenewals);

              if (displayReminders.isEmpty) {
                content = Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: kPagePadding),
                    child: Text(
                      "dashboard.no_upcoming_reminders".tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                );
              } else {
                content = ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: displayReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = displayReminders[index];
                    final itemAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animationController,
                        curve: Interval(
                          (0.2 * index).clamp(0.0, 1.0),
                          (0.2 * index + 0.8).clamp(0.0, 1.0),
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    );
                    return AnimatedBuilder(
                      animation: itemAnimation,
                      builder:
                          (context, child) => Opacity(
                            opacity: itemAnimation.value,
                            child: Transform.translate(
                              offset: Offset(
                                0.0,
                                20 * (1.0 - itemAnimation.value),
                              ),
                              child: child,
                            ),
                          ),
                      child: ReminderCard(reminder: reminder),
                    );
                  },
                );
              }
            } else if (state is ScheduledPaymentError) {
              content = Center(
                child: Text(
                  'dashboard.error_loading_reminders'.tr(args: [state.message]),
                ),
              );
            } else {
              content = Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPagePadding),
                  child: Text(
                    "dashboard.no_upcoming_reminders".tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: content,
            );
          },
        ),
      ],
    );
  }
}
