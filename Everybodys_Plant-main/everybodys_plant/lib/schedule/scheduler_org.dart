import 'package:everybodys_plant/service/schedule_service.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:everybodys_plant/login/plantlogin.dart';

// class Scheduler_org_Page extends StatefulWidget {
//   const Scheduler_org_Page({Key? key}) : super(key: key);

//   @override
//   State<Scheduler_org_Page> createState() => _Scheduler_org_PageState();
// }

// class _Scheduler_org_PageState extends State<Scheduler_org_Page> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: TableCalendar(
//       firstDay: DateTime.utc(2010, 10, 16),
//       lastDay: DateTime.utc(2030, 3, 14),
//       focusedDay: DateTime.now(),
//     ));
//   }
// }

// class Schedule_org extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scheduler_org_Page(title: 'Everybodys Plants Schedule'),
//     );
//   }
// }

// class Scheduler_org_Page extends StatefulWidget {
//   Scheduler_org_Page({Key? key, this.title}) : super(key: key);
//   final String? title;
//   @override
//   _Scheduler_org_PageState createState() => _Scheduler_org_PageState();
// }

// class _Scheduler_org_PageState extends State<Scheduler_org_Page> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title!),
//       ),
//       body: TableCalendar(
//         firstDay: DateTime.utc(2010, 10, 16),
//         lastDay: DateTime.utc(2030, 3, 14),
//         focusedDay: _focusedDay,
//         calendarFormat: _calendarFormat,
//         // selectedDayPredicate: (day) {
//         //   // Use `selectedDayPredicate` to determine which day is currently selected.
//         //   // If this returns true, then `day` will be marked as selected.

//         //   // Using `isSameDay` is recommended to disregard
//         //   // the time-part of compared DateTime objects.
//         //   return isSameDay(_selectedDay, day);
//         // },
//         // onDaySelected: (selectedDay, focusedDay) {
//         //   if (!isSameDay(_selectedDay, selectedDay)) {
//         //     // Call `setState()` when updating the selected day
//         //     setState(() {
//         //       _selectedDay = selectedDay;
//         //       _focusedDay = focusedDay;
//         //     });
//         //   }
//         // },
//         // onFormatChanged: (format) {
//         //   if (_calendarFormat != format) {
//         //     // Call `setState()` when updating calendar format
//         //     setState(() {
//         //       _calendarFormat = format;
//         //     });
//         //   }
//         // },
//         // onPageChanged: (focusedDay) {
//         //   // No need to call `setState()` here
//         //   _focusedDay = focusedDay;
//         // },
//       ),
//     );
//   }
// }

// ignore: camel_case_types
class Plant_schedule_Page extends StatefulWidget {
  const Plant_schedule_Page({Key? key}) : super(key: key);

  @override
  State<Plant_schedule_Page> createState() => _Plant_schedule_PageState();
}

// ignore: camel_case_types
class _Plant_schedule_PageState extends State<Plant_schedule_Page> {
  // ?????? ???????????? ??????
  CalendarFormat calendarFormat = CalendarFormat.month;

  // ????????? ??????
  DateTime selectedDate = DateTime.now();

  // create text controller
  TextEditingController createTextController = TextEditingController();

