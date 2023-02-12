import 'dart:convert';

//part 'example.g.dart';

class UserRegistrationResponse {
  String errorMessage;
  String userPrimaryKey;

  UserRegistrationResponse({
    required this.errorMessage,
    required this.userPrimaryKey,
  });

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return UserRegistrationResponse(
      errorMessage: json['error'],
      userPrimaryKey: json['user_id'],
    );
  }
}

//class UserPkResponse {
// String PkUser;
//UserPkResponse({required this.PkUser});

//factory UserPkResponse.fromJson(Map<String, dynamic> json) {
//return UserPkResponse(PkUser: json["verified"]);
// }
//}

class UserLoggedIn {
  String Token;
  //String non_field_error;
  UserLoggedIn({required this.Token});

  factory UserLoggedIn.fromJson(Map<String, dynamic> json) {
    return UserLoggedIn(Token: json["token"]);
  }
}

class MyBillers {
  int biller_id;
  String biller_name;
  String biller_logo_url;
  String biller_category;
  bool due_date_set;
  String next_due;
  String billing_account_number;

  MyBillers({
    required this.biller_id,
    required this.biller_name,
    required this.biller_logo_url,
    required this.biller_category,
    required this.due_date_set,
    required this.next_due,
    required this.billing_account_number,
  });

  factory MyBillers.fromJson(Map<String, dynamic> json) {
    return MyBillers(
        biller_id: json["biller_id"],
        biller_name: json["biller_name"],
        biller_logo_url: json["biller_logo_url"],
        biller_category: json["biller_category"],
        due_date_set: json["due_date_set"],
        next_due: json["next_due"],
        billing_account_number: json["billing_account_number"]);
  }
} //

class UserVerificationandPkResponse {
  String emailVerified;
  String PkUser;

  UserVerificationandPkResponse({
    required this.emailVerified,
    required this.PkUser,
  });

  factory UserVerificationandPkResponse.fromJson(Map<String, dynamic> json) {
    return UserVerificationandPkResponse(
        emailVerified: json["verified"], PkUser: json["userPK"]);
  }
}

class deletedBiller {
  String deleteResponse;
  //String non_field_error;
  deletedBiller({required this.deleteResponse});

  factory deletedBiller.fromJson(Map<String, dynamic> json) {
    return deletedBiller(deleteResponse: json["verdict"]);
  }
}

class BillerPaymentsDetails {
  String next_due_date, billing_frequency, billing_account_number;
  bool automatic_payments, send_email_reminder;

  BillerPaymentsDetails({
    required this.next_due_date,
    required this.billing_frequency,
    required this.billing_account_number,
    required this.automatic_payments,
    required this.send_email_reminder,
  });

  factory BillerPaymentsDetails.fromJson(Map<String, dynamic> json) {
    return BillerPaymentsDetails(
      next_due_date: json["next_due_date"],
      billing_frequency: json["billing_frequency"],
      billing_account_number: json["billing_account_number"],
      automatic_payments: json["automatic_payments"],
      send_email_reminder: json["send_email_reminder"],
    );
  }
} //

class postBiller {
  String editResponse;
  //String non_field_error;
  postBiller({required this.editResponse});

  factory postBiller.fromJson(Map<String, dynamic> json) {
    return postBiller(editResponse: json["actionStatus"]);
  }
}

class plaidToken {
  String linkToken;
  //String non_field_error;
  plaidToken({required this.linkToken});

  factory plaidToken.fromJson(Map<String, dynamic> json) {
    return plaidToken(linkToken: json["link_token"]);
  }
}

class mywalletBalance {
  String wallet_balance;
  //String non_field_error;
  mywalletBalance({required this.wallet_balance});

  factory mywalletBalance.fromJson(Map<String, dynamic> json) {
    return mywalletBalance(wallet_balance: json["wallet_balance"]);
  }
}

class payViaWalletResponse {
  String verdict;
  //String non_field_error;
  payViaWalletResponse({required this.verdict});

  factory payViaWalletResponse.fromJson(Map<String, dynamic> json) {
    return payViaWalletResponse(verdict: json["verdict"]);
  }
}

class paymentHistory {
  String date_paid, paid_amount, biller, transaction_id;
  paymentHistory(
      {required this.date_paid,
      required this.paid_amount,
      required this.biller,
      required this.transaction_id});
  factory paymentHistory.fromJson(Map<String, dynamic> json) {
    return paymentHistory(
        date_paid: json['date_paid'],
        paid_amount: json['paid_amount'],
        biller: json['biller'],
        transaction_id: json['transaction_id']);
  }
}

class myMessagesResponse {
  String myMessages;
  String readStatus;
  //String non_field_error;
  myMessagesResponse({required this.myMessages, required this.readStatus});

  factory myMessagesResponse.fromJson(Map<String, dynamic> json) {
    return myMessagesResponse(
        myMessages: json["message_body"], readStatus: json['message_read']);
  }
}

class myNotificationsResponse {
  String myNotifications;
  String readStatus;
  //String non_field_error;
  myNotificationsResponse(
      {required this.myNotifications, required this.readStatus});

  factory myNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return myNotificationsResponse(
        myNotifications: json["notification_body"],
        readStatus: json['notification_read']);
  }
}

class timeZones {
  String zoneValue;
  String zoneDisplay;
  timeZones({required this.zoneValue, required this.zoneDisplay});

  factory timeZones.fromJson(Map<String, dynamic> json) {
    return timeZones(zoneValue: json["value"], zoneDisplay: json['display']);
  }
}

class profileData {
  String phone, time_zone, zip_code;
  //String zoneDisplay;
  profileData(
      {required this.phone, required this.time_zone, required this.zip_code});

  factory profileData.fromJson(Map<String, dynamic> json) {
    return profileData(
        phone: json["phone"],
        time_zone: json['timezone'],
        zip_code: json['zipCode']);
  }
}

class postProfile {
  String editResponse;
  //String non_field_error;
  postProfile({required this.editResponse});

  factory postProfile.fromJson(Map<String, dynamic> json) {
    return postProfile(editResponse: json["verdict"]);
  }
}

//class myCalendarDataResponse {
  //String billerDueDate;
  //List<String> billerNameList;
  //String non_field_error;
 // myCalendarDataResponse(
      //{required this.billerDueDate, required this.billerNameList});

  //factory myCalendarDataResponse.fromJson(Map<String, dynamic> json) {
    //return myCalendarDataResponse(
       // billerDueDate: json["due_date"], billerNameList: json['bill_name']);
  //}
//}
