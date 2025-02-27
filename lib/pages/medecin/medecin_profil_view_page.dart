import 'dart:convert';
import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_docteur/constants/globals.dart';
import 'package:sos_docteur/models/medecins/medecin_profil.dart';

import 'package:sos_docteur/widgets/user_session_widget.dart';

import '../../index.dart';

class MedecinProfilViewPage extends StatefulWidget {
  const MedecinProfilViewPage({Key key}) : super(key: key);

  @override
  _MedecinProfilViewPageState createState() => _MedecinProfilViewPageState();
}

class _MedecinProfilViewPageState extends State<MedecinProfilViewPage>
    with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  String avatar = "";

  final TextEditingController textNom = TextEditingController();
  final TextEditingController textEmail = TextEditingController();
  final TextEditingController textTelephone = TextEditingController();
  final TextEditingController textNumOrder = TextEditingController();

  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 4);
    initData();
  }

  Future<void> initData() async {
    setState(() {
      avatar = medecinController.medecinProfil.value.datas.photo;
      textNumOrder.text =
          medecinController.medecinProfil.value.datas.numOrdre.isNotEmpty
              ? medecinController.medecinProfil.value.datas.numOrdre
              : "";
      textNom.text = medecinController.medecinProfil.value.datas.nom;
      textTelephone.text =
          medecinController.medecinProfil.value.datas.telephone;
      textEmail.text = medecinController.medecinProfil.value.datas.email;
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
                    child: Container(child: Obx(() {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tabHeader(),
                          tabBody(),
                        ],
                      );
                    })),
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

  //Editing controller

  Widget _profilPhoto(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(children: [
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
                          color: Colors.blue,
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
              EditableField(
                title: "Nom",
                onEdit: () async {
                  if (textNom.text !=
                      medecinController.medecinProfil.value.datas.nom) {
                    await updateProfile(context,
                        key: "nom", value: textNom.text);
                  }
                },
                controller: textNom,
              ),
              const SizedBox(height: 10.0),
              EditableField(
                controller: textNumOrder,
                title: "Numéro d'ordre",
                onEdit: () async {
                  if (textNumOrder.text !=
                      medecinController.medecinProfil.value.datas.numOrdre) {
                    await updateProfile(context,
                        key: "numero_ordre", value: textNumOrder.text);
                  }
                },
              ),
              const SizedBox(height: 10.0),
              EditableField(
                title: "Email",
                controller: textEmail,
                onEdit: () async {
                  if (textEmail.text !=
                      medecinController.medecinProfil.value.datas.email) {
                    await updateProfile(context,
                        key: "email", value: textEmail.text);
                  }
                },
              ),
              const SizedBox(height: 10.0),
              EditableField(
                title: "Téléphone",
                controller: textTelephone,
                onEdit: () async {
                  if (textTelephone.text !=
                      medecinController.medecinProfil.value.datas.telephone) {
                    await updateProfile(context,
                        key: "telephone", value: textTelephone.text);
                  }
                },
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        if ((medecinController.medecinProfil.value.datas.profilLangues !=
                null) &&
            (medecinController
                .medecinProfil.value.datas.profilLangues.isNotEmpty)) ...[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Langues parlées",
                    style: GoogleFonts.lato(
                        fontSize: 18.0, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
          for (int i = 0;
              i <
                  medecinController
                      .medecinProfil.value.datas.profilLangues.length;
              i++) ...[
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
                    child: Text(
                      medecinController
                          .medecinProfil.value.datas.profilLangues[i].langue,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      XDialog.show(
                          content:
                              "Etes-vous sûr de vouloir supprimer cette langue de votre profile ?",
                          context: context,
                          icon: Icons.help,
                          title: "Suppression !",
                          onValidate: () async {
                            Xloading.showLottieLoading(context);
                            await MedecinApi.deleteProfile(
                                    key: "medecin_langue_id",
                                    value: medecinController.medecinProfil.value
                                        .datas.profilLangues[i].langueId,
                                    subUrl: "langues")
                                .then((res) async {
                              Xloading.dismiss();
                              if (res != null) {
                                print(res);
                                XDialog.showSuccessAnimation(context);
                                await medecinController.refreshProfil();
                              }
                            });
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
                          CupertinoIcons.delete,
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
      ]),
    );
  }

  Widget _profilSpecialites(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        children: [
          for (int i = 0;
              i <
                  medecinController
                      .medecinProfil.value.datas.profilSpecialites.length;
              i++) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(30.0),
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
                  Row(
                    children: [
                      Text(
                        medecinController.medecinProfil.value.datas
                            .profilSpecialites[i].specialite,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      XDialog.show(
                          content:
                              "Etes-vous sûr de vouloir supprimer cette spécialité de votre profile ?",
                          context: context,
                          icon: Icons.help,
                          title: "Suppression !",
                          onValidate: () async {
                            Xloading.showLottieLoading(context);
                            await MedecinApi.deleteProfile(
                                    key: "medecin_specialite_id",
                                    value: medecinController
                                        .medecinProfil
                                        .value
                                        .datas
                                        .profilSpecialites[i]
                                        .specialiteId,
                                    subUrl: "specialites")
                                .then((res) async {
                              print(medecinController.medecinProfil.value.datas
                                  .profilSpecialites[i].specialiteId);
                              Xloading.dismiss();
                              if (res != null) {
                                XDialog.showSuccessAnimation(context);
                                await medecinController.refreshProfil();
                              }
                            });
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
                          CupertinoIcons.delete,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _profilEtudes(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0;
              i <
                  medecinController
                      .medecinProfil.value.datas.profilEtudesFaites.length;
              i++) ...[
            StudyCard(
              data: medecinController
                  .medecinProfil.value.datas.profilEtudesFaites[i],
            ),
          ]
        ],
      ),
    );
  }

  Widget _profilExperience(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0;
              i <
                  medecinController
                      .medecinProfil.value.datas.profilExperiences.length;
              i++) ...[
            ExperiencesCard(
              data: medecinController
                  .medecinProfil.value.datas.profilExperiences[i],
            ),
          ]
        ],
      ),
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
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                "Mon profil",
                style: style1(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
        if (storage.read("isMedecin") == true) UserSession()
      ],
    );
  }

  Future<void> updateProfile(context, {String key, String value}) async {
    XDialog.show(
        content: "Etes-vous sûr de vouloir modifier cette donnée ?",
        context: context,
        icon: Icons.help,
        title: "Modification !",
        onValidate: () async {
          Xloading.showLottieLoading(context);
          await MedecinApi.updateProfile(
            key: key,
            value: value,
          ).then((res) async {
            Xloading.dismiss();
            if (res != null) {
              print(res);
              XDialog.showSuccessAnimation(context);
              await medecinController.refreshProfil();
              await initData();
            }
          });
        });
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
                          await medecinController.refreshDatas();
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
                          await medecinController.refreshDatas();
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
}

class EditableField extends StatefulWidget {
  final String title;
  final Function onEdit;
  final TextEditingController controller;
  const EditableField({
    Key key,
    this.title,
    this.onEdit,
    this.controller,
  }) : super(key: key);

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  bool hasEdited = false;
  FocusNode inputNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      decoration: BoxDecoration(
        color: Colors.white54,
        border: Border(bottom: BorderSide(color: primaryColor, width: .5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 10.0),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(widget.title),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: TextField(
                  controller: widget.controller,
                  focusNode: inputNode,
                  autofocus: hasEdited ? true : false,
                  readOnly: hasEdited ? false : true,
                  style: GoogleFonts.lato(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
                    hintText: "Saisir une valeur...",
                    hintStyle: GoogleFonts.lato(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
              if (!hasEdited) ...[
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(inputNode);
                    setState(() {
                      hasEdited = true;
                    });
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.pencil, color: Colors.white),
                    ),
                  ),
                )
              ] else ...[
                GestureDetector(
                  onTap: () {
                    widget.onEdit();
                    Future.delayed(const Duration(milliseconds: 500));
                    setState(() {
                      hasEdited = false;
                    });
                  },
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                )
              ]
            ],
          ),
        ],
      ),
    );
  }
}

class StudyCard extends StatelessWidget {
  final ProfilEtudesFaites data;
  const StudyCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 170.0,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/images/shapes/bg3.png"),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Colors.black.withOpacity(.1),
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(.7),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12.0,
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 25.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(.5),
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                "assets/icons/study.svg",
                                height: 20.0,
                                width: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Text(
                              "Institut / Université",
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "Université de Kinshasa",
                          style: GoogleFonts.lato(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 15.0, color: Colors.grey),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 25.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                color: Colors.cyan[900].withOpacity(.5),
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: SvgPicture.asset(
                                "assets/icons/study.svg",
                                height: 20.0,
                                width: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Text("Etude"),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Doctorat en Pédiatrie",
                          style: GoogleFonts.lato(
                            color: Colors.cyan[800],
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "De 12/02/2015 à 11/04/2022",
                      style: GoogleFonts.lato(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          right: 10.0,
          child: GestureDetector(
            onTap: () {
              XDialog.show(
                  content:
                      "Etes-vous sûr de vouloir supprimer votre étude faite  du profile ?",
                  context: context,
                  icon: Icons.help,
                  title: "Suppression !",
                  onValidate: () async {
                    Xloading.showLottieLoading(context);
                    await MedecinApi.deleteProfile(
                            key: "medecin_etudes_faite_id",
                            value: data.medecinEtudesFaiteId,
                            subUrl: "etudesfaites")
                        .then((res) async {
                      Xloading.dismiss();
                      if (res != null) {
                        print(res);
                        XDialog.showSuccessAnimation(context);
                        await medecinController.refreshProfil();
                      }
                    });
                  });
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 10.0),
                  )
                ],
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.delete,
                  color: Colors.white,
                  size: 15.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ExperiencesCard extends StatelessWidget {
  final ProfilExperiences data;
  const ExperiencesCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/images/shapes/bg3.png"),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Colors.black.withOpacity(.1),
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(.7),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12.0,
                  color: Colors.black.withOpacity(.1),
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 25.0,
                          width: 25.0,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(.5),
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset(
                            "assets/icons/medical-svgrepo-com.svg",
                            height: 20.0,
                            width: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "A Travailler chez ${data.entite}",
                          style: GoogleFonts.lato(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 15.0, color: Colors.grey),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 25.0,
                              width: 25.0,
                              decoration: BoxDecoration(
                                color: Colors.cyan[900].withOpacity(.5),
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: const Icon(CupertinoIcons.flag,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Text("Pays"),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          data.pays,
                          style: GoogleFonts.lato(
                            color: Colors.cyan[800],
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      "De ${data.periodeDebut} à ${data.periodeFin}",
                      style: GoogleFonts.lato(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          right: 10.0,
          child: GestureDetector(
            onTap: () {
              XDialog.show(
                  content:
                      "Etes-vous sûr de vouloir supprimer votre étude faite  du profile ?",
                  context: context,
                  icon: Icons.help,
                  title: "Suppression!",
                  onValidate: () async {
                    Xloading.showLottieLoading(context);
                    await MedecinApi.deleteProfile(
                            key: "medecin_experience_id",
                            value: data.medecinExperienceId,
                            subUrl: "experiences")
                        .then((res) async {
                      Xloading.dismiss();
                      if (res != null) {
                        print(res);
                        XDialog.showSuccessAnimation(context);
                        await medecinController.refreshProfil();
                      }
                    });
                  });
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 10.0),
                  )
                ],
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.delete,
                  color: Colors.white,
                  size: 15.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SpecCard extends StatelessWidget {
  final String value;
  const SpecCard({
    Key key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 12.0,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Positioned(
          top: -4,
          left: -4,
          child: Container(
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
              color: Colors.green[700],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 12.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TitleLine extends StatelessWidget {
  final String title;
  const TitleLine({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue[900],
                ],
              ),
            ),
            child: Center(
              child: Text(title, style: GoogleFonts.lato(color: Colors.white)),
            ),
          ),
          Flexible(
            child: Container(
                height: 2.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                ),
                width: MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }
}
