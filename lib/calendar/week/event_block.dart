import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';

/// One event rendered in a Week Calendar day column.
///
/// Purely presentational: [top]/[left]/[width]/[height] are pre-computed by
/// `WeekDayColumn` from `utils/calendar_layout_utils.dart` (the same
/// functions the Day Calendar uses) — no layout math happens here.
class EventBlock extends StatelessWidget {
  final CalendarEvent event;
  final double top;
  final double left;
  final double width;
  final double height;

  const EventBlock({
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
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: const Color(0xFF3D7BFF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          event.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
