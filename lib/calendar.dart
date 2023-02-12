import 'package:ariaquickpay/calendar_utils.dart';
import 'package:ariaquickpay/models/due_dates.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:ariaquickpay/add_billers.dart';
import 'package:ariaquickpay/make_payments.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'edit_biller.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';
import 'aria_providers.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

class calendarBills extends StatefulWidget {
  const calendarBills({Key? key, required this.client}) : super(key: key);
  final Client client;

  @override
  State<calendarBills> createState() => _calendarBillsState();
}

class _calendarBillsState extends State<calendarBills> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late Future<List> _getCalendarDataAsync;
  late var kEvents;

  @override
  void initState() {
    super.initState();
    kEvents = {};
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _getCalendarDataAsync = getCalendarData();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(
    DateTime day,
  ) {
    // Implementation example

    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      if (mounted) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _rangeStart = null; // Important to clean those
          _rangeEnd = null;
          _rangeSelectionMode = RangeSelectionMode.toggledOff;
        });
      }

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if (mounted) {
      setState(() {
        _selectedDay = null;
        _focusedDay = focusedDay;
        _rangeStart = start;
        _rangeEnd = end;
        _rangeSelectionMode = RangeSelectionMode.toggledOn;
      });
    }

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        client: widget.client,
      ),
      drawer: MyDrawer(
        client: widget.client,
      ),
      bottomNavigationBar: MyBottomBar(
        client: widget.client,
        typeOfB: "calendar",
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(94, 167, 203, 1),
                Color.fromRGBO(94, 167, 203, 1),
              ],
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Bills Calendar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          child: Text(
                            "View Due Dates",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              //fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(238, 236, 236, 1),
                      Color.fromRGBO(238, 236, 236, 1),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("My Bills Calendar"),
                        ],
                      ),
                      Expanded(
                          child: Container(
                        child: FutureBuilder<List>(
                          future: _getCalendarDataAsync,
                          builder: (context, snapshot) {
                            var mycalendarData = snapshot.data ?? [];

                            //print(
                            //"this is calendar ${mycalendarData.runtimeType}");
                            //List<dynamic> newList =
                            //List<dynamic>.from(calendarData);
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Column(children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircularProgressIndicator(),
                                ]);
                              default:
                                if (snapshot.hasError) {
                                  //print(snapshot.error);
                                  return Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                            "Unable to load calendar! Try Again!"),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                } else {
                                  final _kEventSource = Map.fromIterable(
                                      mycalendarData,
                                      key: (item) => DateTime.utc(
                                          DateTime.parse(item.due_date).year,
                                          DateTime.parse(item.due_date).month,
                                          DateTime.parse(item.due_date).day),
                                      value: (item) {
                                        //print(
                                        //"This is item ${item.bill_name[0].name}");
                                        return List.generate(
                                            item.bill_name.length, (index) {
                                          return Event(
                                              item.bill_name[index].name);
                                        });
                                      });
                                  kEvents =
                                      LinkedHashMap<DateTime, List<Event>>(
                                    equals: isSameDay,
                                    hashCode: getHashCode,
                                  )..addAll(_kEventSource);

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TableCalendar<Event>(
                                        firstDay: DateTime.utc(2021, 10, 16),
                                        lastDay: DateTime.utc(2030, 3, 14),
                                        focusedDay: _focusedDay,
                                        selectedDayPredicate: (day) =>
                                            isSameDay(_selectedDay, day),
                                        rangeStartDay: _rangeStart,
                                        rangeEndDay: _rangeEnd,
                                        calendarFormat: _calendarFormat,
                                        rangeSelectionMode: _rangeSelectionMode,
                                        eventLoader: _getEventsForDay,
                                        startingDayOfWeek:
                                            StartingDayOfWeek.monday,
                                        calendarStyle: CalendarStyle(
                                          // Use `CalendarStyle` to customize the UI
                                          outsideDaysVisible: false,
                                        ),
                                        onDaySelected: _onDaySelected,
                                        onRangeSelected: _onRangeSelected,
                                        onFormatChanged: (format) {
                                          if (_calendarFormat != format) {
                                            if (mounted) {
                                              setState(() {
                                                _calendarFormat = format;
                                              });
                                            }
                                          }
                                        },
                                        onPageChanged: (focusedDay) {
                                          _focusedDay = focusedDay;
                                        },
                                      ),
                                      const SizedBox(height: 10.0),
                                      Expanded(
                                        child:
                                            ValueListenableBuilder<List<Event>>(
                                          valueListenable: _selectedEvents,
                                          builder: (context, value, _) {
                                            return ListView.builder(
                                              itemCount: value.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  height: 40,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12.0,
                                                    vertical: 4.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        '${value[index]}',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255, 19, 82, 133),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                            }
                          },
                        ),
                      ))
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> getCalendarData() async {
    //print('running it');
    final url = myurls.AriaApiEndpoints.getCalendarData;
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    List<myCalendarDataResponse> calendar_list_response = [];
    //var datesList = [];
    if (userToken != '') {
      var getCalendarResponse = await widget.client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
      );
      if (getCalendarResponse.statusCode == 200) {
        var getCalendarResponseJsons = json.decode(getCalendarResponse.body);
        for (var calendarData in getCalendarResponseJsons) {
          calendar_list_response
              .add(myCalendarDataResponse.fromJson(calendarData));
          //print("hey ${calendar_list_response.length}");
        }

        return calendar_list_response;
      } else {
        //print("Eeverything not okay");
        return calendar_list_response;
      }
    }
    //print("Eeverything not not not okay");
    return calendar_list_response;
  }
}
