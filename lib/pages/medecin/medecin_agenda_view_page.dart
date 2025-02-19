import 'package:flutter/cupertino.dart';
import 'package:sos_docteur/models/medecins/medecin_profil.dart';
import 'package:sos_docteur/widgets/user_session_widget.dart';

import '../../index.dart';
import 'medecin_agenda_config.dart';

class MedecinAgendaPageView extends StatefulWidget {
  MedecinAgendaPageView({Key key}) : super(key: key);

  @override
  _MedecinAgendaPageViewState createState() => _MedecinAgendaPageViewState();
}

class _MedecinAgendaPageViewState extends State<MedecinAgendaPageView> {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("medecin_id").toString(),
      scaffold: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/shapes/bg3p.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[900].withOpacity(.9),
                  Colors.white.withOpacity(.8),
                  Colors.white.withOpacity(.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
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
                              "Mon agenda",
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
                    child: Obx(() {
                      return Container(
                        child: medecinController
                                .medecinProfil.value.datas.profilAgenda.isEmpty
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20.0),
                                  height: 70.0,
                                  width: MediaQuery.of(context).size.width,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    color: Colors.blue[800],
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          alignment: Alignment.topCenter,
                                          curve: Curves.easeIn,
                                          child: MedecinAgendaConfigPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Configurer votre agenda",
                                      style:
                                          GoogleFonts.lato(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: medecinController.medecinProfil.value
                                    .datas.profilAgenda.length,
                                itemBuilder: (context, index) {
                                  var data = medecinController.medecinProfil
                                      .value.datas.profilAgenda[index];
                                  return AgendaCard(
                                    heures: data.heures,
                                    date: data.date,
                                    onRemoved: () async {
                                      XDialog.show(
                                        context: context,
                                        icon: Icons.help_rounded,
                                        content:
                                            "Etes-vous sûr de vouloir supprimer définitivement votre ce rendez-vous ?",
                                        title: "Suppression rdv!",
                                        onValidate: () async {
                                          Get.back();
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      );
                    }),
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

class AgendaCard extends StatelessWidget {
  final String date;
  final List<DispoHeures> heures;
  final Function onRemoved;
  const AgendaCard({
    Key key,
    this.date,
    @required this.heures,
    this.onRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          height: 110.0,
          margin: const EdgeInsets.only(bottom: 15.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: const DecorationImage(
              image: AssetImage("assets/images/shapes/bg2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(.8),
                  Colors.white.withOpacity(.8),
                ],
              ),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 12.0,
                  color: Colors.black26,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Lottie.asset(
                    "assets/lotties/5066-meeting-and-stuff.json",
                    height: 80.0,
                    width: 80.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date : ",
                            style: GoogleFonts.lato(
                              color: Colors.blue[800],
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "${strDateLongFr(date)} ",
                            style: GoogleFonts.lato(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: heures.length,
                                itemBuilder: (context, i) {
                                  return TimeCard(
                                    start: heures[i].heureDebut,
                                    end: heures[i].heureFin,
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: -5,
          child: GestureDetector(
            onTap: onRemoved,
            child: Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red[200],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.4),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3))
                  ]),
              child: Center(
                child: Icon(
                  CupertinoIcons.minus,
                  color: Colors.red[800],
                  size: 18.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TimeCard extends StatelessWidget {
  final String start, end;
  const TimeCard({
    Key key,
    this.start,
    this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      margin: const EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.3),
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.time_solid,
                color: Colors.amber[900],
                size: 16.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                start,
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
              )
            ],
          ),
          const SizedBox(
            width: 8.0,
          ),
          Container(width: 10.0, height: 2, color: Colors.white),
          const SizedBox(
            width: 8.0,
          ),
          Row(
            children: [
              Icon(
                CupertinoIcons.time_solid,
                color: Colors.amber[800],
                size: 16.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                end,
                style: GoogleFonts.lato(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
