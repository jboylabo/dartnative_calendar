/// A single hard-coded demonstration event shown across the calendar views.
///
/// UI-independent by design: this file must not import any widget/UI APIs.
class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String? description;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.description,
  }) : assert(id != '', 'CalendarEvent.id must not be empty'),
       assert(title != '', 'CalendarEvent.title must not be empty'),
       assert(
         end.isAfter(start),
         'CalendarEvent.end must be after start',
       );

  Duration get duration => end.difference(start);
}
