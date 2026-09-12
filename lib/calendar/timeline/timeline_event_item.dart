import 'package:dartnative/dartnative.dart';

import '../../models/calendar_event.dart';
import '../../utils/calendar_date_utils.dart' show EventTimeStatus;

/// One row in the Agenda/Timeline list: time range, title, and optional
/// description (FR-021), visually styled by [status] — past events are
/// muted, the current event is highlighted with a "NOW" badge, upcoming
/// events use normal full-contrast styling (FR-022).
///
/// Purely presentational: [status] is computed by
/// `utils/calendar_date_utils.eventTimeStatus` — no date comparison
/// happens here.
class TimelineEventItem extends StatelessWidget {
  final CalendarEvent event;
  final EventTimeStatus status;

  const TimelineEventItem({
    super.key,
    required this.event,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isPast = status == EventTimeStatus.past;
    final isCurrent = status == EventTimeStatus.current;

    final accentColor = isCurrent
        ? const Color(0xFF34C759)
        : isPast
        ? const Color(0xFFD1D1D6)
        : const Color(0xFF3D7BFF);
    final titleColor = isPast
        ? const Color(0xFFA9A9AE)
        : const Color(0xFF111111);
    final timeColor = isPast
        ? const Color(0xFFB5B5BA)
        : const Color(0xFF6B6B70);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFEAF9ED) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${_formatTime(event.start)} – ${_formatTime(event.end)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: timeColor,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'NOW',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                if (event.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    event.description!,
                    style: TextStyle(fontSize: 12, color: timeColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final hour24 = time.hour;
    final period = hour24 < 12 ? 'AM' : 'PM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }
}
