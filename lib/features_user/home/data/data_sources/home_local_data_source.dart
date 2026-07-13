import '../../../product/domain/entities/product_entity.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/entities/store_entity.dart';

abstract class HomeLocalDataSource {
  Future<HomeDataEntity> getHomeData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<HomeDataEntity> getHomeData() async {
    await Future<void>.delayed(
      const Duration(milliseconds: 450),
    );

    return const HomeDataEntity(
      stores: [
        const StoreEntity(
          id: 1,
          name: 'Fresh Bites',
          image:
          'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?auto=format&fit=crop&w=1000&q=80',
          category: 'Food',
          description:
          'Fresh meals, sandwiches, salads and daily specials.',
          rating: 4.8,
          deliveryTime: '20 - 30 min',
        ),

        const StoreEntity(
          id: 2,
          name: 'Urban Style',
          image:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1000&q=80',
          category: 'Clothes',
          description:
          'Modern fashion, casual outfits and seasonal collections.',
          rating: 4.6,
          deliveryTime: '35 - 45 min',
        ),

        const StoreEntity(
          id: 3,
          name: 'Tech Planet',
          image:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?auto=format&fit=crop&w=1000&q=80',
          category: 'Electronics',
          description:
          'Smartphones, laptops, accessories and smart devices.',
          rating: 4.9,
          deliveryTime: '40 - 55 min',
        ),

        const StoreEntity(
          id: 4,
          name: 'Power House',
          image:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?auto=format&fit=crop&w=1000&q=80',
          category: 'Electrical',
          description:
          'Electrical tools, lighting equipment and home supplies.',
          rating: 4.5,
          deliveryTime: '30 - 40 min',
        ),

        const StoreEntity(
          id: 5,
          name: 'Sweet Corner',
          image:
          'https://images.unsplash.com/photo-1559620192-032c4bc4674e?auto=format&fit=crop&w=1000&q=80',
          category: 'Food',
          description:
          'Cakes, desserts, coffee and handcrafted sweets.',
          rating: 4.7,
          deliveryTime: '15 - 25 min',
        ),

        const StoreEntity(
          id: 6,
          name: 'Digital Zone',
          image:
          'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=1000&q=80',
          category: 'Electronics',
          description:
          'Gaming accessories, headphones and computer equipment.',
          rating: 4.4,
          deliveryTime: '45 - 60 min',
        ),
      ],
      popularProducts: [
        ProductEntity(
          id: 101,
          name: 'Classic Burger',
          image:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=900&q=80',
          category: 'Food',
          price: 8.99,
          description:
          'Grilled beef burger with cheese and fresh vegetables.',
        ),
        ProductEntity(
          id: 102,
          name: 'Wireless Headphones',
          image:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80',
          category: 'Electronics',
          price: 59.99,
          description:
          'Comfortable wireless headphones with clear sound.',
        ),
        ProductEntity(
          id: 103,
          name: 'Casual Jacket',
          image:
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=900&q=80',
          category: 'Clothes',
          price: 42.50,
          description:
          'Lightweight jacket suitable for everyday outfits.',
        ),
        ProductEntity(
          id: 104,
          name: 'Smart Lamp',
          image:
          'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=900&q=80',
          category: 'Electrical',
          price: 24.75,
          description:
          'Energy-saving lamp with adjustable brightness.',
        ),
      ],
      recommendedProducts: [
        ProductEntity(
          id: 201,
          name: 'Chocolate Cake',
          image:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=900&q=80',
          category: 'Food',
          price: 14.99,
          description:
          'Rich chocolate cake prepared with fresh ingredients.',
        ),
        ProductEntity(
          id: 202,
          name: 'Smart Watch',
          image:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80',
          category: 'Electronics',
          price: 79.00,
          description:
          'Smart watch with activity and notification tracking.',
        ),
        ProductEntity(
          id: 203,
          name: 'Running Shoes',
          image:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80',
          category: 'Clothes',
          price: 49.90,
          description:
          'Comfortable running shoes with lightweight construction.',
        ),
        ProductEntity(
          id: 204,
          name: 'Tool Kit',
          image:
          'https://images.unsplash.com/photo-1581147036324-c1c89c2c8b5c?auto=format&fit=crop&w=900&q=80',
          category: 'Electrical',
          price: 36.40,
          description:
          'Compact tool kit for common household maintenance.',
        ),
      ],
    );
  }
}