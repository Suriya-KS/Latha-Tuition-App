import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latha_tuition_app/providers/calendar_view_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({
    super.key,
    this.onDateChange,
  });

  final void Function()? onDateChange;

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  late DateTime focusedDay;
  late DateTime selectedDay;

  void daySelectHandler(DateTime selected, DateTime focused) {
    setState(() {
      selectedDay = DateTime(selected.year, selected.month, selected.day);
      focusedDay = DateTime(focused.year, focused.month, focused.day);
    });

    ref.read(calendarViewProvider.notifier).setSelectedDate(DateTime(
          selected.year,
          selected.month,
          selected.day,
        ));

    if (widget.onDateChange != null) widget.onDateChange!();
  }

  @override
  Widget build(BuildContext context) {
    final calendarViewData = ref.watch(calendarViewProvider);

    final firstDay = calendarViewData[CalendarView.firstDate];
    final lastDay = calendarViewData[CalendarView.lastDate];

    final focusedDayTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

    focusedDay = calendarViewData[CalendarView.selectedDate];
    selectedDay = calendarViewData[CalendarView.selectedDate];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TableCalendar(
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay,
        calendarStyle: CalendarStyle(
          todayTextStyle: focusedDayTextStyle,
          selectedTextStyle: focusedDayTextStyle,
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          weekendTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.error),
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
          formatButtonVisible: false,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
          weekendStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.error,
              ),
        ),
        onDaySelected: daySelectHandler,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      ),
    );
  }
}
