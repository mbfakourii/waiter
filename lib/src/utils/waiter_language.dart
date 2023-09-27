/// language texts.
class WaiterLanguage {
  WaiterLanguage();

  /// help for cheng language texts.
  WaiterLanguage.copy({
    required this.confirm,
    required this.pleaseWait,
    required this.cancel,
    required this.tryAgain,
  });

  String confirm = 'Confirm';
  String tryAgain = 'Try Again';
  String pleaseWait = 'Please wait';
  String cancel = 'Cancel';
}
