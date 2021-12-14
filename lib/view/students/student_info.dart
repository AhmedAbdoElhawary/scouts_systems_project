import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:scouts_system/common_ui/show_dialog_image.dart';
import 'package:scouts_system/model/firebase_storage.dart';
import 'package:scouts_system/model/firestore/add_students.dart';
import 'package:scouts_system/view_model/seasons.dart';
import 'package:scouts_system/view_model/students.dart';
import 'package:uuid/uuid.dart';
import 'memberships_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: must_be_immutable
class StudentInformationScreen extends StatefulWidget {
  TextEditingController controllerOfName,
      controllerOfDescription,
      controllerOfHours;
  String birthdate, studentDocId;
  bool checkForUpdate;
  String imageUrl;
  String theReportName;
  String stateOfTheReport;
  String reportUrl;
  StudentInformationScreen(
      {Key? key,
      this.studentDocId = "",
      this.imageUrl =
          "https://3znvnpy5ek52a26m01me9p1t-wpengine.netdna-ssl.com/wp-content/uploads/2017/07/noimage_person.png",
      required this.birthdate,
      required this.controllerOfDescription,
      required this.controllerOfHours,
      this.reportUrl = "",
      required this.controllerOfName,
      this.theReportName = "",
      this.stateOfTheReport = "Not started",
      this.checkForUpdate = false})
      : super(key: key);
  @override
  State<StudentInformationScreen> createState() =>
      _StudentInformationScreenState();
}

