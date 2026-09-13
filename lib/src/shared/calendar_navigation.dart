import 'package:dartnative/dartnative.dart';

/// Reusable previous/title/next navigation row, shared by the Month, Week,
/// and Day headers so each doesn't reimplement the same prev/next control.
class CalendarNavigationHeader extends StatelessWidget {
  final Widget title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CalendarNavigationHeader({
    super.key,
    required this.title,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(CupertinoIcons.chevron_left, size: 18),
          color: const Color(0xFF6B6B70),
        ),
        Expanded(child: Center(child: title)),
        IconButton(
          onPressed: onNext,
          icon: const Icon(CupertinoIcons.chevron_right, size: 18),
          color: const Color(0xFF6B6B70),
        ),
      ],
    );
  }
}
