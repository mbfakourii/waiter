import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:waiter/waiter.dart';

WaiterLanguage globalWaiterLanguage = WaiterLanguage();

class Waiter extends StatefulWidget {
  const Waiter({
    required this.child,
    required this.controller,
    super.key,
    this.mainKey,
    this.onTry,
    this.language,
    this.onCancelProgress,
    this.firstLoadShowLoading,
    this.progress,
    this.totalNumberProgress,
    this.currentNumberProgress,
    this.onDismissProgress,
  });

  final ValueNotifier<double>? progress;
  final ValueNotifier<int>? totalNumberProgress;
  final ValueNotifier<int>? currentNumberProgress;

  final WaiterController controller;
  final Widget child;
  final ValueSetter<String>? onTry;
  final ValueSetter<String>? onCancelProgress;
  final bool? firstLoadShowLoading;
  final GestureTapCallback? onDismissProgress;
  final GlobalKey? mainKey;
  final WaiterLanguage? language;

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

  String textPercent = '0';
  String textTotal = '0';
  String textCurrent = '0';
  String currentSelectedTag = '';

  double sizeHeight = 0;
  double widthTryError = 0;
  double showPercent = 0;

  List<String> tags = <String>[];

  Color? backgroundColor = const Color(0xB4636060);

  @override
  void dispose() {
    if (widget.onCancelProgress != null) {
      try {
        widget.onCancelProgress!.call('');
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant final Waiter oldWidget) {
    setListeners();
    super.didUpdateWidget(oldWidget);
  }

  late BorderRadius cardRadios;

  @override
  void initState() {
    super.initState();

    if (widget.language != null) {
      globalWaiterLanguage = widget.language!;
    }

    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (widget.firstLoadShowLoading ?? false) {
        setWidgetVisibility(
          isLoading: true,
        );
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

    widget.controller.addListener(() {
      if (widget.controller.model.isVisible) {
        switch (widget.controller.model.type) {
          case 'loading':
            {
              setWidgetVisibility(
                isLoading: true,
              );
              break;
            }
          case 'error':
            {
              currentSelectedTag = widget.controller.model.callBackTag;
              setWidgetVisibility(
                isError: true,
              );
              if (widget.controller.model.toastText != '') {
                Fluttertoast.showToast(
                  msg: widget.controller.model.toastText,
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
              break;
            }

          case 'errorWithOutOK':
            {
              setWidgetVisibility(
                isError: true,
                isErrorWithoutOK: true,
              );
              break;
            }

          case 'progress':
            {
              setWidgetVisibility(
                isProgress: true,
              );
              break;
            }
        }
      } else {
        if (currentSelectedTag == widget.controller.model.callBackTag) {
          currentSelectedTag = '';
          try {
            setWidgetVisibility();
          } catch (_) {}
        } else {
          setWidgetVisibility();
        }
      }
    });
  }

  void setWidgetVisibility({
    final bool isLoading = false,
    final bool isError = false,
    final bool isProgress = false,
    final bool isErrorWithoutOK = false,
  }) {
    if (isError || isErrorWithoutOK) {
      tags.add(widget.controller.model.callBackTag);
    }

    if (mounted) {
      setState(() {
        animationLoading = isLoading;
        this.isLoading = isLoading;

        animationError = isError;
        this.isError = isError;
        this.isErrorWithoutOK = isErrorWithoutOK;

        if (isErrorWithoutOK) {
          widthTryError = 190.w;
        } else {
          widthTryError = 100.w;
        }

        this.isProgress = isProgress;
      });
    }

    if (isProgress) {
      widget.progress?.value = 0;
    }
  }

  @override
  Widget build(final BuildContext context) {
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
        ? const BorderRadius.all(Radius.circular(12))
        : const BorderRadius.all(Radius.circular(4));

    try {
      // test for ScreenUtil initialize
      1.w;
      return _getMainWidget();
    } catch (_) {
      ScreenUtil.init(context);

      return FutureBuilder<void>(
        future: ScreenUtil.ensureScreenSize(),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<Object?> snapshot,
        ) =>
            _getMainWidget(),
      );
    }
  }

  Widget _getMainWidget() => Material(
        color: Colors.transparent,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
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
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        child: Lottie.asset(
                          'packages/waiter/assets/loading.json',
                          animate: animationLoading,
                          delegates: LottieDelegates(
                            values: <ValueDelegate<dynamic>>[
                              ValueDelegate.colorFilter(
                                const <String>['icon', '**'],
                                value: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.src,
                                ),
                              ),
                              ValueDelegate.colorFilter(
                                const <String>['icon 2', '**'],
                                value: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.src,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: 280.w,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: <Widget>[
                                Lottie.asset(
                                  'packages/waiter/assets/error.json',
                                  repeat: false,
                                  animate: animationError,
                                  delegates: LottieDelegates(
                                    values: <ValueDelegate<dynamic>>[
                                      ValueDelegate.colorFilter(
                                        const <String>[
                                          'Rectangle 6 Copy',
                                          '**',
                                        ],
                                        value: ColorFilter.mode(
                                          Theme.of(context).colorScheme.primary,
                                          BlendMode.src,
                                        ),
                                      ),
                                      ValueDelegate.colorFilter(
                                        const <String>['Combined Shape', '**'],
                                        value: ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .background,
                                          BlendMode.src,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Visibility(
                                      visible: !isErrorWithoutOK,
                                      child: Flexible(
                                        flex: 2,
                                        child: Container(
                                          color: Colors.transparent,
                                          width: 90.w,
                                          child: TextButton(
                                            child: Text(
                                              globalWaiterLanguage.confirm,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            onPressed: () {
                                              widget.controller.hiddenLoading(
                                                widget.controller.model
                                                    .callBackTag,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: !isErrorWithoutOK,
                                      child: SizedBox(
                                        width: 30.w,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        color: Colors.transparent,
                                        width: widthTryError,
                                        child: TextButton(
                                          child: Text(
                                            globalWaiterLanguage.tryAgain,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          onPressed: () {
                                            if (tags.isEmpty) {
                                              throw ArgumentError(
                                                'tags is empty!',
                                              );
                                            }

                                            Set<String>.from(tags)
                                                .toList()
                                                .forEach((final String tag) {
                                              widget.onTry!.call(tag);
                                            });

                                            tags.clear();

                                            widget.controller.showLoading();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: isProgress,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: widget.onDismissProgress,
                child: Container(
                  height: widget.mainKey == null
                      ? null
                      : sizeHeight == 0
                          ? 0
                          : sizeHeight,
                  decoration: BoxDecoration(color: backgroundColor),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: SizedBox(
                          width: 280.w,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom: 5.h,
                                      top: 5.h,
                                    ),
                                    child: Text(
                                      globalWaiterLanguage.pleaseWait,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            end: 9,
                                          ),
                                          child: Text(
                                            '%$textPercent',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius: cardRadios,
                                                child: LinearProgressIndicator(
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
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (textTotal != '0' &&
                                            textTotal != '1')
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 9),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  '$textCurrent/',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.secondary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  textTotal,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.secondary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
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
                                      child: Text(
                                        globalWaiterLanguage.cancel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      onPressed: () {
                                        widget.onCancelProgress?.call(
                                          widget.controller.model.callBackTag,
                                        );
                                        setWidgetVisibility();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
