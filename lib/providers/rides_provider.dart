import 'package:flutter/material.dart';

class RidesProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, int> _rides = {};
  Set<DateTime> _markedDates = {};

  DateTime get selectedDate => _selectedDate;

  void selectDate(DateTime date) {
    if (_markedDates.contains(date)) {
      // Data já marcada, não faz nada
      return;
    }

    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      // Não permite marcar nos fins de semana
      return;
    }

    _selectedDate = date;

    if (_rides[date] == null) {
      _rides[date] = 1;
    } else {
      _rides[date] = _rides[date]! + 1;
    }

    _markedDates.add(date);
    notifyListeners();
  }

  int getRideCountForDate(DateTime date) {
    return _rides[date] ?? 0;
  }

  double getTotalValue() {
    double total = 0;
    for (var rides in _rides.values) {
      total += rides * 7.0;
    }
    return total;
  }

  int getTotalRides() {
    int total = 0;
    for (var rides in _rides.values) {
      total += rides;
    }
    return total;
  }

  void resetValues() {
    _rides.clear();
    _markedDates.clear();
    notifyListeners();
  }
}