class _StudentInformationScreenState extends State<StudentInformationScreen> {
  bool userNameValidate = false;
  bool userDescriptionValidate = false;
  bool userHoursValidate = false;
  DateTime? date;
  File? _imageFile;
  final picker = ImagePicker();
  bool isImageUploaded = true;
  bool isReportUploaded = true;
  bool? selectedFlag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.controllerOfName.text), actions: actionsWidgets()),
      body: Column(
        children: [
          circleAvatarAndTextFields(),
          saveAndCancelButtons(context),
        ],
      ),
    );
  }

  List<Widget> actionsWidgets() {
    if (widget.studentDocId.isNotEmpty) {
      return [
        IconButton(
            onPressed: () {
              FirestoreStudents().deleteStudent(widget.studentDocId);
              updatePreviousScreenData();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete))
      ];
    } else {
      return [];
    }
  }

  SizedBox saveAndCancelButtons(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: rowOfButtons(context),
    );
  }

  Row rowOfButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buttonOfCancel(context),
        buttonOfSave(context),
      ],
    );
  }

  Expanded buttonOfCancel(BuildContext context) {
    return Expanded(
      child: TextButton(
          child: textOfCancel(), onPressed: () => onPressedCancelButton()),
    );
  }

  onPressedCancelButton() async {
    try {
      FirebaseStorageFile().deleteFileFromStorage(widget.imageUrl);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
    updatePreviousScreenData();
  }

  Text textOfCancel() {
    return const Text("Cancel",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  Expanded buttonOfSave(BuildContext context) {
    return Expanded(
      child: TextButton(
          child: textOfSave(), onPressed: () => checkValidationFields()),
    );
  }

  Text textOfSave() {
    return const Text("Save",
        style: TextStyle(
            fontSize: 25, color: Colors.black, fontWeight: FontWeight.normal));
  }

  checkValidationFields() {
    if (validateTextField(widget.controllerOfName.text) &&
            validateTextField(widget.controllerOfDescription.text) &&
            widget.checkForUpdate
        ? validateTextField(widget.controllerOfHours.text)
        : true) {
      updatePreviousScreenData();
      widget.checkForUpdate ? updateStudent() : addStudent();
      Navigator.pop(context);
    }
  }

  updatePreviousScreenData() {
    StudentsProvider provider = context.read<StudentsProvider>();
    provider.preparingStudents();
  }

  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {
      setState(() {
        userNameValidate = true;
        userDescriptionValidate = true;
        userHoursValidate = true;
      });
      return false;
    }
    setState(() {
      userNameValidate = false;
      userDescriptionValidate = false;
      userHoursValidate = false;
    });
    return true;
  }

  updateStudent() {
    FirestoreStudents().updateStudent(
        name: widget.controllerOfName.text,
        description: widget.controllerOfDescription.text,
        volunteeringHours: widget.controllerOfHours.text,
        date: getBirthdate(),
        studentDocId: widget.studentDocId,
        studentImageUrl: widget.imageUrl,
        stateOfTheReport: widget.stateOfTheReport,
        theReportName: widget.theReportName,
        reportUrl: widget.reportUrl);
  }

  addStudent() {
    FirestoreStudents().addStudent(
        name: widget.controllerOfName.text,
        description: widget.controllerOfDescription.text,
        volunteeringHours: widget.controllerOfHours.text,
        date: getBirthdate(),
        imageUrl: widget.imageUrl,
        stateOfTheReport: widget.stateOfTheReport,
        theReportName: widget.theReportName,
        reportUrl: widget.reportUrl);
  }

  Expanded circleAvatarAndTextFields() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          child: textFieldsColumn(),
        ),
      ),
    );
  }

  Column textFieldsColumn() {
    return Column(
      //I can't replace divider with (space between) or any something else
      children: [
        const SizedBox(height: 8),
        imageCircleAvatar(),
        const SizedBox(height: 8),
        Center(
            child: Text(
          widget.stateOfTheReport,
          style: const TextStyle(fontSize: 22, color: Colors.black38),
        )),
        const Divider(),
        textFormField(widget.controllerOfName, "Name"),
        const Divider(),
        textFormField(widget.controllerOfDescription, "Description"),
        columnOfPickDate(),
        const Divider(),
        widget.checkForUpdate
            ? textFormField(widget.controllerOfHours, "Volunteering Hours")
            : const Divider(),
        attachFileButtons(),
        listTile(),
        widget.checkForUpdate ? membershipsButton() : emptyMessage(),
      ],
    );
  }

  ListTile listTile() {
    selectedFlag = selectedFlag ??
        (widget.stateOfTheReport == "Finished without report" ||
                widget.stateOfTheReport == "Finished with report"
            ? true
            : false);

    return ListTile(
      onTap: () => onTapTitle(),
      trailing: _selectIcon(),
      leading: const Text("Mark as finished"),
    );
  }

  void onTapTitle() {
    setState(() {
      selectedFlag = selectedFlag! ? false : true;
      widget.stateOfTheReport = selectedFlag!
          ? (widget.theReportName.isEmpty
              ? "Finished without report"
              : "Finished with report")
          : "Not Started";
    });
  }

  Widget _selectIcon() {
    return Icon(
      selectedFlag! ? Icons.check_box : Icons.check_box_outline_blank,
      color: Colors.blue,
    );
  }

  Center imageCircleAvatar() {
    return Center(
        child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        studentCircleAvatarImage(),
        Positioned(
            right: 5,
            bottom: 5,
            child: InkWell(
              onTap: () => showBottomSheet(),
              child: circleAvatarOfCamera(),
            )),
      ],
    ));
  }

  InkWell studentCircleAvatarImage() {
    return InkWell(
      onTap: () => showDialogImage(context, widget.imageUrl),
      child: isImageUploaded
          ? (_imageFile == null
              ? circleAvatar(NetworkImage(widget.imageUrl))
              : circleAvatar(FileImage(File(_imageFile!.path))))
          : progressCircleAvatar(),
    );
  }

  CircleAvatar circleAvatar(ImageProvider<Object>? image) {
    return CircleAvatar(
      backgroundColor: Colors.black12,
      radius: 80,
      backgroundImage: image,
    );
  }

  CircleAvatar progressCircleAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.black12,
      radius: 80,
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 100,
          child: deleteAndEditButtons(),
        );
      },
    );
  }

  Row deleteAndEditButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
        deleteImageButton(),
        editImageButton(),
      ],
    );
  }

  ElevatedButton deleteImageButton() {
    return ElevatedButton(
      child: const Text('Delete'),
      onPressed: () => deleteImageFromFirebase(),
    );
  }

  deleteImageFromFirebase() {
    try {
      FirebaseStorageFile().deleteFileFromStorage(widget.imageUrl);
      setState(() {
        widget.imageUrl =
            "https://3znvnpy5ek52a26m01me9p1t-wpengine.netdna-ssl.com/wp-content/uploads/2017/07/noimage_person.png";
      });
      FirestoreStudents().updateImageUrl(
          studentDocId: widget.studentDocId, imageUrl: widget.imageUrl);
    } catch (e) {}
  }

  ElevatedButton editImageButton() {
    return ElevatedButton(
      child: const Text('Edit'),
      onPressed: () {
        if (kIsWeb) {
          pickImageForWeb();
        } else {
          pickImageForMobile();
        }
      },
    );
  }

  Padding attachFileButtons() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            children: [
              nameOfTheReport(),
              addReportButton(),
              deleteReportButton()
            ],
          ),
        ],
      ),
    );
  }

  Expanded nameOfTheReport() {
    return Expanded(
      child: isReportUploaded
          ? Text(
              widget.theReportName,
              softWrap: false,
              overflow: TextOverflow.fade,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Align addReportButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.attach_file),
        onPressed: () {
          if (kIsWeb) {
            onPickerFile(true);
          } else {
            onPickerFile(false);
          }
        },
      ),
    );
  }

  IconButton deleteReportButton() {
    return IconButton(
      icon: const Icon(Icons.remove_circle),
      onPressed: () {
        setState(() {
          widget.theReportName = "";
          selectedFlag!
              ? (widget.stateOfTheReport = widget.theReportName.isEmpty
                  ? "Finished without report"
                  : "Finished with report")
              : "Not Started";
          try {
            FirebaseStorageFile().deleteFileFromStorage(widget.reportUrl);
          } catch (e) {}
        });
      },
    );
  }

