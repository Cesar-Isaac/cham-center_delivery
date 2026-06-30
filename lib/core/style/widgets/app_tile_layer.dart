import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/widgets.dart';

import '../repo/app_colors.dart';

class AppTileLayer extends StatelessWidget {
  const AppTileLayer({super.key, this.maxZoom = 20});

  final double maxZoom;

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: AppColors.mapTileUrl,
      subdomains: AppColors.mapTileSubdomains,
      userAgentPackageName: 'tracking_provider',
      maxZoom: maxZoom,
    );
  }
}
