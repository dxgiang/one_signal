import 'dart:developer' as dev;
import 'dart:io';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'onesignal_service_interface.dart';

class OneSignalService extends IOneSignalService {
  @override
  Future<void> initialize({String? appId}) async {
    await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId(appId ?? '');
    await OneSignal.shared.consentGranted(true);
    if (Platform.isIOS) {
      await OneSignal.shared
          .promptUserForPushNotificationPermission(fallbackToSettings: true);
    }
    super.initialize(appId: appId);
  }

  /// Set the language for OneSignal notifications
  @override
  void setLanguage(String language) {
    OneSignal.shared.setLanguage(language);
    super.setLanguage(language);
  }

  /// Disable or enable push notifications
  @override
  void setPushNotification(bool value) {
    OneSignal.shared.disablePush(value); // true to disable
    super.setPushNotification(value);
  }

  /// Listen to subscription changes
  @override
  void listenToSubscriptionChanges({
    Function(OSSubscriptionStateChanges)? onChanged,
  }) {
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
      onChanged?.call(changes);
      dev.log(changes.jsonRepresentation());
    });
    super.listenToSubscriptionChanges(onChanged: onChanged);
  }

  /*--------------------------------------------------------------------------*/

  /// Set up the notification received handler
  void setUpOpenedNotificationHandler({
    Function(OSNotificationOpenedResult)? onOpened,
  }) {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
      onOpened?.call(result);
      dev.log(result.notification.jsonRepresentation());
    });
  }

  /// Listen to notification will show in foreground
  void listenToNotificationWillShowInForegroundHandler({
    Function(OSNotificationReceivedEvent)? onReceived,
  }) {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // will be called whenever a notification is received
      onReceived?.call(event);
      dev.log(event.notification.jsonRepresentation());
    });
  }

  /// Listen to permission changes
  void listenToPermissionChanges({
    Function(OSPermissionStateChanges)? onOSPermissionStateChanges,
  }) {
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
      onOSPermissionStateChanges?.call(changes);
      dev.log(changes.jsonRepresentation());
    });
  }

  /// Listen to email subscription changes
  void listenToEmailSubscriptionChanges({
    Function(OSEmailSubscriptionStateChanges)?
        onOSEmailSubscriptionStateChanges,
  }) {
    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      // will be called whenever then email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
      onOSEmailSubscriptionStateChanges?.call(changes);
      dev.log(changes.jsonRepresentation());
    });
  }

  /// Set external user id
  Future<Map<String, dynamic>> setExternalUserId(
    String externalId, [
    String? authHashToken,
  ]) async {
    return await OneSignal.shared.setExternalUserId(
      externalId,
      authHashToken,
    );
  }

  /// Remove external user id
  Future<Map<String, dynamic>> removeExternalUserId() async {
    return await OneSignal.shared.removeExternalUserId();
  }

  /// Set email
  Future<void> setEmail({
    required String email,
    String? emailAuthHashToken,
  }) async {
    return await OneSignal.shared.setEmail(
      email: email,
      emailAuthHashToken: emailAuthHashToken,
    );
  }

  /// Logout email
  Future<void> logoutEmail() async {
    return await OneSignal.shared.logoutEmail();
  }
}
