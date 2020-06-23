import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

Future showDatePickerCustom({
  @required BuildContext context,
  String title,
  DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
}) async {
  if (Platform.isIOS) {
    return DatePicker.showDatePicker(
      context,
      showTitleActions: title != null,
      currentTime: initialDate,
      minTime: firstDate,
      maxTime: lastDate,
    );
  } else {
    return showDatePicker(
      context: context,
      helpText: title,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }
}

Future<TimeOfDay> showTimePickerCustom({
  @required BuildContext context,
  TimeOfDay initTime,
}) async {
  if (Platform.isIOS) {
    final date = await DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: false,
      currentTime: DateTime(2020, 1, 1, initTime.hour, initTime.minute),
    );
    if (date != null) {
      return TimeOfDay(hour: date.hour, minute: date.minute);
    } else {
      return null;
    }
  } else {
    return showTimePicker(
      context: context,
      initialTime: initTime,
    );
  }
}