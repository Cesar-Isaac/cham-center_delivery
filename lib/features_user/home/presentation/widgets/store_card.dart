import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/repo/app_colors.dart';
import '../../../../core/style/style/app_theme.dart';

import '../../domain/entities/store_entity.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key,
    required this.store,
    required this.onTap,
    required this.onFavoritePressed,
  });

  final StoreEntity store;
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
          child: Row(
            children: [
              SizedBox(
                width: 126,
                height: 150,
                child: CachedNetworkImage(
                  imageUrl: store.image,
                  fit: BoxFit.cover,
                  placeholder: (_, __) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorWidget: (_, __, ___) {
                    return const ColoredBox(
                      color: AppColors.bgSheet,
                      child: Center(
                        child: Icon(
                          Icons.storefront_rounded,
                          color: AppColors.textHint,
                          size: 38,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              store.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.titleM,
                            ),
                          ),
                          IconButton(
                            onPressed: onFavoritePressed,
                            visualDensity:
                            VisualDensity.compact,
                            icon: Icon(
                              store.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons
                                  .favorite_border_rounded,
                              color: store.isFavorite
                                  ? AppColors.primary
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withOpacity(0.12),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Text(
                          store.category,
                          style: AppTheme.labelS.copyWith(
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        store.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyM,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: AppColors.primaryLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            store.rating.toStringAsFixed(1),
                            style: AppTheme.labelM,
                          ),
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.schedule_rounded,
                            size: 17,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              store.deliveryTime,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: AppTheme.labelS,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}