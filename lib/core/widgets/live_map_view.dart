import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'status_pill.dart';

class LiveMapView extends StatefulWidget {
  final double ambulanceLat;
  final double ambulanceLng;
  final String destinationName;
  final int etaMinutes;
  final bool isGreenCorridor;
  final String? activeJunction;
  final VoidCallback? onClearJunction;
  final bool showControls;
  final double height;

  const LiveMapView({
    super.key,
    required this.ambulanceLat,
    required this.ambulanceLng,
    required this.destinationName,
    required this.etaMinutes,
    this.isGreenCorridor = false,
    this.activeJunction,
    this.onClearJunction,
    this.showControls = true,
    this.height = 320,
  });

  @override
  State<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends State<LiveMapView> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final corridorColor = widget.isGreenCorridor ? AppColors.corridorGreen : AppColors.infoBlue;

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF141A1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isGreenCorridor
              ? AppColors.corridorGreen.withValues(alpha: 0.6)
              : AppColors.divider,
          width: widget.isGreenCorridor ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Simulated Dark Vector Map Graphics
          CustomPaint(
            size: Size.infinite,
            painter: MapVectorPainter(
              corridorColor: corridorColor,
              isGreenCorridor: widget.isGreenCorridor,
              pulseVal: _pulseController.value,
            ),
          ),

          // Top Info HUD
          Positioned(
            top: 14,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isGreenCorridor ? AppColors.corridorGreen : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE RADAR • ${widget.isGreenCorridor ? "GREEN CORRIDOR ACTIVE" : "STANDARD ROUTING"}',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusPill(
                  label: '${widget.etaMinutes} MIN ETA',
                  color: widget.isGreenCorridor ? AppColors.corridorGreen : AppColors.primaryGreen,
                  textColor: Colors.black,
                  icon: Icons.timer,
                ),
              ],
            ),
          ),

          // Bottom Route Legend & Destination Card
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: corridorColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isGreenCorridor ? Icons.traffic : Icons.navigation,
                      color: corridorColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'DESTINATION: ${widget.destinationName}',
                          style: AppTypography.titleMedium.copyWith(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.isGreenCorridor
                              ? 'All signals along corridor forced green'
                              : 'Traffic signals under normal synchronization',
                          style: AppTypography.caption.copyWith(
                            color: widget.isGreenCorridor
                                ? AppColors.corridorGreen
                                : AppColors.textSecondary,
                          ),
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
    );
  }
}

class MapVectorPainter extends CustomPainter {
  final Color corridorColor;
  final bool isGreenCorridor;
  final double pulseVal;

  MapVectorPainter({
    required this.corridorColor,
    required this.isGreenCorridor,
    required this.pulseVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1E2833)
      ..strokeWidth = 1.0;

    // Draw background city grid lines
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Secondary city roads
    final roadPaint = Paint()
      ..color = const Color(0xFF2C3947)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final secondaryRoad = Path()
      ..moveTo(20, size.height * 0.8)
      ..lineTo(size.width * 0.4, size.height * 0.7)
      ..lineTo(size.width * 0.9, size.height * 0.85);
    canvas.drawPath(secondaryRoad, roadPaint);

    // Active Corridor Highway Polyline
    final corridorGlow = Paint()
      ..color = corridorColor.withValues(alpha: 0.35 + (pulseVal * 0.25))
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final corridorCore = Paint()
      ..color = corridorColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final corridorPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.65)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.6,
        size.width * 0.45,
        size.height * 0.35,
        size.width * 0.85,
        size.height * 0.32,
      );

    canvas.drawPath(corridorPath, corridorGlow);
    canvas.drawPath(corridorPath, corridorCore);

    // Junctions along path
    final junctionPoints = [
      Offset(size.width * 0.15, size.height * 0.65),
      Offset(size.width * 0.42, size.height * 0.45),
      Offset(size.width * 0.85, size.height * 0.32),
    ];

    for (int i = 0; i < junctionPoints.length; i++) {
      final pt = junctionPoints[i];
      final jPaint = Paint()
        ..color = isGreenCorridor ? AppColors.corridorGreen : Colors.orangeAccent
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pt, 6.0, jPaint);
      canvas.drawCircle(
        pt,
        6.0 + (pulseVal * 4.0),
        Paint()
          ..color = (isGreenCorridor ? AppColors.corridorGreen : Colors.orangeAccent)
              .withValues(alpha: 0.4 - (pulseVal * 0.3))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    // Ambulance Marker
    final ambPos = Offset(size.width * 0.42, size.height * 0.45);
    final ambBgPaint = Paint()
      ..color = AppColors.emergencyRed
      ..style = PaintingStyle.fill;
    canvas.drawCircle(ambPos, 10.0, ambBgPaint);
    canvas.drawCircle(
      ambPos,
      10.0 + (pulseVal * 6.0),
      Paint()
        ..color = AppColors.emergencyRed.withValues(alpha: 0.5 - (pulseVal * 0.4))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Destination Pin
    final destPos = Offset(size.width * 0.85, size.height * 0.32);
    final destPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(destPos, 8.0, destPaint);
  }

  @override
  bool shouldRepaint(covariant MapVectorPainter oldDelegate) => true;
}
