import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';

import '../../../authentication/presentation/manager/auth_cubit.dart';
import '../../../orders/presentation/pages/order_page.dart';

import '../../../product/presentation/pages/product_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../manager/home_cubit.dart';
import '../manager/home_state.dart';
import '../manager/navigation_cubit.dart';
import '../widgets/product_preview_card.dart';
import '../widgets/store_card.dart';
import '../../../product/presentation/pages/product_details_page.dart';
class HomePage extends StatelessWidget {
  static const String route = '/user-home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, navigationState) {
        return Scaffold(
          body: IndexedStack(
            index: navigationState.selectedIndex,
            children: const [
              _HomeContent(),
              OrdersPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex:
            navigationState.selectedIndex,
            onDestinationSelected: context
                .read<NavigationCubit>()
                .changePage,
            backgroundColor: AppColors.bgSheet,
            indicatorColor:
            AppColors.primary.withOpacity(0.18),
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                ),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: AppColors.primary,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.receipt_long_outlined,
                ),
                selectedIcon: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                ),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline_rounded,
                ),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading ||
            state.status == HomeStatus.initial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == HomeStatus.failure) {
          return _HomeError(
            message: state.errorMessage,
          );
        }

        final user =
            context.read<AuthCubit>().state.user;

        return SafeArea(
          child: RefreshIndicator(
            onRefresh:
            context.read<HomeCubit>().loadHome,
            child: CustomScrollView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _HomeHeader(
                      name: user?.fullName ?? 'User',
                      address:
                      user?.address ?? 'Your location',
                    ),
                  ),
                ),
                SliverPadding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _SearchField(
                      onChanged: context
                          .read<HomeCubit>()
                          .searchStores,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverPadding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _PromotionalBanner(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
                SliverPadding(
                  padding:
                  const EdgeInsets.only(left: 20),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                        const EdgeInsets.only(
                          right: 20,
                        ),
                        itemCount:
                        HomeCubit.categories.length,
                        separatorBuilder: (_, __) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          final category =
                          HomeCubit.categories[index];

                          final bool selected =
                              state.selectedCategory ==
                                  category;

                          return ChoiceChip(
                            selected: selected,
                            label: Text(category),
                            onSelected: (_) {
                              context
                                  .read<HomeCubit>()
                                  .selectCategory(
                                category,
                              );
                            },
                            selectedColor:
                            AppColors.primary,
                            backgroundColor:
                            AppColors.bgCard,
                            side: const BorderSide(
                              color: AppColors.divider,
                            ),
                            labelStyle:
                            AppTheme.labelM.copyWith(
                              color: selected
                                  ? AppColors.textPrimary
                                  : AppColors
                                  .textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
                SliverPadding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Nearby Stores',
                      subtitle:
                      '${state.filteredStores.length} stores',
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 14),
                ),
                SliverPadding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: state.filteredStores.isEmpty
                        ? const _EmptySearch()
                        : ListView.separated(
                      shrinkWrap: true,
                      physics:
                      const NeverScrollableScrollPhysics(),
                      itemCount:
                      state.filteredStores.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(
                          height: 14,
                        );
                      },
                      itemBuilder:
                          (context, index) {
                        final store = state
                            .filteredStores[index];

                        return SizedBox(
                          height: 150,
                          child: StoreCard(
                            store: store,
                            onFavoritePressed: () {
                              context
                                  .read<HomeCubit>()
                                  .toggleStoreFavorite(
                                store.id,
                              );
                            },
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ProductPage.route,
                                arguments: store,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 28),
                ),
                const SliverPadding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Popular Products',
                      subtitle: 'Trending now',
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 14),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 246,
                    child: ListView.separated(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                      state.popularProducts.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(width: 14);
                      },
                      itemBuilder: (context, index) {
                        final product = state.popularProducts[index];

                        return ProductPreviewCard(
                          width: 172,
                          product: product,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ProductDetailsPage.route,
                              arguments: product,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 28),
                ),
                const SliverPadding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Recommended For You',
                      subtitle: 'Picked for you',
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 14),
                ),
                SliverPadding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverGrid(
                    delegate:
                    SliverChildBuilderDelegate(
                          (context, index) {
                            final product =
                            state.recommendedProducts[index];

                            return ProductPreviewCard(
                              product: product,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ProductDetailsPage.route,
                                  arguments: product,
                                );
                              },
                            );
                      },
                      childCount:
                      state.recommendedProducts.length,
                    ),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 30),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.name,
    required this.address,
  });

  final String name;
  final String address;

  @override
  Widget build(BuildContext context) {
    final String firstName =
        name.trim().split(' ').first;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            firstName.isEmpty
                ? 'U'
                : firstName
                .substring(0, 1)
                .toUpperCase(),
            style: AppTheme.titleL,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $firstName',
                style: AppTheme.titleL,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.labelM,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppTheme.bodyL,
      decoration: InputDecoration(
        hintText:
        'Search stores, categories or descriptions',
        hintStyle: AppTheme.bodyM,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textHint,
        ),
        filled: true,
        fillColor: AppColors.bgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.divider,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.divider,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _PromotionalBanner extends StatefulWidget {
  const _PromotionalBanner();

  @override
  State<_PromotionalBanner> createState() =>
      _PromotionalBannerState();
}

class _PromotionalBannerState
    extends State<_PromotionalBanner> {
  final PageController _controller =
  PageController();

  int _selectedIndex = 0;

  final List<(String, String, IconData)> _items = const [
    (
    '40% OFF',
    'Discover special food offers today.',
    Icons.fastfood_rounded,
    ),
    (
    'New Electronics',
    'Upgrade your devices with fresh deals.',
    Icons.devices_rounded,
    ),
    (
    'Fresh Styles',
    'Explore the latest fashion collections.',
    Icons.checkroom_rounded,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 174,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _items.length,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final item = _items[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text(
                              item.$1,
                              style:
                              AppTheme.titleXL,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.$2,
                              style:
                              AppTheme.bodyL,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        item.$3,
                        size: 70,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: List.generate(
              _items.length,
                  (index) {
                final bool selected =
                    index == _selectedIndex;

                return AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 250),
                  width: selected ? 22 : 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary
                        : AppColors.divider,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTheme.titleL,
          ),
        ),
        Text(
          subtitle,
          style: AppTheme.labelM,
        ),
      ],
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 54,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 14),
          Text(
            'No stores found',
            style: AppTheme.titleM,
          ),
          const SizedBox(height: 7),
          Text(
            'Try another name, category or description.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyM,
          ),
        ],
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 68,
              color: AppColors.offline,
            ),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTheme.bodyL,
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed:
              context.read<HomeCubit>().loadHome,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}