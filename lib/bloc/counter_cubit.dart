import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import intl for date formatting

class CounterCubit extends Cubit<Map<String, dynamic>> {
  CounterCubit()
      : super({
    'count': 0,
    'iconColor': Colors.red,
    'attendanceTime': _formatDateTime(DateTime.now())
  });

  Timer? _timer;

  // Method for giving attendance
  void present() {
    final currentTime = DateTime.now();

    // Update the attendance time regardless of the attendance state
    emit({
      'count': state['count']  , // Keep the previous count
      'iconColor': Colors.green,
      'attendanceTime': _formatDateTime(currentTime), // Update attendance time
    });

    _timer?.cancel();

    // Reset the timer to update icon color back to red after 24 hours
    _timer = Timer(_calculateRemainingTime(), () {
      emit({
        'count': state['count'] +1, // Keep the previous count
        'iconColor': Colors.red,
        'attendanceTime': _formatDateTime(currentTime), // Update attendance time
      });
    });
  }

  // Method to calculate remaining time until midnight
  Duration _calculateRemainingTime() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return midnight.difference(now);
  }

  // Date formatting method (hh:mm:ss a)
  static String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime); // Format as hour, minutes, seconds, and AM/PM
  }

  // Method for taking away attendance
  void absent() {
    _timer?.cancel();
    emit({
      'count': state['count'] -1, // Count remains the same
      'iconColor': Colors.red,
      'attendanceTime': state['attendanceTime'] // Keep the previous attendance time
    });
  }

  // Calculate Grade based on marks
  String calculateGradeLetter(int marks) {
    if (marks >= 80) {
      return "A+";
    } else if (marks >= 70) {
      return "A";
    } else if (marks >= 60) {
      return "A-";
    } else if (marks >= 50) {
      return "B";
    } else if (marks >= 40) {
      return "C";
    } else if (marks >= 33) {
      return "D";
    } else {
      return "F";
    }
  }

  // Calculate Grade Point based on marks
  String gradePoint(int marks) {
    switch (marks ~/ 10) {
      case 10:
      case 9:
      case 8:
        return '5.00';
      case 7:
        return '4.00';
      case 6:
        return '3.50';
      case 5:
        return '3.00';
      case 4:
        return '2.00';
      case 3:
        if (marks >= 33) {
          return '1.00';
        }
        return '0.00';
      default:
        return '0.00';
    }
  }
}
