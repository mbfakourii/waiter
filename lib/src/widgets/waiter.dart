import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../waiter.dart';

Language globalLanguage = Language();

class Waiter extends StatefulWidget {
  final ValueNotifier<double>? progress;
  final ValueNotifier<int>? totalNumberProgress;
  final ValueNotifier<int>? currentNumberProgress;

  final WaiterController callback;
  final Widget child;
  final ValueSetter<String>? onTry;
  final ValueSetter<String>? onCancelProgress;
  final bool? firstLoadShowLoading;
  final GestureTapCallback? onCloseProgress;
  final GlobalKey? mainKey;
  final Language? language;

  const Waiter(
      {super.key,
      this.mainKey,
      required this.child,
      required this.callback,
      this.onTry,
      this.language,
      this.onCancelProgress,
      this.firstLoadShowLoading,
      this.progress,
      this.totalNumberProgress,
      this.currentNumberProgress,
      this.onCloseProgress});

  @override
  State<Waiter> createState() => _WaiterState();
}

class _WaiterState extends State<Waiter> {
  bool isErrorWithoutOK = false;
  bool isError = false;
  bool isLoading = false;
  bool isProgress = false;
  bool animationError = false;
  bool animationLoading = false;

  String textPercent = "0";
  String textTotal = "0";
  String textCurrent = "0";
  String currentSelectedTag = "";

  double sizeHeight = 0;
  double widthTryError = 0;
  double showPercent = 0.0;

  List<String> tags = [];

  Color? backgroundColor = const Color(0xB4636060);

