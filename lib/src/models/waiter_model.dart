// ignore_for_file: avoid_returning_this
class WaiterModel {
  bool isVisible = false;

  String type = '';
  String callBackTag = '';
  String toastText = '';

  /// show loading.
  WaiterModel showLoading() {
    type = 'loading';
    isVisible = true;
    return this;
  }

  /// hidden loading.
  WaiterModel hiddenLoading(final String tag) {
    type = 'hiddenLoading';
    isVisible = false;
    return this;
  }

  /// error without OK.
  WaiterModel showErrorWithOutOK(final String tag) {
    type = 'errorWithOutOK';
    isVisible = true;
    callBackTag = tag;
    return this;
  }

  /// show error.
  WaiterModel showError(final String tag) {
    type = 'error';
    isVisible = true;
    callBackTag = tag;
    return this;
  }

  /// show error with toast.
  WaiterModel showErrorToast(final String tag, final String toast) {
    type = 'error';
    isVisible = true;
    callBackTag = tag;
    toastText = toast;
    return this;
  }

  /// show error without ok button and with toast.
  WaiterModel showErrorToastWithOutOK(final String tag, final String toast) {
    type = 'errorWithOutOK';
    isVisible = true;
    callBackTag = tag;
    toastText = toast;
    return this;
  }

  /// hidden error.
  WaiterModel hiddenError() {
    isVisible = false;
    return this;
  }

  /// show progress.
  WaiterModel showProgress(final String tag) {
    type = 'progress';
    isVisible = true;
    callBackTag = tag;
    return this;
  }
}
