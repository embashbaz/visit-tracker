import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visit_tracker/common/time_utils.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_state.dart';

import '../../../../common/app_dropdown.dart';
import '../../../../common/bloc_utils.dart';
import '../../../../common/bottom_sheet_dialog.dart';
import '../../../../common/loading_button.dart';
import '../../../../common/size_config.dart';
import '../../../../common/text_field.dart';
import '../../../../data/remote/models/ActivityApiResponse.dart';
import '../../../../data/remote/models/CustomerApiResponse.dart';
import '../../domain/bloc/VisitBloc.dart';
import '../../domain/bloc/visit_events.dart';

class Visitnewpage extends StatefulWidget {
  const Visitnewpage({super.key});

  @override
  State<Visitnewpage> createState() => _VisitnewpageState();
}

class _VisitnewpageState extends State<Visitnewpage> {
  bool _isLoading = false;

  String? _location;

  String? _note;

  String? _selectedStatus;

  List<Activity>? _allActivities;

  List<Activity> _selectedActivities = List.empty(growable: true);

  List<Customer>? _allCustomers;

  Customer? _selectedCustomer;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void getData() {
    context.read<VisitsBloc>().add(GetNewVisitDataEventSink());
  }

  @override
  void initState() {
    super.initState();
    getData();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _selectedStatus = "Pending";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitsBloc, AppState>(
      listener: (_, state) {
        setState(() {
          _isLoading = state is LoadingState;
        });

        if (state is GetNewVisitDataSuccessState) {
          setState(() {
            _allActivities = state.activities;
            _allCustomers = state.customers;
          });
        }

        if (state is OnAddVisitSuccessState) {
          showModalBottomSheet<bool>(
            context: context,
            isDismissible: true,
            enableDrag: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            builder: (BuildContext context) {
              return showStatus(
                context,
                "Visit created",
                "Your visit has been created",
                "Finish",
                Icons.check_circle,
                Colors.green,
              );
            },
          ).then((value) {
            context.read<VisitsBloc>().add(EmptyEvent());
            Navigator.pop(context);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("New visit", style: const TextStyle(fontSize: 18)),
          titleTextStyle: const TextStyle(color: Colors.black),
          toolbarHeight: 56,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                MyMaterialDropdown(
                  options:
                      _allCustomers
                          ?.where((c) => c.name != null)
                          .map((c) => c.name ?? "")
                          .toList() ??
                      [],
                  onOptionSelected: (c) {
                    setState(() {
                      _selectedCustomer = _allCustomers?.firstWhere(
                        (element) => element.name == c,
                      );
                    });
                  },
                  initialOption: _selectedCustomer?.name,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Text(
                  "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                MyMaterialDropdown(
                  options: ["Completed", "Pending", "Cancelled"],
                  onOptionSelected: (s) {
                    setState(() {
                      _selectedStatus = s;
                    });
                  },
                  initialOption: "Pending",
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Row(
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextFieldContainer(
                          child: TextFormField(
                            enabled: false,
                            controller: TextEditingController(
                              text: _selectedDate?.getJustDate() ?? "",
                            ),

                            decoration: const InputDecoration(
                              hintText: "Date",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: TextFieldContainer(
                          child: TextFormField(
                            enabled: false,
                            controller: TextEditingController(
                              text:
                                  "${_selectedTime?.hour ?? ""}:${_selectedTime?.minute ?? ""}",
                            ),

                            decoration: const InputDecoration(
                              hintText: "Time",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Text(
                  "Notes",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                TextFieldContainer(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _note = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Notes",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Text(
                  "Location",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                TextFieldContainer(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _location = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "location",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Activities",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Activity? _newActivity;
                        showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                                title: const Text('Add activity'),
                                content: MyMaterialDropdown(
                                  options:
                                      _allActivities
                                          ?.where((a) => a.description != null)
                                          .map((c) => c.description ?? "")
                                          .toList() ??
                                      [],
                                  onOptionSelected: (a) {
                                    setState(() {
                                      _newActivity = _allActivities?.firstWhere(
                                        (element) => element.description == a,
                                      );
                                    });
                                  },
                                  initialOption: _newActivity?.description,
                                ),

                                actions: <Widget>[
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, "cancel"),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, "yes"),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ).then((dialogValue) {
                          if (dialogValue == "yes" &&
                              _selectedActivities.any(
                                    (a) => a.id == _newActivity?.id,
                                  ) !=
                                  true) {
                            if (_newActivity != null) {
                              setState(() {
                                _selectedActivities.add(_newActivity!);
                              });
                            }
                          }
                        });
                      },
                      child: Icon(Icons.add, size: 24),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                ..._selectedActivities.map(
                  (a) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              a.description ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.delete),
                            onTap: () {
                              setState(() {
                                _selectedActivities.remove(a);
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 36,
                    left: 26,
                    right: 26,
                    bottom: 30,
                  ),
                  child: LoadingMainBt(
                    name: "Save",
                    isLoading: _isLoading,
                    onPressed: () {
                      context.read<VisitsBloc>().add(
                        AddedVisitEventSink(
                          visitDate: DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          ),
                          status: _selectedStatus,
                          location: _location,
                          notes: _note,
                          activitiesDone: _selectedActivities,
                          customer: _selectedCustomer,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
}
