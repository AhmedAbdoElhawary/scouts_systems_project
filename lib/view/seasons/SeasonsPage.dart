import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scouts_system/view%20model/seasonsGetDataFirestore.dart';
import 'package:scouts_system/view/seasons/addYear.dart';
import 'package:scouts_system/view/seasons/twoButtons.dart';

class SeasonsPage extends StatefulWidget {
  @override
  State<SeasonsPage> createState() => _SeasonsPageState();
}

class _SeasonsPageState extends State<SeasonsPage> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    context.read<SeasonsGetDataFirestore>().getAllSeasonsData();
    Map<String, List<String>> listOfSeasonsData =
        context.watch<SeasonsGetDataFirestore>().listOfSeasons;
    Iterable<String> a = listOfSeasonsData.keys;

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) => buildExpansionTile(
              a.elementAt(index), index, context, listOfSeasonsData),
          itemCount: listOfSeasonsData.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddYear()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ExpansionPanelList buildExpansionTile(
      String year, int index, context, Map<String, List<String>> data) {
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
          body: ListView.builder(
            shrinkWrap: true,
            itemCount: data[year]!.length,
            itemBuilder: (context, index) => InkWell(
              onTap: (){
                context
                    .read<SeasonsGetDataFirestore>()
                    .getListOfStudentsAndEvents(year: year, season: data[year]![index]);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TwoButton()));
              },
              child: ListTile(
                title: Text(
                  data[year]![index],
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          isExpanded: _expanded,
          canTapOnHeader: true,
        ),
      ],
      dividerColor: Colors.grey,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _expanded = !_expanded;
        });
        },
    );
  }
}
