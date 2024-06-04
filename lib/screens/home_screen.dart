import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/rides_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RidesProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calendário de Caronas'),
        ),
        body: CalendarWidget(),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ridesProvider = Provider.of<RidesProvider>(context);
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return isSameDay(day, ridesProvider.selectedDate);
          },
          onDaySelected: (selectedDay, focusedDay) {
            ridesProvider.selectDate(selectedDay);
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              var rideCount = ridesProvider.getRideCountForDate(date);
              if (rideCount > 0) {
                return Stack(
                  children: [
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 16,
                        height: 16,
                        child: Center(
                          child: Text(
                            '$rideCount',
                            style: TextStyle().copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1,
                      top: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return null;
            },
          ),
          onFormatChanged: (format) {
            if (format == CalendarFormat.month) {
              ridesProvider.resetValues();
            }
          },
        ),
        Expanded(
          child: RideList(),
        ),
        SizedBox(height: 20), // Adiciona um espaço entre o RideList e o TextField
        TextField(
          decoration: InputDecoration(
            labelText: 'Observação',
            border: OutlineInputBorder(),
          ),
          maxLines: 3, // Define o número máximo de linhas
        ),
      ],
    );
  }
}



class RideList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var ridesProvider = Provider.of<RidesProvider>(context);
    var totalRides = ridesProvider.getTotalRides();
    var totalValue = ridesProvider.getTotalValue().toStringAsFixed(2);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Total de caronas: $totalRides'),
          SizedBox(width: 20), // Adiciona um espaço entre os textos
          Text('Valor total das caronas: R\$$totalValue'),
        ],
      ),
    );
  }
}
