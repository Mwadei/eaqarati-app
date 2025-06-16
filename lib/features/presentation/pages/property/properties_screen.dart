import 'package:eaqarati_app/features/presentation/widgets/property_list_item.dart';
import 'package:eaqarati_app/features/presentation/widgets/property_list_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class PropertiesScreen extends HookWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 700),
    );

    useEffect(() {
      context.read<PropertyBloc>().add(LoadAllProperties());
      animationController.forward();
      return null;
    }, const []);

    // For the FAB animation
    final fabScaleController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fabScaleController, curve: Curves.elasticOut),
    );
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        // Delay FAB animation
        if (context.mounted) fabScaleController.forward();
      });
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, textTheme, colorScheme),
      body: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (context, state) {
          Widget bodyContent;

          if (state is PropertyLoading && state is! PropertiesLoaded) {
            bodyContent = ListView.builder(
              padding: const EdgeInsets.all(kPagePadding),
              itemCount: 5,
              itemBuilder: (ctx, idx) => const PropertyListItemShimmer(),
            );
          } else if (state is PropertiesLoaded) {
            if (state.properties.isEmpty) {
              bodyContent = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.villa_outlined,
                      size: 80,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: kVerticalSpaceMedium),
                    Text(
                      'propertiesScreen.properties_title'.tr(),
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: kVerticalSpaceSmall),
                    Text(
                      'propertiesScreen.properties_subtitle'.tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kVerticalSpaceMedium * 2),
                    Center(
                      child: Text(
                        'propertiesScreen.no_properties'.tr(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              bodyContent = RefreshIndicator(
                onRefresh: () async {
                  context.read<PropertyBloc>().add(LoadAllProperties());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: kPagePadding),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'propertiesScreen.properties_title'.tr(),
                              style: textTheme.titleLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: kVerticalSpaceSmall),
                            Text(
                              'propertiesScreen.properties_subtitle'.tr(),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.secondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: kVerticalSpaceMedium),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(kPagePadding),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildTotalPropertiesCard(
                            context,
                            state.properties.length,
                            animationController,
                          ),
                          const SizedBox(height: kVerticalSpaceMedium * 1.5),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPagePadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final property = state.properties[index];
                          final itemAnimation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                (0.3 +
                                        (0.7 *
                                            (index / state.properties.length)))
                                    .clamp(0.0, 1.0),
                                1.0,
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
                                      0,
                                      30 * (1 - itemAnimation.value),
                                    ),
                                    child: child,
                                  ),
                                ),
                            child: PropertyListItem(property: property),
                          );
                        }, childCount: state.properties.length),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: kPagePadding * 3),
                    ),
                  ],
                ),
              );
            }
          } else if (state is PropertyError) {
            bodyContent = Center(child: Text('Error: ${state.message}'));
          } else {
            bodyContent = const Center(
              child: CircularProgressIndicator(),
            ); // Initial or unexpected state
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: bodyContent,
          );
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: () async {
            final result = await context.push('/properties/form');
            if (result == true) {
              if (context.mounted) {
                context.read<PropertyBloc>().add(LoadAllProperties());
              }
            }
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4.0,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
      titleSpacing: kPagePadding,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(kVerticalSpaceSmall),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'E', // First letter of "Eaqarati"
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: kVerticalSpaceSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'app.name'.tr(), // "Eaqarati"
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'app.management_service'.tr(), // "Property Management"
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
          onPressed: () {
            /* TODO: Implement search */
          },
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            /* TODO: Navigate to Notifications Screen */
          },
        ),
        const SizedBox(width: kPagePadding / 2),
      ],
    );
  }

  Widget _buildTotalPropertiesCard(
    BuildContext context,
    int totalCount,
    AnimationController animationController,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: cardAnimation,
      builder:
          (context, child) => Opacity(
            opacity: cardAnimation.value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - cardAnimation.value)),
              child: child,
            ),
          ),
      child: Container(
        padding: const EdgeInsets.all(kPagePadding),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'propertiesScreen.total_properties_card_title'.tr(),
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: kVerticalSpaceSmall / 2),
                Text(
                  totalCount.toString(),
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(kPagePadding / 1.5),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.business_rounded,
                size: 32,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
