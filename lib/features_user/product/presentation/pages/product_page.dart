import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../home/domain/entities/store_entity.dart';
import '../manager/product_cubit.dart';
import '../manager/product_state.dart';
import '../widgets/product_card.dart';
import 'product_details_page.dart';

class ProductPage extends StatefulWidget {
  static const String route = '/products';

  const ProductPage({
    super.key,
    required this.store,
  });

  final StoreEntity store;

  @override
  State<ProductPage> createState() =>
      _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ProductCubit>()
          .loadProducts(widget.store);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.store.name),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border_rounded,
                ),
              ),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context,
      ProductState state,
      ) {
    if (state.status == ProductStatus.initial ||
        state.status == ProductStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == ProductStatus.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: AppColors.offline,
                size: 70,
              ),
              const SizedBox(height: 18),
              Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: AppTheme.bodyL,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<ProductCubit>()
                      .loadProducts(widget.store);
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return context
            .read<ProductCubit>()
            .loadProducts(widget.store);
      },
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
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: _StoreHeader(
                store: widget.store,
              ),
            ),
          ),

          SliverPadding(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              22,
              20,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                onChanged: context
                    .read<ProductCubit>()
                    .searchProducts,
                style: AppTheme.bodyL,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: AppTheme.bodyM,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                  ),
                  suffixIcon:
                  _searchController.text.isEmpty
                      ? null
                      : IconButton(
                    onPressed: () {
                      _searchController
                          .clear();

                      context
                          .read<ProductCubit>()
                          .searchProducts('');

                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  enabledBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                    borderSide:
                    const BorderSide(
                      color: AppColors.divider,
                    ),
                  ),
                  focusedBorder:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                    borderSide:
                    const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 72,
              child: ListView.separated(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  final category =
                  state.categories[index];

                  final bool isSelected =
                      state.selectedCategory ==
                          category;

                  return ChoiceChip(
                    selected: isSelected,
                    label: Text(category),
                    selectedColor:
                    AppColors.primary,
                    backgroundColor:
                    AppColors.bgCard,
                    side: const BorderSide(
                      color: AppColors.divider,
                    ),
                    labelStyle:
                    AppTheme.labelM.copyWith(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    onSelected: (_) {
                      context
                          .read<ProductCubit>()
                          .selectCategory(category);
                    },
                  );
                },
              ),
            ),
          ),

          SliverPadding(
            padding:
            const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              14,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Products',
                      style: AppTheme.titleL,
                    ),
                  ),
                  Text(
                    '${state.filteredProducts.length} items',
                    style: AppTheme.labelM,
                  ),
                ],
              ),
            ),
          ),

          if (state.filteredProducts.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyProducts(),
            )
          else
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
                    state.filteredProducts[
                    index];

                    return ProductCard(
                      product: product,
                      rating:
                      state.ratingFor(
                        product.id,
                      ),
                      isFavorite:
                      state.isFavorite(
                        product.id,
                      ),
                      onFavoritePressed: () {
                        context
                            .read<ProductCubit>()
                            .toggleFavorite(
                          product.id,
                        );
                      },
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
                  state.filteredProducts.length,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.67,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({
    required this.store,
  });

  final StoreEntity store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withOpacity(0.12),
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: AppTheme.titleL,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      store.category,
                      style: AppTheme.labelM.copyWith(
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.primaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    store.rating.toStringAsFixed(1),
                    style: AppTheme.labelM,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            store.description,
            style: AppTheme.bodyM,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.textHint,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                store.deliveryTime,
                style: AppTheme.labelM,
              ),
              const SizedBox(width: 16),
              Icon(
                store.isOpen
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                color: store.isOpen
                    ? AppColors.primary
                    : AppColors.offline,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                store.isOpen ? 'Open' : 'Closed',
                style: AppTheme.labelM,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 70,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 18),
            Text(
              'No Products Found',
              style: AppTheme.titleL,
            ),
            const SizedBox(height: 8),
            Text(
              'Try another product name or category.',
              textAlign: TextAlign.center,
              style: AppTheme.bodyM,
            ),
          ],
        ),
      ),
    );
  }
}