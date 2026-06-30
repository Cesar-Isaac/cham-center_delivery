# TODO - تطبيق تدريب توصيل طلبات للسائق (Flutter Clean Architecture + MVVM + Cubit)

## الخطوات
- [ ] 1) تحديث `pubspec.yaml` لإضافة الحزم اللازمة (flutter_bloc, get_it, flutter_map, latlong2, equatable, intl, etc.)
- [ ] 2) تأسيس هيكل Clean Architecture داخل `lib/`:
  - [ ] presentation/
  - [ ] domain/
  - [ ] data/
- [ ] 3) إنشاء Domain entities + enums:
  - [ ] DriverStatus, OrderCategory, Order, Trip, TripStatus, TripSegment/route helpers
- [ ] 4) إنشاء Data layer (محاكاة):
  - [ ] Orders mock ثابت + قواعد الدمج (Clothing+Tech بدون أطعمة)
  - [ ] Driver location simulator
  - [ ] Trip simulator (حركة العلامة + إنهاء عند الوصول)
  - [ ] Order receiving scheduler (15-30 ثانية + reject بعد دقيقتين + توقف عند Offline)
- [ ] 5) إنشاء Cubits (إدارة الحالة فقط):
  - [ ] DriverStatusCubit
  - [ ] ReceivingOrdersCubit (إظهار bottom sheet + قبول/رفض + auto reject)
  - [ ] TripCubit (بدء الرحلة + تحديث الموقع + الإنهاء + إعادة الجدولة بعد دقيقة)
- [ ] 6) إنشاء Repositories/Interfaces داخل domain + تنفيذها داخل data
- [ ] 7) إعداد Dependency Injection عبر get_it
- [ ] 8) بناء UI Modern:
  - [ ] شاشة رئيسية: خريطة + زر Online/Offline بتبديل اللون/النص
  - [ ] bottom sheet لعرض تفاصيل الطلب + قبول/رفض
  - [ ] شاشة رحلة: معلومات + خريطة + مسار + زر إنهاء عند الوصول
- [ ] 9) إضافة تنسيق وتحسين UX (loading/empty states)
- [ ] 10) تشغيل `flutter analyze` وتجميع `flutter test` (إن وجد)

