// import 'package:alarm/alarm.dart';
// import 'package:flutter/material.dart';
//
// class ExampleAlarmEditScreen extends StatefulWidget {
//   const ExampleAlarmEditScreen({super.key, this.alarmSettings});
//
//   final AlarmSettings? alarmSettings;
//
//   @override
//   State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
// }
//
// class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
//   bool loading = false;
//
//   late bool creating;
//   late DateTime selectedDateTime;
//   late bool loopAudio;
//   late bool vibrate;
//   late double? volume;
//   late Duration? fadeDuration;
//   late bool staircaseFade;
//   late String assetAudio;
//
//   @override
//   void initState() {
//     super.initState();
//     creating = widget.alarmSettings == null;
//
//     if (creating) {
//       selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
//       selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
//       loopAudio = true;
//       vibrate = true;
//       volume = null;
//       fadeDuration = null;
//       staircaseFade = false;
//       assetAudio = 'assets/marimba.mp3';
//     } else {
//       selectedDateTime = widget.alarmSettings!.dateTime;
//       loopAudio = widget.alarmSettings!.loopAudio;
//       vibrate = widget.alarmSettings!.vibrate;
//       volume = widget.alarmSettings!.volumeSettings.volume;
//       fadeDuration = widget.alarmSettings!.volumeSettings.fadeDuration;
//       staircaseFade = widget.alarmSettings!.volumeSettings.fadeSteps.isNotEmpty;
//       assetAudio = widget.alarmSettings!.assetAudioPath;
//     }
//   }
//
//   String getDay() {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final difference = selectedDateTime.difference(today).inDays;
//
//     switch (difference) {
//       case 0:
//         return 'Today';
//       case 1:
//         return 'Tomorrow';
//       case 2:
//         return 'After tomorrow';
//       default:
//         return 'In $difference days';
//     }
//   }
//
//   Future<void> pickTime() async {
//     final res = await showTimePicker(
//       initialTime: TimeOfDay.fromDateTime(selectedDateTime),
//       context: context,
//     );
//
//     if (res != null) {
//       setState(() {
//         final now = DateTime.now();
//         selectedDateTime = now.copyWith(
//           hour: res.hour,
//           minute: res.minute,
//           second: 0,
//           millisecond: 0,
//           microsecond: 0,
//         );
//         if (selectedDateTime.isBefore(now)) {
//           selectedDateTime = selectedDateTime.add(const Duration(days: 1));
//         }
//       });
//     }
//   }
//
//   AlarmSettings buildAlarmSettings() {
//     final id = creating
//         ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
//         : widget.alarmSettings!.id;
//
//     final VolumeSettings volumeSettings;
//     if (staircaseFade) {
//       volumeSettings = VolumeSettings.staircaseFade(
//         volume: volume,
//         fadeSteps: [
//           VolumeFadeStep(Duration.zero, 0),
//           VolumeFadeStep(const Duration(seconds: 15), 0.03),
//           VolumeFadeStep(const Duration(seconds: 20), 0.5),
//           VolumeFadeStep(const Duration(seconds: 30), 1),
//         ],
//       );
//     } else if (fadeDuration != null) {
//       volumeSettings = VolumeSettings.fade(
//         volume: volume,
//         fadeDuration: fadeDuration!,
//       );
//     } else {
//       volumeSettings = VolumeSettings.fixed(volume: volume);
//     }
//
//     final alarmSettings = AlarmSettings(
//       id: id,
//       dateTime: selectedDateTime,
//       loopAudio: loopAudio,
//       vibrate: vibrate,
//       assetAudioPath: assetAudio,
//       volumeSettings: volumeSettings,
//       allowAlarmOverlap: true,
//       notificationSettings: NotificationSettings(
//         title: 'Alarm example',
//         body: 'Your alarm ($id) is ringing',
//         stopButton: 'Stop the alarm',
//         icon: 'notification_icon',
//       ),
//     );
//     return alarmSettings;
//   }
//
//   void saveAlarm() {
//     if (loading) return;
//     setState(() => loading = true);
//     Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
//       if (res && mounted) Navigator.pop(context, true);
//       setState(() => loading = false);
//     });
//   }
//
//   void deleteAlarm() {
//     Alarm.stop(widget.alarmSettings!.id).then((res) {
//       if (res && mounted) Navigator.pop(context, true);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: Text(
//                   'Cancel',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge!
//                       .copyWith(color: Colors.blueAccent),
//                 ),
//               ),
//               TextButton(
//                 onPressed: saveAlarm,
//                 child: loading
//                     ? const CircularProgressIndicator()
//                     : Text(
//                         'Save',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleLarge!
//                             .copyWith(color: Colors.blueAccent),
//                       ),
//               ),
//             ],
//           ),
//           Text(
//             getDay(),
//             style: Theme.of(context)
//                 .textTheme
//                 .titleMedium!
//                 .copyWith(color: Colors.blueAccent.withValues(alpha: 0.8)),
//           ),
//           RawMaterialButton(
//             onPressed: pickTime,
//             fillColor: Colors.grey[200],
//             child: Container(
//               margin: const EdgeInsets.all(20),
//               child: Text(
//                 TimeOfDay.fromDateTime(selectedDateTime).format(context),
//                 style: Theme.of(context)
//                     .textTheme
//                     .displayMedium!
//                     .copyWith(color: Colors.blueAccent),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Loop alarm audio',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               Switch(
//                 value: loopAudio,
//                 onChanged: (value) => setState(() => loopAudio = value),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Vibrate',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               Switch(
//                 value: vibrate,
//                 onChanged: (value) => setState(() => vibrate = value),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Sound',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               DropdownButton(
//                 value: assetAudio,
//                 items: const [
//                   DropdownMenuItem<String>(
//                     value: 'assets/marimba.mp3',
//                     child: Text('Marimba'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'assets/nokia.mp3',
//                     child: Text('Nokia'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'assets/mozart.mp3',
//                     child: Text('Mozart'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'assets/star_wars.mp3',
//                     child: Text('Star Wars'),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: 'assets/one_piece.mp3',
//                     child: Text('One Piece'),
//                   ),
//                 ],
//                 onChanged: (value) => setState(() => assetAudio = value!),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Custom volume',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               Switch(
//                 value: volume != null,
//                 onChanged: (value) =>
//                     setState(() => volume = value ? 0.5 : null),
//               ),
//             ],
//           ),
//           if (volume != null)
//             SizedBox(
//               height: 45,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Icon(
//                     volume! > 0.7
//                         ? Icons.volume_up_rounded
//                         : volume! > 0.1
//                             ? Icons.volume_down_rounded
//                             : Icons.volume_mute_rounded,
//                   ),
//                   Expanded(
//                     child: Slider(
//                       value: volume!,
//                       onChanged: (value) {
//                         setState(() => volume = value);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Fade duration',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               DropdownButton<int>(
//                 value: fadeDuration?.inSeconds ?? 0,
//                 items: List.generate(
//                   6,
//                   (index) => DropdownMenuItem<int>(
//                     value: index * 5,
//                     child: Text('${index * 5}s'),
//                   ),
//                 ),
//                 onChanged: (value) => setState(
//                   () => fadeDuration =
//                       value != null ? Duration(seconds: value) : null,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Staircase fade',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               Switch(
//                 value: staircaseFade,
//                 onChanged: (value) => setState(() => staircaseFade = value),
//               ),
//             ],
//           ),
//           if (!creating)
//             TextButton(
//               onPressed: deleteAlarm,
//               child: Text(
//                 'Delete Alarm',
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium!
//                     .copyWith(color: Colors.red),
//               ),
//             ),
//           const SizedBox(),
//         ],
//       ),
//     );
//   }
// }
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

