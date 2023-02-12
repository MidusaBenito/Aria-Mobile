import 'dart:convert';
import 'dart:io';

import 'package:ariaquickpay/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'urls.dart' as myurls;
import 'utils.dart';
import 'package:intl/intl.dart';

class changeDisplayBillers with ChangeNotifier {
  int _displayIndex = 0;
  void changeIndex(int newIndex) {
    _displayIndex = newIndex;
    //print('clicked!!');
    notifyListeners();
  }

  int get displayIndex => _displayIndex;
}

class deleteBillers with ChangeNotifier {
  //int _billId = 0;
  int _mynumberOfBillers = UserSimplePreferences.getNumberOfBillers() ?? 0;
  void billDelete(client, String billId, biller_list_response, biller) async {
    List<deletedBiller> delete_biller_response = [];
    var deleteBillUrl = myurls.AriaApiEndpoints.deleteBiller;
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    if (userToken != '') {
      //print(billId);
      var deleteMyBillerResponse = await client.post(
        Uri.parse(deleteBillUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
        body: {
          'billId': billId,
        },
      );
      if (deleteMyBillerResponse.statusCode == 200) {
        var deleteMyBillerResponseJsons =
            json.decode(deleteMyBillerResponse.body);
        delete_biller_response
            .add(deletedBiller.fromJson(deleteMyBillerResponseJsons));
        if (delete_biller_response[0].deleteResponse == "delete successful") {
          //print(biller_list_response.length);
          biller_list_response.remove(biller);
          UserSimplePreferences.setNumberOfBillers(biller_list_response.length);
          //print(biller_list_response.length);
          _mynumberOfBillers = UserSimplePreferences.getNumberOfBillers() ?? 0;
          notifyListeners();
        }
      }
    }
  }
}

class addBillers with ChangeNotifier {
  //int _mynumberOfBillers = UserSimplePreferences.getNumberOfBillers() ?? 0;
  void updateNumber() {
    //_mynumberOfBillers = UserSimplePreferences.getNumberOfBillers() ?? 0;
    notifyListeners();
  }

  //int get mynumberOfBillers => _mynumberOfBillers;
}

class showSearchedBillers with ChangeNotifier {
  //int _mynumberOfBillers = UserSimplePreferences.getNumberOfBillers() ?? 0;
  void showBillers() {
    //_mynumberOfBillers = UserSimplePreferences.getNumberOfBillers() ?? 0;
    notifyListeners();
  }

  //int get mynumberOfBillers => _mynumberOfBillers;
}

class updateNewDate with ChangeNotifier {
  void showNewDate(biller_details, newDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    newDate = formatter.format(newDate);
    biller_details[0].next_due_date = newDate;
    notifyListeners();
  }
}

class updateAutoPayCheckbox with ChangeNotifier {
  void updateCheckBox(biller_details, val) {
    biller_details[0].automatic_payments = val;
    notifyListeners();
  }
}

class updateReminderCheckbox with ChangeNotifier {
  void updateCheckBox(biller_details, val) {
    biller_details[0].send_email_reminder = val;
    notifyListeners();
  }
}

class controlCalendarWarning with ChangeNotifier {
  bool _showWarning = false;
  void updateWarningStatus(bool new_warning_status) {
    _showWarning = new_warning_status;
    notifyListeners();
  }

  bool get showWarning => _showWarning;
}

class controlAccntWarning with ChangeNotifier {
  bool _showWarning = false;
  void updateWarningStatus(bool new_warning_status) {
    _showWarning = new_warning_status;
    notifyListeners();
  }

  bool get showWarning => _showWarning;
}

class controlZipCodeWarning with ChangeNotifier {
  bool _showWarning = false;
  void updateWarningStatus(bool new_warning_status) {
    _showWarning = new_warning_status;
    notifyListeners();
  }

  bool get showWarning => _showWarning;
}

class controlPhoneNumberWarning with ChangeNotifier {
  bool _showWarning = false;
  void updateWarningStatus(bool new_warning_status) {
    _showWarning = new_warning_status;
    notifyListeners();
  }

  bool get showWarning => _showWarning;
}
