class WaiterModel {
  bool isVisible = false;

  String type = "";
  String callBackTag = "";
  String toastText = "";

  WaiterModel showLoading() {
    type = "loading";
    isVisible = true;
    return this;
  }

  WaiterModel hiddenLoading(String tag) {
    type = "hiddenLoading";
    isVisible = false;
    return this;
  }

  WaiterModel showErrorWithOutOK(String tag) {
    type = "errorWithOutOK";
    isVisible = true;
    callBackTag = tag;
    return this;
  }

  WaiterModel showError(String tag) {
    type = "error";
    isVisible = true;
    callBackTag = tag;
    return this;
  }

  WaiterModel showErrorToast(String tag, String toast) {
    type = "error";
    isVisible = true;
    callBackTag = tag;
    toastText = toast;
    return this;
  }

  WaiterModel showErrorToastWithOutOK(String tag, String toast) {
    type = "errorWithOutOK";
    isVisible = true;
    callBackTag = tag;
    toastText = toast;
    return this;
  }

  WaiterModel hiddenError() {
    isVisible = false;
    return this;
  }

  WaiterModel showProgress(String tag) {
    type = "progress";
    isVisible = true;
    callBackTag = tag;
    return this;
  }
}
