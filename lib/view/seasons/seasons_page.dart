import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common%20UI/CustomWidgetMethods.dart';
import 'package:scouts_system/common%20UI/empty_list_message.dart';
import 'package:scouts_system/view%20model/seasons.dart';
import 'package:scouts_system/view/seasons/add_year.dart';
import 'package:scouts_system/view/seasons/twoButtons.dart';

class SeasonsPage extends StatefulWidget {
  @override
  State<SeasonsPage> createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  Map<int, bool> selectedFlag = {};

  @override
  Widget build(BuildContext context) {
    List<Season> seasons = context.watch<DBSeasons>().seasons;

    return Scaffold(
      body: SafeArea(
        child: seasons.isEmpty
            ? showEmListptyMessage("year")
            : ListView.builder(
                itemBuilder: (context, index) {
                  selectedFlag[index] = selectedFlag[index] ?? false;
                  bool? isSelected = selectedFlag[index];
                  return buildExpansionTile(
                      a.elementAt(index), index, context, seasons, isSelected);
                },
                itemCount: seasons.length,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customColor(),
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddYear()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ExpansionPanelList buildExpansionTile(Season season, int index, context,
      Map<String, List<String>> data, bool? isSelected) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                season.year,
                style: const TextStyle(color: Colors.black),
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
          context.read<DBSeasons>().getListOfStudentsAndEvents(
              year: year, season: data[year]![index]);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TwoButtonInSeason()));
        },
        child: ListTile(
          title: Text(
            data[year]![index],
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