// ignore: todo
//TODO make it more readable

  onPickerFile(bool isWebSelected) async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (pickedFile != null) {
      setState(() {
        isReportUploaded = false;
        widget.theReportName = pickedFile.files.single.name;
        selectedFlag!
            ? (widget.stateOfTheReport = widget.theReportName.isEmpty
                ? "Finished without report"
                : "Finished with report")
            : "Not Started";
      });
      try {
        FirebaseStorageFile().deleteFileFromStorage(widget.reportUrl);
      } catch (e) {}
      Reference reference =
          FirebaseStorage.instance.ref().child("${const Uuid().v1()}.pdf");
      final UploadTask uploadTask = isWebSelected
          ? reference.putData(pickedFile.files.single.bytes!)
          : reference.putFile(File(pickedFile.files.single.path!));

      await uploadTask.then((taskSnapshot) =>
          taskSnapshot.ref.getDownloadURL().then((String value) {
            widget.reportUrl = value;
            setState(() {
              isReportUploaded = true;
            });
          }));
    }
  }

  void pickImageForWeb() async {
    FilePickerResult result;
    result = (await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']))!;
    if (result != null) {
      try {
        FirebaseStorageFile().deleteFileFromStorage(widget.imageUrl);
      } catch (e) {}
      setState(() {
        isImageUploaded = false;
      });
      Uint8List uploadFile = result.files.single.bytes!;
      uploadImageToFirebase(uploadFile);
    }
  }

  Future pickImageForMobile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        FirebaseStorageFile().deleteFileFromStorage(widget.imageUrl);
      } catch (e) {}
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      uploadImageToFirebase(_imageFile!);
    }
  }

  Future uploadImageToFirebase(dynamic file) async {
    if (file != null) {
      setState(() {
        isImageUploaded = false;
      });
      Reference reference =
          FirebaseStorage.instance.ref().child("${const Uuid().v1()}.png");
      final UploadTask uploadTask = file == _imageFile
          ? reference.putFile(_imageFile!)
          : reference.putData(file);

      await uploadTask.then((taskSnapshot) =>
          taskSnapshot.ref.getDownloadURL().then((String value) {
            widget.imageUrl = value;
            setState(() {
              isImageUploaded = true;
            });
          }));
    }
  }

  CircleAvatar circleAvatarOfCamera() {
    return const CircleAvatar(
      backgroundColor: Colors.blueAccent,
      child: Icon(Icons.edit, color: Colors.white),
      radius: 20,
    );
  }

  Column columnOfPickDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textOfBirthdate(),
        containerOfDate(),
      ],
    );
  }

  InkWell containerOfDate() {
    return InkWell(
      onTap: () => pickDate(context),
      child: containerBody(),
    );
  }

  Container containerBody() {
    return Container(
        width: double.infinity,
        height: 60,
        decoration: boxDecoration(),
        child: rowOfDate());
  }

  Row rowOfDate() {
    return Row(
      children: [getTextOfDate()],
    );
  }

  Expanded getTextOfDate() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(getBirthdate(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            textAlign: TextAlign.start),
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(6));
  }

  Padding textOfBirthdate() {
    return const Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text("Birthdate"),
    );
  }

  String getBirthdate() {
    if (date == null) {
      return widget.birthdate;
    } else {
      return DateFormat('MM/dd/yyyy').format(date!);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime(DateTime.now().year - 5);
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 150),
      lastDate: DateTime(DateTime.now().year - 5),
    );
    if (newDate == null) return;
    setState(() => date = newDate);
  }

  ElevatedButton membershipsButton() {
    return ElevatedButton(
        onPressed: () => pushToMembershipsPage(), child: membershipsText());
  }

  Text membershipsText() {
    return const Text(
      "Memberships",
      style: TextStyle(fontSize: 20, color: Colors.white),
    );
  }

  pushToMembershipsPage() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getReadyForMemberships();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MembershipsOfStudent(widget.studentDocId)));
    });
  }

  getReadyForMemberships() {
    SeasonsProvider provider = context.read<SeasonsProvider>();
    provider.stateOfFetchingMemberships = StateOfMemberships.initial;
    provider.clearMembershipsList();
    provider.clearStudentMembershipsList();
    provider.clearMembershipsIds();
  }

  Column emptyMessage() {
    return Column(
      children: const [
        Text("save the student first"),
        Text("and then you can select memberships !")
      ],
    );
  }

  TextFormField textFormField(TextEditingController controller, String text) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: text,
          errorText: userNameValidate ? "invalid $text" : null),
    );
  }
}