class ExampleAlarmEditScreen extends StatefulWidget {
  const ExampleAlarmEditScreen({super.key, this.alarmSettings});
  final AlarmSettings? alarmSettings;

  @override
  State<ExampleAlarmEditScreen> createState() => _ExampleAlarmEditScreenState();
}

class _ExampleAlarmEditScreenState extends State<ExampleAlarmEditScreen> {
  bool loading = false;
  late bool creating;
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1)).copyWith(
        second: 0,
        millisecond: 0,
      );
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        selectedDateTime = selectedDateTime.copyWith(
          year: date.year,
          month: date.month,
          day: date.day,
        );
      });
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (time != null) {
      setState(() {
        selectedDateTime = selectedDateTime.copyWith(
          hour: time.hour,
          minute: time.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    return AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: true,
      vibrate: true,
      assetAudioPath: 'assets/marimba.mp3',
      volumeSettings: VolumeSettings.fixed(volume: 0.5),
      allowAlarmOverlap: true,
      notificationSettings: NotificationSettings(
        title: 'Alarm',
        body: 'Your alarm is ringing',
        stopButton: 'Stop',
        icon: 'notification_icon',
      ),
    );
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);
    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res && mounted) Navigator.pop(context, true);
      setState(() => loading = false);
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res && mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(fontSize: 25, fontWeight: FontWeight.w500);
    final valueStyle = const TextStyle(fontSize: 25, color: Color(0xEF1BC5C5));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cancel / Save buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel', style: TextStyle(fontSize: 20, color: Color(0xEF1BC5C5))),
              ),
              TextButton(
                onPressed: saveAlarm,
                child: loading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Save', style: TextStyle(fontSize: 20, color: Color(0xEF1BC5C5))),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Date Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date', style: textStyle),
              TextButton(
                onPressed: pickDate,
                child: Text(
                  "${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')}",
                  style: valueStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Time Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Time', style: textStyle),
              TextButton(
                onPressed: pickTime,
                child: Text(
                  TimeOfDay.fromDateTime(selectedDateTime).format(context),
                  style: valueStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Delete button (if editing)
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: const Text(
                'Delete Alarm',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
