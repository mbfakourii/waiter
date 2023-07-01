import 'package:flutter/material.dart';

import '../../waiter.dart';

class WaiterController extends ValueNotifier<WaiterValue> {
  WaiterController() : super(WaiterValue(model: WaiterModel()));

  ValueNotifier<String> onTry = ValueNotifier<String>("");

  WaiterModel get model => value.model;

  set _model(WaiterModel newElm) {
    value = value.copyWith(
      model: newElm,
    );
  }

  bool get isVisible => value.model.isVisible;

  String get type => value.model.type;

  void showLoading() {
    _model = WaiterModel().showLoading();
  }

  void hiddenLoading(String tag) {
    _model = WaiterModel().hiddenLoading(tag);
  }

  void showError(String tag) {
    _model = WaiterModel().showError(tag);
  }

  void showErrorToast(String tag, String toast) {
    _model = WaiterModel().showErrorToast(tag, toast);
  }

  void showErrorWithOutOK(String value) {
    _model = WaiterModel().showErrorWithOutOK(value);
  }

  void showErrorToastWithOutOK(String tag, String toast) {
    _model = WaiterModel().showErrorToastWithOutOK(tag, toast);
  }

  void hiddenError() {
    _model = WaiterModel().hiddenError();
  }

  void showProgress(String tag) {
    _model = WaiterModel().showProgress(tag);
  }

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
