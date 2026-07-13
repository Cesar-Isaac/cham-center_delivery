import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../../../core/style/widgets/primary_button.dart';
import '../../../cart/presentation/manager/cart_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../manager/product_cubit.dart';
import '../manager/product_state.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String route = '/product-details';

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final bool isFavorite =
        state.isFavorite(product.id);

        final double rating =
        state.ratingFor(product.id);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                stretch: true,
                backgroundColor:
                AppColors.bgSheet,
                actions: [
                  Container(
                    margin:
                    const EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgSheet
                          .withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        context
                            .read<ProductCubit>()
                            .toggleFavorite(
                          product.id,
                        );
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons
                            .favorite_border_rounded,
                        color: isFavorite
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
                flexibleSpace:
                FlexibleSpaceBar(
                  background: Hero(
                    tag:
                    'product-image-${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      placeholder: (_, __) {
                        return const ColoredBox(
                          color: AppColors.bgSheet,
                          child: Center(
                            child:
                            CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorWidget: (_, __, ___) {
                        return const ColoredBox(
                          color: AppColors.bgSheet,
                          child: Center(
                            child: Icon(
                              Icons
                                  .image_not_supported_outlined,
                              color:
                              AppColors.textHint,
                              size: 60,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding:
                const EdgeInsets.fromLTRB(
                  22,
                  24,
                  22,
                  130,
                ),
                sliver: SliverList(
                  delegate:
                  SliverChildListDelegate(
                    [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style:
                              AppTheme.titleXL,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style:
                            AppTheme.priceL.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color:
                            AppColors.primaryLight,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            rating.toStringAsFixed(1),
                            style:
                            AppTheme.titleM,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(128 reviews)',
                            style:
                            AppTheme.labelM,
                          ),
                          const Spacer(),
                          _AvailabilityBadge(
                            isAvailable:
                            product.isAvailable,
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      _SectionContainer(
                        title: 'Description',
                        child: Text(
                          product.description ??
                              'No description available.',
                          style: AppTheme.bodyM
                              .copyWith(
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      _SectionContainer(
                        title: 'Specifications',
                        child: Column(
                          children: [
                            _SpecificationRow(
                              label: 'Category',
                              value:
                              product.category,
                            ),
                            const Divider(
                              height: 24,
                            ),
                            const _SpecificationRow(
                              label: 'Delivery',
                              value: '20 - 35 min',
                            ),
                            const Divider(
                              height: 24,
                            ),
                            _SpecificationRow(
                              label: 'Availability',
                              value:
                              product.isAvailable
                                  ? 'In Stock'
                                  : 'Out of Stock',
                            ),
                            const Divider(
                              height: 24,
                            ),
                            const _SpecificationRow(
                              label: 'Return Policy',
                              value: 'Within 7 days',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      const _SectionContainer(
                        title: 'Customer Reviews',
                        child: Column(
                          children: [
                            _ReviewCard(
                              name: 'Ahmad',
                              rating: 5,
                              comment:
                              'Excellent product and fast delivery.',
                            ),
                            SizedBox(height: 14),
                            _ReviewCard(
                              name: 'Sarah',
                              rating: 4,
                              comment:
                              'Good quality and exactly as described.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding:
              const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                18,
              ),
              decoration: const BoxDecoration(
                color: AppColors.bgSheet,
                border: Border(
                  top: BorderSide(
                    color: AppColors.divider,
                  ),
                ),
              ),
              child: PrimaryButton(
                text: product.isAvailable
                    ? 'Add To Cart'
                    : 'Unavailable',
                icon:
                Icons.shopping_cart_outlined,
                onPressed: product.isAvailable
                    ? () async {
                  final cartCubit =
                  context.read<CartCubit>();

                  final added = await cartCubit.addProduct(
                    product,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          added
                              ? 'تمت إضافة المنتج إلى السلة.'
                              : cartCubit.state.error ??
                              'تعذر إضافة المنتج إلى السلة.',
                        ),
                        backgroundColor:
                        added ? Colors.green : Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                }
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({
    required this.isAvailable,
  });

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.primary.withOpacity(0.12)
            : AppColors.offline.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        isAvailable
            ? 'Available'
            : 'Unavailable',
        style: AppTheme.labelS.copyWith(
          color: isAvailable
              ? AppColors.primary
              : AppColors.offline,
        ),
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.titleM,
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SpecificationRow extends StatelessWidget {
  const _SpecificationRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTheme.labelM,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyL,
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.name,
    required this.rating,
    required this.comment,
  });

  final String name;
  final int rating;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSheet,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                AppColors.primary,
                child: Text(
                  name.substring(0, 1),
                  style: AppTheme.titleM,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: AppTheme.titleM,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                      (index) {
                    return Icon(
                      index < rating
                          ? Icons.star_rounded
                          : Icons
                          .star_border_rounded,
                      color:
                      AppColors.primaryLight,
                      size: 18,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment,
            style: AppTheme.bodyM,
          ),
        ],
      ),
    );
  }
}