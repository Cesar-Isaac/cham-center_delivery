import '../../domain/entities/product_entity.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductEntity>> getProductsByCategory(
      String category,
      );
}

class ProductLocalDataSourceImpl
    implements ProductLocalDataSource {
  @override
  Future<List<ProductEntity>> getProductsByCategory(String category,) async {
    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    return _allProducts
        .where(
          (product) =>
      product.category == category,
    )
        .toList();
  }

  static const List<ProductEntity> _allProducts = [
    ProductEntity(
      id: 1,
      name: 'Classic Burger',
      image:
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
      category: 'Food',
      price: 8.99,
      description:
      'Grilled beef burger with cheese, lettuce and fresh vegetables.',
    ),
    ProductEntity(
      id: 2,
      name: 'Italian Pizza',
      image:
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
      category: 'Food',
      price: 12.50,
      description:
      'Freshly baked pizza with mozzarella and tomato sauce.',
    ),
    ProductEntity(
      id: 3,
      name: 'Chocolate Cake',
      image:
      'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
      category: 'Food',
      price: 14.99,
      description:
      'Rich chocolate cake prepared with fresh ingredients.',
    ),
    ProductEntity(
      id: 4,
      name: 'Casual Jacket',
      image:
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
      category: 'Clothes',
      price: 42.50,
      description:
      'Lightweight jacket suitable for everyday outfits.',
    ),
    ProductEntity(
      id: 5,
      name: 'Running Shoes',
      image:
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
      category: 'Clothes',
      price: 49.90,
      description:
      'Comfortable running shoes with lightweight construction.',
    ),
    ProductEntity(
      id: 6,
      name: 'Wireless Headphones',
      image:
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
      category: 'Electronics',
      price: 59.99,
      description:
      'Wireless headphones with clear sound and long battery life.',
    ),
    ProductEntity(
      id: 7,
      name: 'Modern Laptop',
      image:
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800',
      category: 'Electronics',
      price: 749.99,
      description:
      'Modern laptop suitable for studying, development and work.',
    ),
    ProductEntity(
      id: 8,
      name: 'Smart Lamp',
      image:
      'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800',
      category: 'Electrical',
      price: 24.75,
      description:
      'Energy-saving lamp with adjustable brightness.',
    ),
    ProductEntity(
      id: 9,
      name: 'Home Tool Kit',
      image:
      'https://images.unsplash.com/photo-1504148455328-c376907d081c?w=800',
      category: 'Electrical',
      price: 36.40,
      description:
      'Compact tool kit for household repairs and maintenance.',
    ),
  ];
}