import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'memberships_check_list_screen.dart';

// ignore: must_be_immutable
class MembershipsOfStudent extends StatelessWidget {
  String studentDocId;
  MembershipsOfStudent(this.studentDocId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      //fetching data
    SeasonsLogic provider = context.watch<SeasonsLogic>();
    if (provider.studentMemberships.isEmpty &&
        provider.stateOfFetchingMemberships != StateOfMemberships.loaded) {
      provider.preparingMemberships(studentDocId);
      //----------->
      return const CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, SeasonsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.studentMemberships.isEmpty
          ? emptyMessage("memberships")
          : listView(provider),
      floatingActionButton: floatingActionButton(context),
    );
  }

  ListView listView(SeasonsLogic provider) {
    return ListView.separated(
      itemCount: provider.studentMemberships.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title:
              membershipItem(provider.studentMemberships[index], index),
        );
      },
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressedFloating(context),
      child: const Icon(Icons.add),
    );
  }

  onPressedFloating(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentCheckBoxMemberships(studentDocId)));
  }

  SafeArea membershipItem(Memberships membership, int index) {
    return SafeArea(
      child: InkWell(
        onTap: () async {},
        child: containerOfItem(membership, index),
      ),
    );
  }

  SizedBox containerOfItem(Memberships membership, int index) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          circleAvatarNumber(index),
          columnMembership(membership),
        ],
      ),
    );
  }

  Expanded columnMembership(Memberships membership) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: columnOfTexts(membership),
      ),
    );
  }

  Column columnOfTexts(Memberships membership) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(membership.year),
        buildText(membership.seasonType),
      ],
    );
  }

  Text buildText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic),
    );
  }

  CircleAvatar circleAvatarNumber(int index) {
    return CircleAvatar(
      radius: 25,
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
