import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.rating,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoritePressed,
  });

  final ProductEntity product;
  final double rating;
  final bool isFavorite;

  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgCard,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.divider,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'product-image-${product.id}',
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        placeholder: (_, __) {
                          return const ColoredBox(
                            color: AppColors.bgSheet,
                            child: Center(
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
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
                                color: AppColors.textHint,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: AppColors.bgSheet
                            .withOpacity(0.92),
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed:
                          onFavoritePressed,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons
                                .favorite_border_rounded,
                            color: isFavorite
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: product.isAvailable
                              ? AppColors.primary
                              : AppColors.offline,
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                        child: Text(
                          product.isAvailable
                              ? 'Available'
                              : 'Unavailable',
                          style: AppTheme.labelS.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.labelS.copyWith(
                        color: AppColors.primaryLight,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.titleM,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.primaryLight,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTheme.labelM,
                        ),
                        const Spacer(),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTheme.priceM,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}