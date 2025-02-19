import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:sos_docteur/video_calls/models/call_model.dart';
import 'package:sos_docteur/video_calls/pages/call_screen.dart';
import 'package:sos_docteur/video_calls/permissions.dart';
import 'package:sos_docteur/video_calls/resources/call_methods.dart';
import 'package:sos_docteur/widgets/med_shedule_card.dart';
import 'package:sos_docteur/widgets/user_session_widget.dart';
import 'dart:math' as math;

import '../../index.dart';

class MedecinScheddulePage extends StatefulWidget {
  MedecinScheddulePage({Key key}) : super(key: key);

  @override
  _MedecinScheddulePageState createState() => _MedecinScheddulePageState();
}

class _MedecinScheddulePageState extends State<MedecinScheddulePage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("medecin_id").toString(),
      scaffold: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("assets/images/vector/undraw_medicine_b1ol.png"),
                fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[900],
                  Colors.white.withOpacity(.9),
                  Colors.white.withOpacity(.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Obx(() {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40.0,
                                  width: 40.0,
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
                                width: 8.0,
                              ),
                              Text(
                                "Mes rendez-vous",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (storage.read("isMedecin") == true) UserSession()
                        ],
                      ),
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
                );
              }),
            ),
          ),
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
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: _listSchedule(context),
            ),
            Center(
              child: Text("Pas prêt !"),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabHeader() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(30.0)),
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BubbleTabIndicator(
          indicatorHeight: 47.0,
          indicatorColor: primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.label,
          indicatorRadius: 30,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: GoogleFonts.mulish(
          fontSize: 15,
          fontWeight: FontWeight.w700,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    const Text("En cours"),
                  ],
                ),
              ],
            ),
          ),
          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    const Text("Antérieures"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listSchedule(context) {
    return Scrollbar(
      radius: const Radius.circular(5),
      thickness: 5.0,
      child: ListView.builder(
        padding: const EdgeInsets.only(
            bottom: 60.0, right: 15.0, left: 15.0, top: 10.0),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: medecinController.medecinRdvs.length,
        itemBuilder: (context, index) {
          var data = medecinController.medecinRdvs[index];
          return MedScheduleCard(
            data: data,
            onCalling: () async {
              // update input validation
              await handleCameraAndMic(Permission.camera);
              await handleCameraAndMic(Permission.microphone);

              String uid = storage.read("medecin_id");
              String uName = storage.read('medecin_nom');
              String uPic = storage.read('photo');

              Call call = Call(
                callerId: uid,
                callerName: uName,
                callerPic: uPic,
                callerType: "medecin",
                receiverName: data.nom,
                receiverPic: "",
                receiverType: "medecin",
                receiverId: data.patientId,
                channelId:
                    '$uid${data.patientId}${math.Random().nextInt(1000).toString()}',
                consultId: data.consultationRdvId,
              );
              Xloading.showLottieLoading(context);
              await MedecinApi.consulting(
                consultRef:
                    '$uid${data.patientId}${math.Random().nextInt(1000).toString()}',
                consultId: data.consultationRdvId,
                key: "start",
              ).then((result) async {
                Xloading.dismiss();
                if (result != null) {
                  await CallMethods.makeCall(call: call);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallScreen(
                        role: ClientRole.Broadcaster,
                        call: call,
                        hasCaller: true,
                      ),
                    ),
                  );
                } else {
                  Get.snackbar(
                    "Echec de la vidéo conférence !",
                    "une erreur est survenu lors du traitement de l'opération, veuillez reéssayer ultérieurement !",
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.red[200],
                    backgroundColor: Colors.black87,
                    maxWidth: MediaQuery.of(context).size.width - 4,
                    borderRadius: 10,
                  );
                }
              });
            },
            onCancelled: () {},
          );
        },
      ),
    );
  }
}
