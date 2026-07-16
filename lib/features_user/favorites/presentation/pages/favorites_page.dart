import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/favorite_button.dart';
import '../../../home/presentation/widgets/product_preview_card.dart';
import '../../../home/presentation/widgets/store_card.dart';
import '../../../product/presentation/pages/product_details_page.dart';
import '../../../product/presentation/pages/product_page.dart';
import '../manager/favorites_cubit.dart';
import '../manager/favorites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final int totalCount =
            state.favorites.length +
                state.favoriteStores.length;

        return SafeArea(
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
                  14,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'My Favorites',
                          style: AppTheme.titleXL,
                        ),
                      ),
                      Text(
                        '$totalCount items',
                        style: AppTheme.labelM,
                      ),
                    ],
                  ),
                ),
              ),
              if (state.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyFavorites(),
                )
              else ...[
                if (state
                    .favoriteStores.isNotEmpty) ...[
                  SliverPadding(
                    padding:
                    const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      14,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _SectionHeader(
                        title: 'Stores',
                        subtitle:
                        '${state.favoriteStores.length} stores',
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    sliver: SliverList(
                      delegate:
                      SliverChildBuilderDelegate(
                            (context, index) {
                          final store = state
                              .favoriteStores[index];

                          return Padding(
                            padding:
                            const EdgeInsets.only(
                              bottom: 14,
                            ),
                            child: SizedBox(
                              height: 150,
                              child: StoreCard(
                                store: store,
                                onFavoritePressed:
                                    () {
                                  context
                                      .read<
                                      FavoritesCubit>()
                                      .toggleStoreFavorite(
                                    store,
                                  );
                                },
                                onTap: () {
                                  Navigator
                                      .pushNamed(
                                    context,
                                    ProductPage
                                        .route,
                                    arguments:
                                    store,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        childCount: state
                            .favoriteStores.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 10),
                  ),
                ],
                if (state
                    .favorites.isNotEmpty) ...[
                  SliverPadding(
                    padding:
                    const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      14,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _SectionHeader(
                        title: 'Products',
                        subtitle:
                        '${state.favorites.length} products',
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding:
                    const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      30,
                    ),
                    sliver: SliverGrid(
                      delegate:
                      SliverChildBuilderDelegate(
                            (context, index) {
                          final product =
                          state.favorites[index];

                          final String heroTag =
                              'favorites-product-image-${product.id}';

                          return Stack(
                            children: [
                              Positioned.fill(
                                child:
                                ProductPreviewCard(
                                  product: product,
                                  heroTag: heroTag,
                                  onTap: () {
                                    Navigator
                                        .pushNamed(
                                      context,
                                      ProductDetailsPage
                                          .route,
                                      arguments: {
                                        'product':
                                        product,
                                        'heroTag':
                                        heroTag,
                                      },
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child:
                                FavoriteButton(
                                  isFavorite: true,
                                  onPressed: () {
                                    context
                                        .read<
                                        FavoritesCubit>()
                                        .toggleFavorite(
                                      product,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                        childCount:
                        state.favorites.length,
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
                ],
              ],
            ],
          ),
        );
      },
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

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              size: 70,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 18),
            Text(
              'No Favorites Yet',
              style: AppTheme.titleL,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any product or store to save it here.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyM,
            ),
          ],
        ),
      ),
    );
  }
}
