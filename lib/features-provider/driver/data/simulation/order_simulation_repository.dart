import '../../domain/entities/order.dart';
import '../../domain/entities/order_category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/types/order_combination.dart';

class OrderSimulationRepository implements OrderRepository {
  static const _mallPickup = 'شام سيتي سنتر، كفرسوسة، دمشق';

  late final List<Order> _orders = _buildOrders();

  @override
  List<Order> getFixedOrders() => _orders;

  @override
  bool canCombineOrders({required Order a, required Order b}) {
    if (a.category == OrderCategory.food || b.category == OrderCategory.food) {
      return false;
    }
    final pair = {a.category, b.category};
    return pair.contains(OrderCategory.clothing) &&
        pair.contains(OrderCategory.techTools);
  }

  @override
  OrderCombinationResult combine({
    required List<Order> current,
    required Order incoming,
  }) {
    if (current.isEmpty) {
      return OrderCombinationResult(allowed: true, combinedOrders: [incoming]);
    }

    if (incoming.category == OrderCategory.food) {
      return const OrderCombinationResult(
        allowed: false,
        combinedOrders: [],
        reason: 'لا يمكن دمج طلب الطعام مع طلبات أخرى',
      );
    }

    if (current.any((o) => o.category == OrderCategory.food)) {
      return const OrderCombinationResult(
        allowed: false,
        combinedOrders: [],
        reason: 'رحلة الطعام مخصصة لطلب واحد فقط',
      );
    }

    final existingCategories = current.map((o) => o.category).toSet();

    if (existingCategories.contains(incoming.category)) {
      return OrderCombinationResult(
        allowed: true,
        combinedOrders: [...current, incoming],
      );
    }

    final pair = {...existingCategories, incoming.category};
    if (pair.contains(OrderCategory.clothing) &&
        pair.contains(OrderCategory.techTools)) {
      return OrderCombinationResult(
        allowed: true,
        combinedOrders: [...current, incoming],
      );
    }

    return const OrderCombinationResult(
      allowed: false,
      combinedOrders: [],
      reason: 'تركيبة الفئات غير مسموحة',
    );
  }

