import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/empty_message.dart';
import 'package:scouts_system/common_ui/primary_color.dart';
import 'package:scouts_system/view/seasons/students_and_events_buttons.dart';
import 'package:scouts_system/view_model/seasons.dart';

import 'add_season_item.dart';

class SeasonsPage extends StatefulWidget {
  @override
  State<SeasonsPage> createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    context.read<SeasonsGetDataFirestore>().getAllSeasonsData();
    Map<String, List<String>> listOfSeasonsData =
        context.watch<SeasonsGetDataFirestore>().listOfSeasons;
    Iterable<String> a = listOfSeasonsData.keys;

    return Scaffold(
      body: SafeArea(
        child: listOfSeasonsData.length == 0
            ? buildShowMessage("year")
            : ListView.builder(
                itemBuilder: (context, index) {
                  selectedFlag[index] = selectedFlag[index] ?? false;
                  bool? isSelected = selectedFlag[index];
                  return buildExpansionTile(a.elementAt(index), index, context,
                      listOfSeasonsData, isSelected);
                },
                itemCount: listOfSeasonsData.length,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customColor(),
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddYear()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ExpansionPanelList buildExpansionTile(String year, int index, context,
      Map<String, List<String>> data, bool? isSelected) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                year,
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          body: buildListViewSeasons(data, year),
          isExpanded: isSelected!,
          canTapOnHeader: true,
        ),
      ],
      dividerColor: Colors.grey,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          selectedFlag[index] = !isSelected;
        });
      },
    );
  }

  ListView buildListViewSeasons(Map<String, List<String>> data, String year) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data[year]!.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          context.read<SeasonsGetDataFirestore>().getListOfStudentsAndEvents(
              year: year, season: data[year]![index]);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TwoButtonInSeason()));
        },
        child: ListTile(
          title: Text(
            data[year]![index],
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
