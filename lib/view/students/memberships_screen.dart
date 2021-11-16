import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/primary_container.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'memberships_check_list_screen.dart';

// ignore: must_be_immutable
class MembershipsOfStudent extends StatefulWidget {
  String studentDocId;
  MembershipsOfStudent(this.studentDocId, {Key? key}) : super(key: key);

  @override
  _MembershipsOfStudentState createState() => _MembershipsOfStudentState();
}

class _MembershipsOfStudentState extends State<MembershipsOfStudent> {
  @override
  Widget build(BuildContext context) {
    return fetchingMemberships(context);
  }

  fetchingMemberships(BuildContext context) {
    SeasonsProvider provider = context.watch<SeasonsProvider>();
    if (provider.selectedMemberships.isEmpty &&
        provider.stateOfFetchingMemberships != StateOfMemberships.loaded) {
      provider.preparingMemberships(widget.studentDocId);
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, SeasonsProvider provider) {
    return Scaffold(
      appBar: AppBar(title: Text("Memberships")),
      body: provider.selectedMemberships.isEmpty
          ? emptyMessage("Memberships")
          : listView(provider),
      floatingActionButton: floatingActionButton(context),
    );
  }

  ListView listView(SeasonsProvider provider) {
    return ListView.separated(
      itemCount: provider.selectedMemberships.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final membership = provider.selectedMemberships[index];
        return ListTile(title: membershipItem(membership, index));
      },
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => pushToCheckBoxMembershipsPage(context),
      child: const Icon(Icons.edit),
    );
  }

  pushToCheckBoxMembershipsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StudentCheckBoxMemberships(widget.studentDocId)));
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
