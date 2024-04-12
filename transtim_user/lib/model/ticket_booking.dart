import '../utility/helper/common_helper.dart';

class TicketBooking {
  String? ticketBookingId, userId, date, time, passengerCount, totalAmount;
  String? ticketId, amount, title, description, ticketType, expireInMinutes;
  String? status;

  TicketBooking({
    this.ticketBookingId,
    this.userId,
    this.date,
    this.time,
    this.passengerCount,
    this.totalAmount,
    this.ticketId,
    this.amount,
    this.title,
    this.description,
    this.ticketType,
    this.expireInMinutes,
    this.status,
  });

  TicketBooking.fromJson(Map<String, dynamic> json) {
    try {
      ticketBookingId = json['ticketBookingId'];
      userId = json['userId'];
      date = json['date'];
      time = json['time'];
      passengerCount = json['passengerCount'];
      totalAmount = json['totalAmount'];
      ticketId = json['ticketId'];
      amount = json['amount'];
      title = json['title'];
      description = json['description'];
      ticketType = json['ticketType'];
      expireInMinutes = json['expireInMinutes'];
      status = json['api_status'];
    } catch (e) {
      CommonHelper.printDebugError(e, "Error parsing TicketBooking");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ticketBookingId != null) {
      data['ticketBookingId'] = ticketBookingId;
    }
    if (userId != null) {
      data['userId'] = userId;
    }
    if (ticketId != null) {
      data['ticketId'] = ticketId;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (time != null) {
      data['time'] = time;
    }
    if (passengerCount != null) {
      data['passengerCount'] = passengerCount;
    }
    if (totalAmount != null) {
      data['totalAmount'] = totalAmount;
    }
    return data;
  }
}
