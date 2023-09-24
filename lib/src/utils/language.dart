/// language texts.
class Language {
  Language();

  /// help for cheng language texts.
  Language.copy({
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