  TextStyle buttonStyle3 =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp);
  TextStyle textStyle3 =
      TextStyle(fontWeight: FontWeight.normal, fontSize: 18.sp);

  @override
  void dispose() {
    if (widget.onCancelProgress != null) {
      try {
        widget.onCancelProgress!.call("");
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Waiter oldWidget) {
    setListeners();
    super.didUpdateWidget(oldWidget);
  }

  late BorderRadius cardRadios;

  @override
  void initState() {
    super.initState();

    if (widget.language != null) {
      globalLanguage = widget.language!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.firstLoadShowLoading == true) {
        setWidgetVisibility(
            isLoading: true,
            isError: false,
            isProgress: false,
            isErrorWithoutOK: false);
      }
    });

    setListeners();
  }

  void setListeners() {
    if (widget.progress != null) {
      widget.progress!.addListener(() {
        if (isProgress) {
          setState(() {
            textPercent = ((widget.progress!.value * 100) ~/ 100).toString();
            showPercent = widget.progress!.value;
          });
        }
      });
    }
    if (widget.currentNumberProgress != null) {
      widget.currentNumberProgress!.addListener(() {
        if (isProgress) {
          setState(() {
            textCurrent = widget.currentNumberProgress!.value.toString();
          });
        }
      });
    }

    if (widget.totalNumberProgress != null) {
      widget.totalNumberProgress!.addListener(() {
        if (isProgress) {
          setState(() {
            textTotal = widget.totalNumberProgress!.value.toString();
          });
        }
      });
    }

    widget.callback.addListener(() {
      if (widget.callback.model.isVisible) {
        switch (widget.callback.model.type) {
          case "loading":
            {
              setWidgetVisibility(
                  isLoading: true,
                  isError: false,
                  isProgress: false,
                  isErrorWithoutOK: false);
              break;
            }
          case "error":
            {
              currentSelectedTag = widget.callback.model.callBackTag;
              setWidgetVisibility(
                  isLoading: false,
                  isError: true,
                  isProgress: false,
                  isErrorWithoutOK: false);
              if (widget.callback.model.toastText != "") {
                Fluttertoast.showToast(
                    msg: widget.callback.model.toastText,
                    toastLength: Toast.LENGTH_SHORT);
              }
              break;
            }

          case "errorWithOutOK":
            {
              setWidgetVisibility(
                  isLoading: false,
                  isError: true,
                  isProgress: false,
                  isErrorWithoutOK: true);
              break;
            }

          case "progress":
            {
              setWidgetVisibility(
                  isLoading: false,
                  isError: false,
                  isProgress: true,
                  isErrorWithoutOK: false);
              break;
            }
        }
      } else {
        if (currentSelectedTag == widget.callback.model.callBackTag) {
          currentSelectedTag = "";
          try {
            setWidgetVisibility(
                isLoading: false,
                isError: false,
                isProgress: false,
                isErrorWithoutOK: false);
          } catch (_) {}
        } else {
          if (widget.callback.model.type == "hiddenLoading") {
            setWidgetVisibility(
                isLoading: false,
                isError: false,
                isProgress: false,
                isErrorWithoutOK: false);
          }
        }
      }
    });
  }

  void setWidgetVisibility(
      {bool isLoading = false,
      bool isError = false,
      bool isProgress = false,
      bool isErrorWithoutOK = false}) {
    if (isError || isErrorWithoutOK) {
      tags.add(widget.callback.model.callBackTag);
    }

    if (mounted) {
      setState(() {
        animationLoading = isLoading;
        this.isLoading = isLoading;

        animationError = isError;
        this.isError = isError;
        this.isErrorWithoutOK = isErrorWithoutOK;

        if (isErrorWithoutOK) {
          widthTryError = 71.w;
        } else {
          widthTryError = 34.w;
        }

        this.isProgress = isProgress;
      });
    }

    if (isProgress) {
      widget.progress?.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // this for sheet fit size
    if (widget.mainKey != null) {
      try {
        sizeHeight =
            (widget.mainKey!.currentContext!.findRenderObject()! as RenderBox)
                .size
                .height;
      } catch (_) {}
    }

    cardRadios = Theme.of(context).useMaterial3
        ? const BorderRadius.all(Radius.circular(12.0))
        : const BorderRadius.all(Radius.circular(4.0));

    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return Material(
        child: Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.center,
          children: [
            widget.child,
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isLoading,
              child: Container(
                  height: widget.mainKey == null
                      ? null
                      : sizeHeight == 0
                          ? 0
                          : sizeHeight,
                  // this color for transparent for back
                  decoration: BoxDecoration(color: backgroundColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: SizedBox(
                              child: Lottie.asset(
                        'packages/waiter/assets/loading.json',
                        animate: animationLoading,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.colorFilter(
                              const ['icon', '**'],
                              value: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.src),
                            ),
                            ValueDelegate.colorFilter(
                              const ['icon 2', '**'],
                              value: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.src),
                            ),
                          ],
                        ),
                      )))
                    ],
                  )),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isError,
              child: Container(
                  height: widget.mainKey == null
                      ? null
                      : sizeHeight == 0
                          ? 0
                          : sizeHeight,
                  decoration: BoxDecoration(color: backgroundColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: SizedBox(
                        width: 80.w,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                Lottie.asset(
                                  'packages/waiter/assets/error.json',
                                  repeat: false,
                                  animate: animationError,
                                  delegates: LottieDelegates(
                                    values: [
                                      ValueDelegate.colorFilter(
                                        const ['Rectangle 6 Copy', '**'],
                                        value: ColorFilter.mode(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            BlendMode.src),
                                      ),
                                      ValueDelegate.colorFilter(
                                        const ['Combined Shape', '**'],
                                        value: ColorFilter.mode(
                                            Theme.of(context)
                                                .colorScheme
                                                .background,
                                            BlendMode.src),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Visibility(
                                      visible: !isErrorWithoutOK,
                                      child: Flexible(
                                        flex: 2,
                                        child: Container(
                                            color: Colors.transparent,
                                            width: 34.w,
                                            child: TextButton(
                                              child: Text(
                                                globalLanguage.confirm,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.sp),
                                              ),
                                              onPressed: () {
                                                widget.callback.hiddenLoading(
                                                    widget.callback.model
                                                        .callBackTag);
                                              },
                                            )),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !isErrorWithoutOK,
                                      child: SizedBox(
                                        width: 3.w,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                          color: Colors.transparent,
                                          width: widthTryError,
                                          child: TextButton(
                                            child: Text(globalLanguage.tryAgain,
                                                style: buttonStyle3),
                                            onPressed: () {
                                              if (tags.isEmpty) {
                                                throw "tags is empty!";
                                              }

                                              for (var tag in tags) {
                                                widget.onTry!.call(tag);
                                              }

                                              tags.clear();

                                              if (widget.callback.model.type ==
                                                  "progress") {
                                                widget.callback.showProgress(
                                                    widget.callback.model
                                                        .callBackTag);
                                              } else {
                                                widget.callback.showLoading();
                                              }
                                            },
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  )),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isProgress,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: widget.onCloseProgress,
                child: Container(
                    height: widget.mainKey == null
                        ? null
                        : sizeHeight == 0
                            ? 0
                            : sizeHeight,
                    decoration: BoxDecoration(color: backgroundColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: SizedBox(
                                width: 80.w,
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 1.h, top: 1.h),
                                        child: Text(globalLanguage.pleaseWait,
                                            style: textStyle3),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(end: 9),
                                              child: Text("%$textPercent",
                                                  style: textStyle3),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                  width: double.infinity,
                                                  height: 2.h,
                                                  child: ClipRRect(
                                                    borderRadius: cardRadios,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: showPercent / 100,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onSecondary,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                    ),
                                                  )),
                                            ),
                                            if (textTotal != "0" &&
                                                textTotal != "1")
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(start: 9),
                                                child: Row(
                                                  children: [
                                                    Text("$textCurrent/",
                                                        style: textStyle3),
                                                    Text(textTotal,
                                                        style: textStyle3),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          color: Colors.transparent,
                                          width: widthTryError,
                                          child: TextButton(
                                            child: Text(globalLanguage.cancel,
                                                style: buttonStyle3),
                                            onPressed: () {
                                              widget.onCancelProgress?.call(
                                                  widget.callback.model
                                                      .callBackTag);
                                              setWidgetVisibility(
                                                  isLoading: false,
                                                  isError: false,
                                                  isProgress: false,
                                                  isErrorWithoutOK: false);
                                            },
                                          )),
                                    ],
                                  ),
                                ))))
                      ],
                    )),
              ),
            ),
          ],
        ),
      );
    });
  }
}
