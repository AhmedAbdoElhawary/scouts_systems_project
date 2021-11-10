import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'memberships_check_list_screen.dart';

// ignore: must_be_immutable
class MembershipsOfStudent extends StatelessWidget {
  String studentDocId;
  MembershipsOfStudent(this.studentDocId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fetchingMemberships(context);
  }

  fetchingMemberships(BuildContext context) {
    SeasonsProvider provider = context.watch<SeasonsProvider>();
    if (provider.studentMemberships.isEmpty &&
        provider.stateOfFetchingMemberships != StateOfMemberships.loaded) {
      provider.preparingMemberships(studentDocId);
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, SeasonsProvider provider) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.studentMemberships.isEmpty
          ? emptyMessage("memberships")
          : listView(provider),
      floatingActionButton: floatingActionButton(context),
    );
  }

  ListView listView(SeasonsProvider provider) {
    return ListView.separated(
      itemCount: provider.studentMemberships.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: membershipItem(provider.studentMemberships[index], index),
        );
      },
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => pushToCheckBoxMembershipsPage(context),
      child: const Icon(Icons.add),
    );
  }

  pushToCheckBoxMembershipsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentCheckBoxMemberships(studentDocId)));
  }

  InkWell membershipItem(Membership membership, int index) {
    return InkWell(
      onTap: () async {},
      child: PrimaryListItem(
          index: index,
          rightTopText: membership.year,
          rightBottomText: membership.seasonType),
    );
  }
}
