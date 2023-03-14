import 'package:onesignal_flutter/onesignal_flutter.dart';

abstract class IOneSignalService {
  const IOneSignalService();
  Future<void> initialize({String? appId}) async {}

  void listenToSubscriptionChanges({
    Function(OSSubscriptionStateChanges)? onChanged,
  }) {}

  void setLanguage(String language) {}

  void setPushNotification(bool value) {}
}
