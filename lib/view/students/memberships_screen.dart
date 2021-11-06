import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/circular_progress.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'memberships_check_list_screen.dart';

class MembershipsOfStudent extends StatelessWidget {
  String studentDocId;
  MembershipsOfStudent(this.studentDocId);

  Widget build(BuildContext context) {
    SeasonsLogic provider = context.watch<SeasonsLogic>();
    if (provider.studentMemberships.isEmpty &&
        provider.stateOfFetching != StateOfMemberships.loaded) {
      provider.preparingMemberships(studentDocId);
      return CircularProgress();
    } else {
      return buildScaffold(context, provider);
    }
  }

  Scaffold buildScaffold(BuildContext context, SeasonsLogic provider) {
    return Scaffold(
      appBar: AppBar(),
      body: provider.studentMemberships.isEmpty
          ? emptyMessage("memberships")
          : buildListView(provider),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  ListView buildListView(SeasonsLogic provider) {
    return ListView.separated(
      itemCount: provider.studentMemberships.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: buildTheItemOfTheList(provider.studentMemberships[index], index),
        );
      },
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressedFloating(context),
      child: Icon(Icons.add),
    );
  }

  onPressedFloating(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentCheckBoxMemberships(studentDocId)));
  }

  SafeArea buildTheItemOfTheList(Memberships membership, int index) {
    return SafeArea(
      child: InkWell(
        onTap: () async {},
        child: buildContainer(membership, index),
      ),
    );
  }

  Container buildContainer(Memberships membership, int index) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          buildCircleAvatarNumber(index),
          buildColumn(membership),
        ],
      ),
    );
  }

  Expanded buildColumn(Memberships membership) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: buildColumnOfTexts(membership),
      ),
    );
  }

  Column buildColumnOfTexts(Memberships membership) {
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
      style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic),
    );
  }

  CircleAvatar buildCircleAvatarNumber(int index) {
    return CircleAvatar(
      radius: 25,
      child: ClipOval(
        child: Text(
          "${index + 1}",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
