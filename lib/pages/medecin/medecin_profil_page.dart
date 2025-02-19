// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sos_docteur/constants/globals.dart';
import 'package:sos_docteur/models/configs_model.dart';
import 'package:sos_docteur/widgets/form_input_field.dart';

import '../../index.dart';

class MedecinProfilPage extends StatefulWidget {
  @override
  _MedecinProfilPageState createState() => _MedecinProfilPageState();
}

class _MedecinProfilPageState extends State<MedecinProfilPage>
    with SingleTickerProviderStateMixin {
  String medName = storage.read("medecin_nom").toString() ?? "";
  String medEmail = storage.read("medecin_email").toString() ?? "";
  String medPhoto = storage.read("photo").toString() ?? "";
  String avatar = "";

  String dateStart = "";
  DateTime selectedDateStart;
  String dateEnd = "";
  DateTime selectedDateEnd;
  String certificatPic = "";

  //text editing
  final textSpecialite = TextEditingController();
  final textEntite = TextEditingController();
  final textExperience = TextEditingController();
  final textPays = TextEditingController();
  final textVille = TextEditingController();
  final textAdresse = TextEditingController();
  final textEtude = TextEditingController();
  Specialites selectedSpeciality;
  String selectedLangue;

  //numero d'ordre
  final textNumOrdre = TextEditingController();

  void clean() {
    setState(() {
      textSpecialite.text = "";
      textEntite.text = "";
      textExperience.text = "";
      textPays.text = "";
      textVille.text = "";
      textAdresse.text = "";
      textEtude.text = "";
      certificatPic = "";
      dateStart = "";
      dateEnd = "";
    });
  }

  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 4);

    setState(() {
      avatar = medPhoto ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("medecin_id").toString(),
      scaffold: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/shapes/bg9.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(.5),
                  Colors.white10,
                  Colors.white10,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 20.0, bottom: 10),
                    child: _header(),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tabHeader(),
                          tabBody(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tabHeader() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/shapes/bg10.jpg"),
          fit: BoxFit.cover,
          scale: 1.5,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(.9),
        ),
        child: TabBar(
          controller: controller,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BubbleTabIndicator(
            indicatorHeight: 60.0,
            indicatorColor: Colors.cyan,
            tabBarIndicatorSize: TabBarIndicatorSize.label,
            indicatorRadius: 0,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: GoogleFonts.mulish(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelStyle: GoogleFonts.mulish(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          tabs: [
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/user-svgrepo-com.svg",
                    height: 20,
                    width: 20.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  const Text("Accueil"),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/vector/medical-specialist-svgrepo-com.svg",
                    height: 20,
                    width: 20.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  const Text("Spécialités"),
                ],
              ),
            ),
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/vector/university-svgrepo-com.svg",
                    height: 20,
                    width: 20.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  const Text("Etudes"),
                ],
              ),
            ),
            //
            Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/vector/professional-profile-with-image-svgrepo-com.svg",
                    height: 20,
                    width: 20.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  const Text("Expériences"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabBody() {
    return Expanded(
      child: Container(
        child: TabBarView(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          children: [
            _profilPhoto(context),
            _profilSpecialites(context),
            _profilEtudes(context),
            _profilExperience(context),
          ],
        ),
      ),
    );
  }

  Future<PickedFile> takePhoto({ImageSource source}) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: source,
    );

    if (pickedFile != null) {
      return pickedFile;
    } else {
      return null;
    }
  }

  void _showPhotoEditingSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      elevation: 2,
      barrierColor: Colors.black26,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 150.0,
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TileBtn(
                  icon: CupertinoIcons.photo_on_rectangle,
                  label: "Gallerie",
                  onPressed: () async {
                    var pickedFile =
                        await takePhoto(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      var bytes = File(pickedFile.path).readAsBytesSync();
                      setState(() {
                        avatar = base64Encode(bytes);
                      });
                      Medecins medecin = Medecins(photo: avatar);
                      Xloading.showLottieLoading(context);
                      var res = await MedecinApi.configProfil(
                          key: "avatar", medecin: medecin);
                      if (res != null) {
                        Xloading.dismiss();
                        if (res['reponse']['status'] == "success") {
                          storage.write("photo", avatar);
                          Get.back();

                          XDialog.showSuccessAnimation(context);
                          await medecinController.refreshProfil();
                        } else {
                          Get.snackbar(
                            "Echec!",
                            "mise à jour de la photo de profil à echouée!",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.amber[900],
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 2,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      }
                    }
                    //print(avatar);
                  },
                ),
              ),
              const SizedBox(width: 20.0),
              Flexible(
                child: TileBtn(
                  onPressed: () async {
                    var pickedFile =
                        await takePhoto(source: ImageSource.camera);
                    if (pickedFile != null) {
                      var bytes = File(pickedFile.path).readAsBytesSync();
                      setState(() {
                        avatar = base64Encode(bytes);
                      });

                      Medecins medecin = Medecins(photo: avatar);
                      Xloading.showLottieLoading(context);

                      var res = await MedecinApi.configProfil(
                          key: "avatar", medecin: medecin);

                      if (res != null) {
                        Xloading.dismiss();
                        if (res['reponse']['status'] == "success") {
                          storage.write("photo", avatar);
                          Get.back();

                          XDialog.showSuccessAnimation(context);
                          await medecinController.refreshProfil();
                        } else {
                          Get.snackbar(
                            "Echec!",
                            "mise à jour de la photo de profil à echouée!",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.amber[900],
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 2,
                            duration: const Duration(seconds: 3),
                          );
                          Get.back();
                        }
                      }
                    }
                  },
                  icon: CupertinoIcons.photo_camera,
                  label: "Prendre une photo",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
                child: Text(
              "Configuration & Personnalisation Profil",
              style: style1(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0),
            ))
          ],
        ),
      ],
    );
  }

  final _formNum = GlobalKey<FormState>();

  Widget _profilPhoto(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  // ignore: deprecated_member_use
                  overflow: Overflow.visible,
                  children: [
                    if (avatar.length > 200)
                      Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: MemoryImage(
                                base64Decode(avatar),
                              ),
                              fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 12.0,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                      )
                    else
                      Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.cyan,
                              primaryColor,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.3),
                              blurRadius: 12.0,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: -10,
                      right: 5.0,
                      child: GestureDetector(
                        onTap: () {
                          _showPhotoEditingSheet();
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber[800],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 12.0,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.pencil,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Dr. $medName",
                      style: style1(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.pencil, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: _formNum,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Langues parlées",
                      style: GoogleFonts.lato(
                          fontSize: 18.0, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white30,
                        border: Border.all(color: Colors.blue, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(.3),
                            blurRadius: 12.0,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: StatefulBuilder(
                              builder: (context, setter) {
                                return Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(right: 5),
                                  child: DropdownButton<String>(
                                    menuMaxHeight: 300,
                                    alignment: Alignment.centerRight,
                                    dropdownColor: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10.0),
                                    style:
                                        GoogleFonts.lato(color: Colors.black54),
                                    value: selectedLangue,
                                    underline: const SizedBox(),
                                    hint: Text(
                                      "   Sélectionnez une langue",
                                      style: GoogleFonts.mulish(
                                          color: Colors.grey[600],
                                          fontSize: 15.0,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    isExpanded: true,
                                    items: langues.map((e) {
                                      return DropdownMenuItem<String>(
                                          value: e,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              "$e",
                                              style: GoogleFonts.lato(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      setter(() {
                                        selectedLangue = value;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (selectedLangue == null ||
                                  selectedLangue == langues[0]) {
                                Get.snackbar(
                                  "champs obligatoire!",
                                  "vous devez sélectionner une langue dans la liste !",
                                  snackPosition: SnackPosition.TOP,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.amber[900],
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 4,
                                  borderRadius: 2,
                                  duration: const Duration(seconds: 3),
                                );
                                return;
                              }
                              Medecins medecin =
                                  Medecins(langue: selectedLangue);
                              Xloading.showLottieLoading(context);
                              var res = await MedecinApi.configProfil(
                                  key: "langue", medecin: medecin);
                              if (res != null) {
                                Xloading.dismiss();
                                if (res["reponse"]["status"] == "success") {
                                  XDialog.showSuccessAnimation(context);
                                  setState(() {
                                    selectedLangue = langues[0];
                                  });
                                  await medecinController.refreshProfil();
                                }
                              } else {
                                Xloading.dismiss();
                                Get.snackbar(
                                  "Echec!",
                                  "echec survenu lors de l'envoi de données au serveur!,\nveuillez réessayer svp!",
                                  snackPosition: SnackPosition.TOP,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.pinkAccent,
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 4,
                                  borderRadius: 10,
                                  duration: const Duration(seconds: 3),
                                );
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: const Center(
                                child: Icon(CupertinoIcons.add,
                                    color: Colors.white, size: 18.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CustomFormField(
                  hintText: "Entrez votre numéro d'ordre...",
                  errorMessage: "numéro d'ordre réquis !",
                  icon: CupertinoIcons.pencil,
                  title: "Numéro d'ordre",
                  controller: textNumOrdre,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  child: RaisedButton(
                    elevation: 10.0,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () async {
                      if (_formNum.currentState.validate()) {
                        Xloading.showLottieLoading(context);
                        var res = await MedecinApi.enregistrerNumOrdre(
                            numero: textNumOrdre.text);
                        if (res != null) {
                          Xloading.dismiss();
                          if (res["reponse"]["status"] == "success") {
                            XDialog.showSuccessAnimation(context);
                            await medecinController.refreshProfil();
                            Get.back();
                          }
                        } else {
                          Xloading.dismiss();
                          Get.snackbar(
                            "Echec !",
                            "un echec est survenu lors de l'envoi de données au serveur!,veuillez réessayer svp!",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.red[100],
                            backgroundColor: Colors.black87,
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 10,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      }
                    },
                    child: Text(
                      "Insérer",
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Specialites> specialitesList = [];
  Widget _profilSpecialites(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            enabled: true,
            baseColor: Colors.black,
            highlightColor: Colors.cyan,
            child: Text(
              "Veuillez personnaliser votre ou vos spécialités !",
              style: GoogleFonts.lato(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white54,
              border: Border.all(color: Colors.blue, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 20,
                    padding: const EdgeInsets.only(right: 5),
                    child: DropdownButton(
                      menuMaxHeight: 300,
                      alignment: Alignment.centerRight,
                      dropdownColor: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.0),
                      style: GoogleFonts.lato(color: Colors.black54),
                      value: selectedSpeciality,
                      underline: const SizedBox(),
                      hint: Text(
                        "  Sélectionnez une spécialité",
                        style: GoogleFonts.mulish(
                            color: Colors.grey[600],
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic),
                      ),
                      isExpanded: true,
                      items: patientController.specialities.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              e.specialite,
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSpeciality = value;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: selectedSpeciality != null
                          ? () {
                              if (selectedSpeciality != null) {
                                if (specialitesList.isEmpty) {
                                  setState(() {
                                    specialitesList.add(selectedSpeciality);
                                  });
                                } else {
                                  for (int i = 0;
                                      i < specialitesList.length;
                                      i++) {
                                    if (specialitesList[i].specialiteId ==
                                        selectedSpeciality.specialiteId) {
                                      Get.snackbar(
                                        "Erreur de doublons !",
                                        "vous devez pas entrer une spécialité deux fois !",
                                        snackPosition: SnackPosition.BOTTOM,
                                        colorText: Colors.red[100],
                                        backgroundColor: Colors.black87,
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                4,
                                        borderRadius: 8,
                                        duration: const Duration(seconds: 10),
                                      );
                                      return;
                                    }
                                  }
                                  setState(() {
                                    specialitesList.add(selectedSpeciality);
                                  });
                                }
                              }
                            }
                          : null,
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < specialitesList.length; i++) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 5),
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.3),
                              blurRadius: 12.0,
                              offset: const Offset(0, 10.0),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(specialitesList[i].specialite),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  specialitesList.removeWhere((item) =>
                                      item.specialiteId ==
                                      specialitesList[i].specialiteId);
                                });
                              },
                              child: Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    CupertinoIcons.clear,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10.0,
              color: Colors.green[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Insérer",
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                ],
              ),
              onPressed: () async {
                if (selectedSpeciality == null) {
                  Get.snackbar(
                    "champs obligatoire !",
                    "vous devez sélectionner une spécialité dans la liste !",
                    snackPosition: SnackPosition.TOP,
                    colorText: Colors.white,
                    backgroundColor: Colors.black87,
                    maxWidth: MediaQuery.of(context).size.width - 4,
                    borderRadius: 10,
                    duration: const Duration(seconds: 3),
                  );
                  return;
                }
                Xloading.showLottieLoading(context);
                for (int i = 0; i < specialitesList.length; i++) {
                  Medecins medecin = Medecins(
                    specialite: specialitesList[i].specialiteId,
                  );

                  await MedecinApi.configProfil(
                    key: "specialite",
                    medecin: medecin,
                  );
                }
                Xloading.dismiss();
                XDialog.showSuccessAnimation(context);
                setState(() {
                  specialitesList.clear();
                });
                await medecinController.refreshProfil();
              },
            ),
          )
        ],
      ),
    );
  }

  final _formEtudes = GlobalKey<FormState>();
  Widget _profilEtudes(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            enabled: true,
            baseColor: Colors.black,
            highlightColor: Colors.cyan,
            child: Text(
              "Veuillez personnaliser vos études faites !",
              style: GoogleFonts.lato(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Form(
            key: _formEtudes,
            child: Column(
              children: [
                CustomFormField(
                  hintText: "Entrez la formation sanitaire...",
                  errorMessage: "formation sanitaire requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Formation sanitaire",
                  controller: textEntite,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez étude...",
                  errorMessage: "étude requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Etude",
                  controller: textEtude,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: StatefulBuilder(builder: (context, setter) {
                        return DatePicker(
                          hintText: "Période début",
                          selectedDate: dateStart,
                          showDate: () async {
                            DateTime date = await showDateBox(context);
                            DateTime dateNow = DateTime.now();
                            if (date.isAfter(dateNow)) {
                              Get.snackbar(
                                "Erreur!",
                                "Date du début invalide !",
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.red[100],
                                backgroundColor: Colors.black87,
                                maxWidth: MediaQuery.of(context).size.width - 4,
                                borderRadius: 10,
                                duration: const Duration(seconds: 5),
                              );
                              return;
                            }

                            if (date != null) {
                              setter(() {
                                dateStart = dateFromString(date);
                                selectedDateStart = date;
                              });
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(child: StatefulBuilder(builder: (context, setter) {
                      return DatePicker(
                        hintText: "Période fin",
                        selectedDate: dateEnd,
                        showDate: () async {
                          DateTime date = await showDateBox(context);
                          DateTime dateNow = DateTime.now();

                          if (date.isAfter(dateNow)) {
                            Get.snackbar(
                              "Erreur!",
                              "Date de la fin !",
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: Colors.red[100],
                              backgroundColor: Colors.black87,
                              maxWidth: MediaQuery.of(context).size.width - 4,
                              borderRadius: 10,
                              duration: const Duration(seconds: 5),
                            );
                            return;
                          }

                          if (date != null) {
                            setter(() {
                              dateEnd = dateFromString(date);
                              selectedDateEnd = date;
                            });
                          }
                        },
                      );
                    }))
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                StatefulBuilder(
                  builder: (context, setter) => FileUploader(
                    onCanceled: () {
                      setter(() {
                        certificatPic = "";
                      });
                    },
                    onUpload: () async {
                      var pic = await takePhoto(source: ImageSource.gallery);
                      if (pic != null) {
                        var bytes = File(pic.path).readAsBytesSync();
                        setter(() {
                          certificatPic = base64Encode(bytes);
                        });
                      }
                    },
                    uploadFile: certificatPic,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez le pays d'étude, ex. RD Congo...",
                  errorMessage: "pays d'étude requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Pays",
                  controller: textPays,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez la ville d'étude...",
                  errorMessage: "ville d'étude requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Ville",
                  controller: textVille,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez l'adresse d'étude...",
                  errorMessage: "adresse d'étude requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Adresse",
                  controller: textAdresse,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Personnaliser",
                          style: GoogleFonts.lato(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (_formEtudes.currentState.validate()) {
                        if (dateStart.isEmpty && dateEnd.isEmpty) {
                          Get.snackbar(
                            "Action obligatoire!",
                            "vous devez renseigner la date du début et la date de la fin de vos études !",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.red[100],
                            backgroundColor: Colors.black87,
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 10,
                            duration: const Duration(seconds: 5),
                          );
                          return;
                        }
                        if (certificatPic.isEmpty) {
                          Get.snackbar(
                            "Action obligatoire!",
                            "votre certificat ou diplôme en image est requis !",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.red[100],
                            backgroundColor: Colors.black87,
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 10,
                            duration: const Duration(seconds: 5),
                          );
                          return;
                        }
                        if (selectedDateEnd.isBefore(selectedDateStart)) {
                          Get.snackbar(
                            "Action obligatoire!",
                            "La date du début doit obligatoirement être supérieure à la date de la fin des études !",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.red[100],
                            backgroundColor: Colors.black87,
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 10,
                            duration: const Duration(seconds: 5),
                          );
                          return;
                        }
                        final medecin = Medecins(
                          institut: textEntite.text,
                          certificat: certificatPic,
                          etude: textEtude.text,
                          periodeDebut: dateStart,
                          periodeFin: dateEnd,
                          pays: textPays.text,
                          ville: textVille.text,
                          adresse: textAdresse.text,
                        );
                        Xloading.showLottieLoading(context);
                        var res = await MedecinApi.configProfil(
                            key: "etude", medecin: medecin);
                        if (res != null) {
                          Xloading.dismiss();
                          if (res["reponse"]["status"] != null) {
                            XDialog.showSuccessAnimation(context);
                            setState(() {
                              certificatPic = "";
                              dateStart = "";
                              selectedDateStart = null;
                              dateEnd = "";
                              selectedDateEnd = null;
                            });
                            clean();
                            await medecinController.refreshProfil();
                          }
                        } else {
                          Xloading.dismiss();
                          Get.snackbar(
                            "Echec!",
                            "Un echec est survenu lors de l'envoi de données au serveur!,\nveuillez réessayer svp!",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.amber[900],
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 2,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  final _formExperiences = GlobalKey<FormState>();
  Widget _profilExperience(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            enabled: true,
            baseColor: Colors.black,
            highlightColor: Colors.cyan,
            child: Text(
              "Veuillez personnaliser votre ou vos expériences professionnelles !",
              style: GoogleFonts.lato(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Form(
            key: _formExperiences,
            child: Column(
              children: [
                CustomFormField(
                  hintText: "Entrez le nom de la formation sanitaire...",
                  errorMessage: "le nom de la formation sanitaire requis!",
                  icon: CupertinoIcons.pencil,
                  title: "Formation sanitaire",
                  controller: textEntite,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez le poste...",
                  errorMessage: "poste requis !",
                  icon: CupertinoIcons.pencil,
                  title: "Poste",
                  controller: textExperience,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: StatefulBuilder(builder: (context, setter) {
                        return DatePicker(
                          hintText: "De...",
                          selectedDate: dateStart,
                          showDate: () async {
                            DateTime date = await showDateBox(context);
                            DateTime dateNow = DateTime.now();
                            if (date.isAfter(dateNow)) {
                              Get.snackbar(
                                "Erreur!",
                                "Date du début invalide !",
                                snackPosition: SnackPosition.BOTTOM,
                                colorText: Colors.red[100],
                                backgroundColor: Colors.black87,
                                maxWidth: MediaQuery.of(context).size.width - 4,
                                borderRadius: 10,
                                duration: const Duration(seconds: 5),
                              );
                              return;
                            }
                            if (date != null) {
                              setter(() {
                                dateStart = dateFromString(date);
                                selectedDateStart = date;
                              });
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(child: StatefulBuilder(builder: (context, setter) {
                      return DatePicker(
                        hintText: "A",
                        selectedDate: dateEnd,
                        showDate: () async {
                          DateTime date = await showDateBox(context);
                          DateTime dateNow = DateTime.now();

                          if (date.isAfter(dateNow)) {
                            Get.snackbar(
                              "Erreur!",
                              "Date de la fin !",
                              snackPosition: SnackPosition.BOTTOM,
                              colorText: Colors.red[100],
                              backgroundColor: Colors.black87,
                              maxWidth: MediaQuery.of(context).size.width - 4,
                              borderRadius: 10,
                              duration: const Duration(seconds: 5),
                            );
                            return;
                          }

                          if (date != null) {
                            setter(() {
                              dateEnd = dateFromString(date);
                              selectedDateEnd = date;
                            });
                          }
                        },
                      );
                    }))
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez le pays d'étude, ex. RD Congo...",
                  errorMessage: "pays d'étude requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Pays",
                  controller: textPays,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez la ville d'étude...",
                  errorMessage: "ville d'étude requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Ville",
                  controller: textVille,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomFormField(
                  hintText: "Entrez l'adresse d'étude...",
                  errorMessage: "adresse d'étude requise !",
                  icon: CupertinoIcons.pencil,
                  title: "Adresse",
                  controller: textAdresse,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10.0,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Personnaliser",
                          style: GoogleFonts.lato(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (_formExperiences.currentState.validate()) {
                        if (dateStart.isEmpty && dateEnd.isEmpty) {
                          Get.snackbar(
                            "Action obligatoire!",
                            "vous devez renseigner la date du début et la date de la fin de vos études !",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.red[100],
                            backgroundColor: Colors.black87,
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 10,
                            duration: const Duration(seconds: 5),
                          );
                          return;
                        }

                        if (selectedDateEnd.isBefore(selectedDateStart)) {
                          Get.snackbar(
                            "Action obligatoire!",
                            "La date du début doit obligatoirement être supérieure à la date de la fin des études !",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.red[100],
                            backgroundColor: Colors.black87,
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 10,
                            duration: const Duration(seconds: 5),
                          );
                          return;
                        }

                        final medecin = Medecins(
                          entite: textEntite.text,
                          experience: textExperience.text,
                          periodeDebut: dateStart,
                          periodeFin: dateEnd,
                          pays: textPays.text,
                          ville: textVille.text,
                          adresse: textAdresse.text,
                        );
                        Xloading.showLottieLoading(context);
                        var res = await MedecinApi.configProfil(
                            key: "experience", medecin: medecin);

                        if (res != null) {
                          Xloading.dismiss();
                          if (res["reponse"]["status"] == "success") {
                            XDialog.showSuccessAnimation(context);
                            await medecinController.refreshProfil();
                            clean();
                          }
                        } else {
                          Xloading.dismiss();
                          Get.snackbar(
                            "Echec!",
                            "echec survenu lors de l'envoi de données au serveur!,\nveuillez réessayer svp!",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.amber[900],
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 20,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LargeBtn extends StatelessWidget {
  final Function onPressed;
  const LargeBtn({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/shapes/bg10.jpg"),
          fit: BoxFit.cover,
          scale: 1.5,
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[700].withOpacity(.8),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Enregistrer votre numéro d'ordre",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
