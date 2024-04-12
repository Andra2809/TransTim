import '../utility/helper/common_helper.dart';

class Ticket {
  String? ticketId, amount, title, description, ticketType;

  String? status;

  Ticket({
    this.ticketId,
    this.amount,
    this.title,
    this.description,
    this.ticketType,
    this.status,
  });

  Ticket.fromJson(Map<String, dynamic> json) {
    try {
      ticketId = json['ticketId'];
      amount = json['amount'];
      title = json['title'];
      description = json['description'];
      ticketType = json['ticketType'];
      status = json['api_status'];
    } catch (e) {
      CommonHelper.printDebugError(e, "Error parsing Ticket");
    }
  }
}
