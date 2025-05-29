import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_events.dart';

import '../../../../common/bloc_utils.dart';
import '../../../../common/size_config.dart';
import '../../../../common/time_utils.dart';
import '../../domain/bloc/VisitBloc.dart';
import '../../domain/bloc/visit_state.dart';
import '../../domain/model/Visit.dart';

class Visitdetailpage extends StatefulWidget {
  const Visitdetailpage({super.key, required this.visitId});

  final int visitId;

  @override
  State<Visitdetailpage> createState() => _VisitdetailpageState();
}

class _VisitdetailpageState extends State<Visitdetailpage> {
  bool _isLoading = false;

  Visit? _selectedVisit;


  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    context.read<VisitsBloc>().add(GetSingleVisitEventSink(visitId: widget.visitId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitsBloc, AppState>(
      listener: (_, state) {
        setState(() {
          _isLoading = state is LoadingState;
        });
        if (state is GetSingleVisitSuccessState) {
          setState(() {
            _selectedVisit = state.visit;
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
                _isLoading ? LinearProgressIndicator() : SizedBox(),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Text(
                  "Customer",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                Text(
                  _selectedVisit?.customer?.name ?? "N/A",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
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
                Text(
                  _selectedVisit?.status ?? "N/A",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Text(
                  "Date",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                Text(
                  formatTimeToStandard(_selectedVisit?.visitDate),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
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
                Text(
                  _selectedVisit?.location ?? "N/A",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
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
                Text(
                  _selectedVisit?.notes ?? "N/A",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Text(
                  "Activities",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                ...(_selectedVisit?.activitiesDone?.map(
                      (a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          a.description ?? "N/A",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ) ??
                    []),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