  List<Order> _buildOrders() {
    final now = DateTime.now();

    Order clothing(
      String id,
      String name,
      String phone,
      String area,
      double lat,
      double lng,
      List<Product> products,
      double price,
      int minutesAgo,
    ) => Order(
      id: id,
      customerName: name,
      phone: phone,
      pickupAddress: _mallPickup,
      deliveryAddress: 'دمشق - $area',
      deliveryLat: lat,
      deliveryLng: lng,
      category: OrderCategory.clothing,
      products: products,
      price: price,
      createdAt: now.subtract(Duration(minutes: minutesAgo)),
    );

    Order tech(
      String id,
      String name,
      String phone,
      String area,
      double lat,
      double lng,
      List<Product> products,
      double price,
      int minutesAgo,
    ) => Order(
      id: id,
      customerName: name,
      phone: phone,
      pickupAddress: _mallPickup,
      deliveryAddress: 'دمشق - $area',
      deliveryLat: lat,
      deliveryLng: lng,
      category: OrderCategory.techTools,
      products: products,
      price: price,
      createdAt: now.subtract(Duration(minutes: minutesAgo)),
    );

    Order food(
      String id,
      String name,
      String phone,
      String area,
      double lat,
      double lng,
      List<Product> products,
      double price,
      int minutesAgo,
    ) => Order(
      id: id,
      customerName: name,
      phone: phone,
      pickupAddress: _mallPickup,
      deliveryAddress: 'دمشق - $area',
      deliveryLat: lat,
      deliveryLng: lng,
      category: OrderCategory.food,
      products: products,
      price: price,
      createdAt: now.subtract(Duration(minutes: minutesAgo)),
    );

    return [
      // ── Clothing (10 orders) ──────────────────────────────────────────────
      clothing('ORD-C001', 'محمد علي', '0911234001', 'المزة - شارع الجلاء',
          33.5206, 36.2380, [
            const Product(name: 'تيشيرت قطن', quantity: 2, price: 18000),
            const Product(name: 'قميص رسمي', quantity: 1, price: 20000),
          ], 56000, 5),
      clothing('ORD-C002', 'ليلى إبراهيم', '0912234002', 'المالكي',
          33.5127, 36.2829, [
            const Product(name: 'فستان صيفي', quantity: 1, price: 55000),
            const Product(name: 'حجاب سيفون', quantity: 2, price: 15000),
          ], 85000, 8),
      clothing('ORD-C003', 'نادر جابر', '0913234003', 'أبو رمانة',
          33.5155, 36.2918, [
            const Product(name: 'بنطال جينز', quantity: 1, price: 45000),
            const Product(name: 'حزام جلد', quantity: 1, price: 27000),
          ], 72000, 11),
      clothing('ORD-C004', 'رنا محمود', '0914234004', 'ركن الدين',
          33.5299, 36.3041, [
            const Product(name: 'جاكيت شتوي', quantity: 1, price: 120000),
          ], 120000, 14),
      clothing('ORD-C005', 'عمر حسون', '0915234005', 'مشروع دمر',
          33.5123, 36.2255, [
            const Product(name: 'تيشيرت رياضي', quantity: 3, price: 22000),
          ], 66000, 17),
      clothing('ORD-C006', 'هناء عمر', '0916234006', 'الشعلان',
          33.5098, 36.2954, [
            const Product(name: 'بلوزة', quantity: 1, price: 48000),
            const Product(name: 'تنورة', quantity: 1, price: 47000),
          ], 95000, 20),
      clothing('ORD-C007', 'حسان قاسم', '0917234007', 'القصاع',
          33.5066, 36.3157, [
            const Product(name: 'بدلة رسمية كاملة', quantity: 1, price: 280000),
          ], 280000, 23),
      clothing('ORD-C008', 'ديما العلي', '0918234008', 'الزاهرة',
          33.5016, 36.3070, [
            const Product(name: 'ملابس أطفال (طقم)', quantity: 2, price: 22500),
          ], 45000, 26),
      clothing('ORD-C009', 'سامر الحسن', '0919234009', 'شارع بغداد',
          33.5057, 36.3009, [
            const Product(name: 'هودي مطبوع', quantity: 1, price: 85000),
          ], 85000, 29),
      clothing('ORD-C010', 'منال درويش', '0920234010', 'المهاجرين',
          33.5220, 36.2870, [
            const Product(name: 'فستان سهرة', quantity: 1, price: 320000),
          ], 320000, 32),

      // ── Tech Tools (8 orders) ────────────────────────────────────────────
      tech('ORD-T001', 'ريم خليل', '0921234001', 'باب توما',
          33.5121, 36.3211, [
            const Product(name: 'سماعات لاسلكية', quantity: 1, price: 180000),
          ], 180000, 6),
      tech('ORD-T002', 'سارة أحمد', '0922234002', 'المالكي',
          33.5100, 36.2850, [
            const Product(name: 'كابل شحن سريع', quantity: 3, price: 8000),
          ], 24000, 9),
      tech('ORD-T003', 'طارق السعيد', '0923234003', 'برزة',
          33.5505, 36.3055, [
            const Product(name: 'ماوس لاسلكي', quantity: 1, price: 65000),
          ], 65000, 12),
      tech('ORD-T004', 'رامي جمال', '0924234004', 'كفرسوسة',
          33.4955, 36.2671, [
            const Product(name: 'لوحة مفاتيح ميكانيكية', quantity: 1, price: 90000),
          ], 90000, 15),
      tech('ORD-T005', 'كريم الزعبي', '0925234005', 'التضامن',
          33.4857, 36.3251, [
            const Product(name: 'شاحن سريع 65W', quantity: 1, price: 35000),
          ], 35000, 18),
      tech('ORD-T006', 'نور الدين فارس', '0926234006', 'جرمانا',
          33.4816, 36.3538, [
            const Product(name: 'إضاءة ليد RGB', quantity: 2, price: 20000),
          ], 40000, 21),
      tech('ORD-T007', 'أيمن عوض', '0927234007', 'قدسيا',
          33.5437, 36.2292, [
            const Product(name: 'ساعة ذكية', quantity: 1, price: 250000),
          ], 250000, 24),
      tech('ORD-T008', 'وسيم ناصر', '0928234008', 'الميدان',
          33.4938, 36.3083, [
            const Product(name: 'حامل هاتف سيارة', quantity: 2, price: 15000),
          ], 30000, 27),

      // ── Food (7 orders) ─────────────────────────────────────────────────
      food('ORD-F001', 'أحمد حسام', '0931234001',
          'برزة', 33.5022, 36.3221, [
            const Product(name: 'شاورما لحم', quantity: 2, price: 11000),
            const Product(name: 'عصير برتقال', quantity: 2, price: 5000),
          ], 32000, 7),
      food('ORD-F002', 'سلمى كيلاني', '0932234002',
          'باب مصلى', 33.4973, 36.3113, [
            const Product(name: 'بيتزا كبيرة مارغريتا', quantity: 1, price: 28000),
          ], 28000, 10),
      food('ORD-F003', 'جهاد عيسى', '0933234003',
          'الأمين', 33.5078, 36.3082, [
            const Product(name: 'كنافة بالقشطة', quantity: 2, price: 9000),
          ], 18000, 13),
      food('ORD-F004', 'مروان عزيز', '0934234004',
          'باب توما', 33.5130, 36.3190, [
            const Product(name: 'طبق مجدرة', quantity: 1, price: 10000),
            const Product(name: 'خبز عربي', quantity: 5, price: 1000),
          ], 15000, 16),
      food('ORD-F005', 'تيمور ناصر', '0935234005',
          'ركن الدين', 33.5280, 36.3050, [
            const Product(name: 'ساندويشة فلافل', quantity: 4, price: 5000),
          ], 20000, 19),
      food('ORD-F006', 'إيمان الحمصي', '0936234006',
          'الميدان', 33.4950, 36.3070, [
            const Product(name: 'طبق فلافل', quantity: 1, price: 12000),
            const Product(name: 'حمص بالزيت', quantity: 1, price: 10000),
          ], 22000, 22),
      food('ORD-F007', 'غسان طرزي', '0937234007',
          'القصاع', 33.5080, 36.3140, [
            const Product(name: 'مسخن دجاج', quantity: 1, price: 38000),
            const Product(name: 'عصير تفاح', quantity: 2, price: 3500),
          ], 45000, 25),
    ];
  }
}
