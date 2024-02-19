import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:latha_tuition_app/utilities/constants.dart';
import 'package:latha_tuition_app/providers/calendar_view_provider.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  late DateTime focusedDay;
  late DateTime selectedDay;

  late DateTime firstDay;
  late DateTime lastDay;

  void daySelectHandler(DateTime selected, DateTime focused) {
    setState(() {
      selectedDay = selected;
      focusedDay = focused;
    });

    ref.read(calendarViewProvider.notifier).setSelectedDate(selected);
  }

  @override
  void initState() {
    super.initState();

    final calendarViewData = ref.read(calendarViewProvider);

    focusedDay = calendarViewData[CalendarView.selectedDate];
    selectedDay = calendarViewData[CalendarView.selectedDate];
    firstDay = calendarViewData[CalendarView.firstDate];
    lastDay = calendarViewData[CalendarView.lastDate];
  }

  @override
  Widget build(BuildContext context) {
    final focusedDayTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

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
              .copyWith(color: secondaryColor),
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
                color: secondaryColor,
              ),
        ),
        onDaySelected: daySelectHandler,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      ),
    );
  }
}
