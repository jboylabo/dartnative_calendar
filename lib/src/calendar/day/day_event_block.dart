import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';

/// One event rendered on the Day Calendar's hourly timeline.
///
/// Purely presentational: [top]/[left]/[width]/[height] are pre-computed by
/// `DayTimeGrid` from `utils/calendar_layout_utils.dart` — no layout math
/// happens here.
class DayEventBlock extends StatelessWidget {
  final CalendarEvent event;
  final double top;
  final double left;
  final double width;
  final double height;

  const DayEventBlock({
    super.key,
    required this.event,
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      width: width,
      height: height,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: const Color(0xFF3D7BFF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
