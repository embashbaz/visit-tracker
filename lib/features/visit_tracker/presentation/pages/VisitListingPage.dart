import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/VisitBloc.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_events.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/visit_state.dart';
import 'package:visit_tracker/features/visit_tracker/domain/model/Visit.dart';
import 'package:visit_tracker/features/visit_tracker/presentation/pages/VisitNewPage.dart';

import '../../../../common/bloc_utils.dart';
import '../../../../common/bottom_sheet_dialog.dart';
import '../../../../common/size_config.dart';
import '../widgets/VisitListingItem.dart';
import '../widgets/VisitsStatsItem.dart';
import 'VisitDetailPage.dart';

class Visitlistingpage extends StatefulWidget {
  const Visitlistingpage({super.key});

  @override
  State<Visitlistingpage> createState() => _VisitlistingpageState();
}

class _VisitlistingpageState extends State<Visitlistingpage> {
  String? _searchTerm;

  List<Visit>? _visits;
  bool _isLoading = false;

  int? _visitCount;
  int? _pendingCount;
  int? _completedCount;
  int? _cancelledCount;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    context.read<VisitsBloc>().add(GetVisitsEventSink(term: _searchTerm));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VisitsBloc, AppState>(
      listener: (_, state) {
        setState(() {
          _isLoading = state is LoadingState;
        });

        if (state is GetVisitsSuccessState) {
          setState(() {
            _visits = state.visits;
            _visitCount = state.allVisitsCount;
            _pendingCount = state.pendingVisitsCount;
            _completedCount = state.completedVisitsCount;
            _cancelledCount = state.cancelledVisitsCount;
          });
        }

        if (state is ErrorState) {
          onError(
            state.message,
            context,
            onSuccess: () {
              getData();
            },
            onErrorResult: () {
              context.read<VisitsBloc>().add(EmptyEvent());
            },
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          // Provide an onPressed callback.
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Visitnewpage()),
            );
            getData();
          },
          child: const Icon(Icons.add, size: 36, color: Colors.white),
        ),
        body: PopScope(
          onPopInvoked: (value) {
            if (value) {
              exit(0);
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: (_visits?.length ?? 0) + 1,
                // extra slot for header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isLoading ? LinearProgressIndicator() : SizedBox(),
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Visitsstatsitem(
                                status: "",
                                count: _visitCount,
                                text: "visits in total",
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeVertical! * 2),
                            Flexible(
                              child: Visitsstatsitem(
                                status: "Completed",
                                count: _completedCount,
                                text: "completed visits",
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeVertical! * 2),
                            Flexible(
                              child: Visitsstatsitem(
                                status: "Cancelled",
                                count: _cancelledCount,
                                text: "cancelled visits",
                              ),
                            ),
                            SizedBox(width: SizeConfig.blockSizeVertical! * 2),
                            Flexible(
                              child: Visitsstatsitem(
                                status: "pending",
                                count: _pendingCount,
                                text: "Pending visits",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.search),
                              SizedBox(
                                width: SizeConfig.blockSizeHorizontal! * 2,
                              ),
                              Flexible(
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _searchTerm = value;
                                    });
                                    getData();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: InputBorder.none,
                                    isDense: true, // makes it more compact
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                    ), // adjust this as needed
                                  ),
                                  controller: TextEditingController(
                                      text: _searchTerm,
                                    )
                                    ..selection = TextSelection.collapsed(
                                      offset: _searchTerm?.length ?? 0,
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                      ],
                    );
                  }

                  if (_visits?.length != null && _visits!.length > 1) {
                    final item = _visits?[index - 1];
                    return InkWell(
                      onTap: () async {
                        if(item.id != null) {
                          await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Visitdetailpage(visitId: item.id!)),
                        );
                        }
                        getData();

                      },
                      child: Visitlistingitem(visit: item!),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
