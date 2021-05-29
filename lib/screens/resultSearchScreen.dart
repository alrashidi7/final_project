

import 'package:final_project/models/ticketModel.dart';
import 'package:final_project/services/postviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class ResultSearchScreen extends StatefulWidget {
  final String? pickupStation;
  final String? destinationStation;
  final String? date;

  const ResultSearchScreen(this.pickupStation, this.destinationStation, this.date) ;


  @override
  _ResultSearchScreenState createState() => _ResultSearchScreenState();
}

class _ResultSearchScreenState extends State<ResultSearchScreen> {
  List<TicketModel> tickets =<TicketModel>[];
  PostViewModel postViewModel  = PostViewModel();
  @override
  void initState() {
    //
     postViewModel.getAllTickets(widget.pickupStation??'', widget.destinationStation??'', widget.date??'')
        .then((value)
    {
     setState(() {
       print('ticketssss:::${value.length}');
       tickets = value;
     });
    }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white54.withOpacity(0.8),
      body: SafeArea(

          child: Container(
            width: size.width,
            height: size.height,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Container(
              padding: EdgeInsets.all(8),

              margin: EdgeInsets.only(top: 10,bottom: 15),
              height: size.height * 0.15,
              width: size.width * 0.8,
              decoration: BoxDecoration(

                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(widget.pickupStation?? '',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900),),
                      Icon(Ionicons.train_outline),
                      Text(widget.destinationStation?? '',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900),),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    thickness: 1.0,
                    indent:  30,
                    endIndent: 30,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.date?? '',style: GoogleFonts.montaga(fontSize: 17),),

                      SizedBox(
                        width: 8,
                      ),
                      Icon(Ionicons.calendar_outline),
                    ],
                  ),
                ],
              ),
            ),
          Container(
            height: size.height * 0.75,
            child: FutureBuilder(
                future: postViewModel.getAllTickets('Egypt', 'Alex', ''),
                builder: (context, snapshot) {
                  print('tickets:::${tickets.length}');
                  if (snapshot.hasError) print('snapshot.error');
                  return snapshot.data != null
                      ? tickets.length == 0
                      ? Center(child: Text('Sorry, All Tickets are booked Already'))
                      : Container(
                      child: ListView.builder(
                          itemCount: tickets.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return ticketWidget(size, tickets[index]);
                          }))
                      : new Center(child: new CircularProgressIndicator());
                }),
          )
        ],
      ),
          )),
    );
  }
  Widget ticketWidget(Size size,TicketModel ticket){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(

                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            height: size.height * 0.27,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:10.0,top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ticket.trainName?? '',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),),
                      Text(ticket.trainType?? '',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),),
                    ],
                  ),
                ),
                Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(ticket.pickupStation?? ''),
                        Text(ticket.destinationStation?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Ionicons.train_outline,color: Theme.of(context).primaryColor,size: 35,),

                            Expanded(
                              child: Divider(
                                thickness: 1.0,
                                indent:  5,
                                endIndent: 5,
                                color: Colors.grey,
                              ),
                            ),

                        Icon(Ionicons.train_outline,color: Theme.of(context).accentColor,size: 35,),

                      ],
                    ),  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(ticket.pickupTime?? '',style:GoogleFonts.montaga()),
                        Text(ticket.destinationTime?? '',style:GoogleFonts.montaga()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ticket.ticketClass?? '',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Theme.of(context).primaryColor),),
                          RichText(
                            text: TextSpan(
                              children: [

                                TextSpan(text:ticket.ticketCost?? '',style: GoogleFonts.limelight(fontSize: 19,fontWeight: FontWeight.w900,color: Theme.of(context).primaryColor),),
                                TextSpan(
                                  text: '.EGP',
                                  style: GoogleFonts.limelight(fontSize: 19,fontWeight: FontWeight.w900,color: Theme.of(context).primaryColor),

                                ),
                              ],
                            ),
                          ),
                          ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Duration of Trip : ',
                              style: TextStyle(color: Colors.black),

                            ),
                            TextSpan(
                                text: '3.30',
                                style: GoogleFonts.montaga(fontSize: 18,color: Theme.of(context).primaryColor,fontWeight: FontWeight.w700),

                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );

  }

}
