class TicketModel {
  final String? ticketId;
  final String? status;
  final String? pickupStation;
  final String? destinationStation;
  final String? trainName;
  final String? trainType;
  final String? pickupTime;
  final String? destinationTime;
  final String? ticketClass;
  final String? ticketCost;
  final String? date;

  TicketModel(
      {  this.ticketId ,
         this.status,
         this.pickupStation,
         this.destinationStation,
         this.trainName,
         this.trainType,
         this.pickupTime,
         this.destinationTime,
         this.ticketClass,
        this.ticketCost,
         this.date});

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
        ticketId: json['ticketId'],
        status: json['status'],
        pickupStation: json['pickupStation'],
        destinationStation: json['destinationStation'],
        trainName: json['trainName'],
        trainType: json['trainType'],
        pickupTime: json['pickupTime'],
        destinationTime: json['destinationTime'],
        ticketClass: json['ticketClass'],
        date: json['date'],
        ticketCost: json['ticketCost']);
  }
}
