import 'package:date_time_picker/date_time_picker.dart';
import 'package:final_project/screens/resultSearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:toast/toast.dart';
import 'package:filter_list/filter_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int currentStep = 0;
  bool canCancel = true;
  bool canContinue = true;
  bool checked1 = true;
  bool checked2 = false;
  bool checked3 = false;
  bool pickupEmpty = true;
  bool destinationEmpty = true;

  TextEditingController seatNumController = new TextEditingController();
  String pickup = 'Pickup station';
  String destination = 'Destination station';

  DateTime selectedDate = DateTime(DateTime.now().year,DateTime.now().month,(DateTime.now().day + 1), );
  String dateSelectedString = 'Travel Date';


  List<String> countList = [
    "Egypt",
    "Giza",
    "Aswan",
    "Asyut",
    "Luxor",
    "El-Menia",
    "Alex",
    "Beni Suef",
    "Sohag",
    "Qena"
  ];
  List<String>? selectedCountListPickUp = [];
  String timeSearch = 'Any Time';

  List<String>? selectedCountListDestination = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.01),

        body: CupertinoStepper(
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepTapped: (step) => setState(() => currentStep = step),
          onStepCancel: canCancel
              ? () {
                  print(currentStep);
                  if (currentStep == 0) {
                    Toast.show(
                        'sorry,\nyou can`t cancel the first step', context,
                        backgroundColor: Colors.red,
                        gravity: Toast.CENTER,
                        backgroundRadius: 8.0);
                  } else {
                    setState(() {
                      --currentStep;
                    });
                  }
                }
              : null,
          onStepContinue: canContinue
              ? () {
                  print(currentStep);
                  if (currentStep == 2) {

                    print('Data:::::::$pickup,,$destination,,$timeSearch,,$dateSelectedString,,${seatNumController.text}');
                   if(pickup == 'Pickup station' || destination == 'Destination station' ){
                      setState(() {
                        currentStep = 0;
                      });
                      Toast.show('Please, select pickup station and destination station', context,
                          backgroundColor: Colors.red,
                          gravity: Toast.CENTER,
                          backgroundRadius: 6.0);
                    }
                    else if(dateSelectedString == 'Travel Date'){
                      setState(() {
                        currentStep = 2;
                      });
                      Toast.show('Please, select Travel Date ', context,
                          backgroundColor: Colors.red,
                          gravity: Toast.CENTER,
                          backgroundRadius: 6.0);
                    }
                    else {
                     Toast.show('Searching...', context,
                         backgroundColor: Colors.green,
                         gravity: Toast.CENTER,
                         backgroundRadius: 8.0);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultSearchScreen(pickup,destination,'')));

                   }
                  } else {
                    setState(() {
                      ++currentStep;
                    });
                  }
                }
              : null,
          steps: [
            _buildStep(
              title: Text('Step 1'),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).accentColor.withOpacity(0.2),
                        ),
                        width: size.width * 0.1,
                        height: size.height * 0.12,
                        child: Icon(Ionicons.train_outline)),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: size.width * 0.55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    openFilterDialog('Pickup station');
                                  },
                                  child: Text(pickup,
                                      style: GoogleFonts.elMessiri(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                    height: size.height * 0.03,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                      thickness: 1.3,
                                    )),
                                GestureDetector(
                                  onTap: (){
                                    openFilterDialog('Destination station');
                                  },
                                  child: Text(
                                    destination,
                                    style: GoogleFonts.elMessiri(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              if(!pickupEmpty && !destinationEmpty){
                                setState(() {
                                  String varible ='';
                                  varible = destination;
                                  destination = pickup;
                                  pickup = varible;
                                });
                              }

                            },
                            child: Container(
                              color: Colors.white,
                              child: Image.asset(
                                'assets/images/exchange.png',
                                color: Colors.grey[700],
                                width: 30,
                                height: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              isActive: 1 == currentStep,
              state: 1 == currentStep
                  ? StepState.editing
                  : 1 < currentStep
                      ? StepState.complete
                      : StepState.indexed,
            ),
            _buildStep(
              title: Text('Step 2'),
              content: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: checked1
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            checked1 = true;
                            timeSearch  = 'Any Time'
                            ;
                            if (checked1) {
                              checked2 = false;
                              checked3 = false;
                            }
                          });
                        },
                        child: Center(
                          child: Text(' Any Time ',
                              style: GoogleFonts.elMessiri(
                                  color: checked1 ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: checked2
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            checked2 = true;
                            timeSearch  = 'Morning';
                            if (checked2) {
                              checked1 = false;
                              checked3 = false;
                            }
                          });
                        },
                        child: Center(
                          child: Text(' Morning ',
                              style: GoogleFonts.elMessiri(
                                  color: checked2 ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: checked3
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            checked3 = true;
                            timeSearch = 'Night';
                            if (checked3) {
                              checked2 = false;
                              checked1 = false;
                            }
                          });
                        },
                        child: Center(
                          child: Text(' Night  ',
                              style: GoogleFonts.elMessiri(
                                  color: checked3 ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isActive: 2 == currentStep,
              state: 2 == currentStep
                  ? StepState.editing
                  : 2 < currentStep
                      ? StepState.complete
                      : StepState.indexed,
            ),
            _buildStep(
              title: Text('Step 3'),
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: GestureDetector(
                  onTap: (){
                    _selectDate(context);
                     },
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).accentColor.withOpacity(0.2),
                          ),
                          width: size.width * 0.1,
                          height: size.height * 0.06,
                          child: Icon(Ionicons.calendar_outline)),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        width: size.width * 0.5,
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Text(dateSelectedString,
                                style: GoogleFonts.elMessiri(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              isActive: 3 == currentStep,
              state: 3 == currentStep
                  ? StepState.editing
                  : 3 < currentStep
                      ? StepState.complete
                      : StepState.indexed,
            ),
            // _buildStep(
            //     isActive: 4 == currentStep,
            //     title: Text('setp 4'),
            //     state: 4 == currentStep
            //         ? StepState.editing
            //         : 4 < currentStep
            //             ? StepState.complete
            //             : StepState.indexed,
            //     content: Container(
            //       child: Row(
            //         children: [
            //           Text('Seat Numbers:',
            //               style: GoogleFonts.elMessiri(
            //                   fontSize: 18, fontWeight: FontWeight.bold)),
            //           Container(
            //             width: 50,
            //             child: Card(
            //                 child: Container(
            //               margin: EdgeInsets.only(left: 10),
            //               child: TextField(
            //                 controller: seatNumController,
            //                 keyboardType: TextInputType.number,
            //                 style: TextStyle(fontSize: 22),
            //                 decoration:
            //                     InputDecoration(border: InputBorder.none),
            //               ),
            //             )),
            //           )
            //         ],
            //       ),
            //     ))
          ],
        ));
  }

  Step _buildStep({
    required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
    required Widget content,
  }) {
    return Step(
      title: title,
      subtitle: Text('Subtitle'),
      state: state,
      isActive: isActive,
      content: content,
    );
  }

  void openFilterDialog(String title) async {
    await FilterListDialog.display<String>(
        context,
        listData: countList,
        selectedListData:title == 'Destination station'?selectedCountListDestination:selectedCountListPickUp,
        height: 480,
        headlineText: "Select $title",
        searchFieldHintText: "Search Here",
        choiceChipLabel: (item) {
          return item;
        },
        validateSelectedItem: (list, val) {
          return list!.contains(val);
        },
        onItemSearch: (list, text) {
          if (list!.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) =>
                element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
          else{
            return [];
          }
        },
        onApplyButtonClick: (list) {
          if (list != null && list.length == 1) {
            setState(() {

              if(title == 'Destination station'){
                selectedCountListDestination = List.from(list);
                destination = selectedCountListDestination![0].toString();
                setState(() {
                  destinationEmpty = false;
                });
              }else{
                selectedCountListPickUp = List.from(list);
                pickup = selectedCountListPickUp![0].toString();
                setState(() {
                  pickupEmpty = false;
                });
              }
            });
            Navigator.pop(context);

          }else{
            if(list!=null && list.length < 1){
              Toast.show('Please select Pickup station', context);
            }else{
              Toast.show('Please select only one Pickup station', context);
            }
          }


        });
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year,DateTime.now().month,(DateTime.now().day + 1), ),
        lastDate: DateTime(DateTime.now().year,DateTime.now().month,(DateTime.now().day + 15), ),))!;
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        dateSelectedString = DateFormat('yyyy-MM-dd').format(picked);
      });
  }
}