  // update text controller
  TextEditingController updateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantService>(
      builder: (context, plantService, child) {
        List<Plant> plantList = plantService.getByDate(selectedDate);
        return Scaffold(
          // ???????????? ????????? ??? ?????? ?????? ????????? ?????????(overflow ??????)
          appBar: AppBar(
            title: Text("Calendar"),
            actions: [
              TextButton(
                child: Text(
                  "????????????",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  print("sign out");
                  // ????????? ???????????? ??????
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginHome()),
                  );
                },
              ),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                /// ??????
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: selectedDate,
                  calendarFormat: calendarFormat,
                  onFormatChanged: (format) {
                    // ?????? ?????? ??????
                    setState(() {
                      calendarFormat = format;
                    });
                  },
                  eventLoader: (date) {
                    // ??? ????????? ???????????? plantList ????????????
                    return plantService.getByDate(date);
                  },
                  calendarStyle: CalendarStyle(
                    // today ?????? ??????
                    todayTextStyle: TextStyle(color: Colors.black),
                    todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDate, day);
                  },
                  onDaySelected: (_, focusedDay) {
                    setState(() {
                      selectedDate = focusedDay;
                    });
                  },
                ),
                Divider(height: 1),

                /// ????????? ????????? ?????? ??????
                Expanded(
                  child: plantList.isEmpty
                      ? Center(
                          child: Text(
                            "????????? ????????? ????????????.\n ????????? ??????????????????",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: plantList.length,
                          itemBuilder: (context, index) {
                            // ???????????? ????????????
                            int i = plantList.length - index - 1;
                            Plant diary = plantList[i];
                            return ListTile(
                              /// text
                              title: Text(
                                diary.text,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),

                              /// createdAt
                              trailing: Text(
                                DateFormat('kk:mm').format(diary.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              /// ???????????? update
                              onTap: () {
                                showUpdateDialog(plantService, diary);
                              },

                              /// ??? ????????? delete
                              onLongPress: () {
                                showDeleteDialog(plantService, diary);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            // item ????????? Divider ??????
                            return Divider(height: 1);
                          },
                        ),
                ),
              ],
            ),
          ),

          /// Floating Action Button
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            backgroundColor: Colors.indigo,
            onPressed: () {
              showCreateDialog(plantService);
            },
          ),
        );
      },
    );
  }

  /// ????????????
  /// ????????? ???????????? ?????? ????????? ????????? ?????? ??????
  void createDiary(PlantService plantService) {
    // ?????? ?????? ??????
    String newText = createTextController.text.trim();
    if (newText.isNotEmpty) {
      plantService.create(newText, selectedDate);
      createTextController.text = "";
    }
  }

  /// ????????????
  /// ????????? ???????????? ?????? ????????? ????????? ?????? ??????
  void updateDiary(PlantService plantService, Plant diary) {
    // ?????? ?????? ??????
    String updatedText = updateTextController.text.trim();
    if (updatedText.isNotEmpty) {
      plantService.update(
        diary.createdAt,
        updatedText,
      );
    }
  }

  /// ?????? ??????????????? ????????????
  void showCreateDialog(PlantService plantService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("?????? ??????"),
          content: TextField(
            controller: createTextController,
            autofocus: true,
            // ?????? ??????
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              hintText: "????????? ??????????????????.",
              // ????????? ????????? ??? ?????? ??????
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
            ),
            onSubmitted: (_) {
              // ?????? ?????? ??? ????????????
              createDiary(plantService);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// ?????? ??????
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "??????",
                style: TextStyle(color: Colors.indigo),
              ),
            ),

            /// ?????? ??????
            TextButton(
              onPressed: () {
                createDiary(plantService);
                Navigator.pop(context);
              },
              child: Text(
                "??????",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ?????? ??????????????? ????????????
  void showUpdateDialog(PlantService plantService, Plant diary) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = diary.text;
        return AlertDialog(
          title: Text("?????? ??????"),
          content: TextField(
            autofocus: true,
            controller: updateTextController,
            // ?????? ??????
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              hintText: "??? ??? ????????? ????????? ?????????.",
              // ????????? ????????? ??? ?????? ??????
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
            ),
            onSubmitted: (v) {
              // ?????? ?????? ??? ????????????
              updateDiary(plantService, diary);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// ?????? ??????
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// ?????? ??????
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () {
                // ????????????
                updateDiary(plantService, diary);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// ?????? ??????????????? ????????????
  void showDeleteDialog(PlantService plantService, Plant diary) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = diary.text;
        return AlertDialog(
          title: Text("?????? ??????"),
          content: Text('"${diary.text}"??? ?????????????????????????'),
          actions: [
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// Delete
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () {
                plantService.delete(diary.createdAt);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
