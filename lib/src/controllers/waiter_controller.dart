import 'package:flutter/material.dart';

import '../../waiter.dart';

class WaiterController extends ValueNotifier<WaiterValue> {
  WaiterController() : super(WaiterValue(model: WaiterModel()));

  /// handel onTry.
  ValueNotifier<String> onTry = ValueNotifier<String>('');

  /// main waiter model.
  WaiterModel get model => value.model;

  set _model(WaiterModel newElm) {
    value = value.copyWith(
      model: newElm,
    );
  }

  /// waiter is visible.
  bool get isVisible => value.model.isVisible;

  /// waiter is progressing.
  bool get isProgress => value.model.type == 'progress';

  /// get type waiter.
  ///
  /// contain `loading`,`hiddenLoading`,`errorWithOutOK`,`error`,`progress`.
  String get type => value.model.type;

  /// show loading.
  void showLoading() {
    _model = WaiterModel().showLoading();
  }

  /// hidden loading.
  ///
  /// The [tag] To hide a specific tag.
  void hiddenLoading(String tag) {
    _model = WaiterModel().hiddenLoading(tag);
  }

  /// show error.
  ///
  /// The [tag] set a specific tag.
  void showError(String tag) {
    _model = WaiterModel().showError(tag);
  }

  /// show error with toast.
  ///
  /// The [tag] set a specific tag.
  /// The [toast] text after show error.
  void showErrorToast(String tag, String toast) {
    _model = WaiterModel().showErrorToast(tag, toast);
  }

  /// show error without OK Button.
  ///
  /// The [tag] set a specific tag.
  void showErrorWithOutOK(String tag) {
    _model = WaiterModel().showErrorWithOutOK(tag);
  }

  /// show error without OK Button and with toast.
  ///
  /// The [tag] set a specific tag.
  /// The [toast] text after show error without OK Button.
  void showErrorToastWithOutOK(String tag, String toast) {
    _model = WaiterModel().showErrorToastWithOutOK(tag, toast);
  }

  /// hidden error.
  void hiddenError() {
    _model = WaiterModel().hiddenError();
  }

  /// show progress.
  ///
  /// The [tag] set a specific tag.
  void showProgress(String tag) {
    _model = WaiterModel().showProgress(tag);
  }

  /// hidden progress.
  ///
  /// The [tag] set a specific tag.
  void hiddenProgress(String tag) {
    _model = WaiterModel().hiddenLoading(tag);
  }
}

@immutable
class WaiterValue {
  const WaiterValue({
    required this.model,
  });

  final WaiterModel model;

  WaiterValue copyWith({
    required WaiterModel model,
  }) {
    return WaiterValue(
      model: model,
    );
  }
}
