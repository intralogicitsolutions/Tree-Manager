import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ProgressDialogType { Normal, Download }

class ProgressDialog {
  final BuildContext context;
  final ProgressDialogType type;
  final bool isDismissible;
  final bool showLogs;

  String _dialogMessage = "Loading...";
  double _progress = 0.0;
  double _maxProgress = 100.0;
  bool _isShowing = false;

  TextStyle _progressTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
  );
  TextStyle _messageStyle = const TextStyle(
    color: Colors.black,
    fontSize: 19.0,
    fontWeight: FontWeight.w600,
  );

  double _dialogElevation = 8.0;
  double _borderRadius = 8.0;
  Color _backgroundColor = Colors.white;
  Curve _insetAnimCurve = Curves.easeInOut;

  Widget _progressWidget = Image.asset(
    'assets/double_ring_loading_io.gif',
    package: 'progress_dialog',
  );

  late BuildContext _dismissingContext;
  late _Body _dialog;

  ProgressDialog(
    this.context, {
    this.type = ProgressDialogType.Normal,
    this.isDismissible = true,
    this.showLogs = false,
  });

  void style({
    double? progress,
    double? maxProgress,
    String? message,
    Widget? progressWidget,
    Color? backgroundColor,
    TextStyle? progressTextStyle,
    TextStyle? messageTextStyle,
    double? elevation,
    double? borderRadius,
    Curve? insetAnimCurve,
  }) {
    if (_isShowing) return;
    if (type == ProgressDialogType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _backgroundColor = backgroundColor ?? _backgroundColor;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;
    _dialogElevation = elevation ?? _dialogElevation;
    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;
  }

  void update({
    double? progress,
    double? maxProgress,
    String? message,
    Widget? progressWidget,
    TextStyle? progressTextStyle,
    TextStyle? messageTextStyle,
  }) {
    if (type == ProgressDialogType.Download) {
      _progress = progress ?? _progress;
    }

    _dialogMessage = message ?? _dialogMessage;
    _maxProgress = maxProgress ?? _maxProgress;
    _progressWidget = progressWidget ?? _progressWidget;
    _messageStyle = messageTextStyle ?? _messageStyle;
    _progressTextStyle = progressTextStyle ?? _progressTextStyle;

    if (_isShowing) _dialog.update();
  }

  bool isShowing() {
    return _isShowing;
  }

  void dismiss() {
    if (_isShowing) {
      try {
        _isShowing = false;
        if (Navigator.of(_dismissingContext).canPop()) {
          Navigator.of(_dismissingContext).pop();
          if (showLogs) debugPrint('ProgressDialog dismissed');
        } else {
          if (showLogs) debugPrint('Cannot pop ProgressDialog');
        }
      } catch (_) {}
    } else {
      if (showLogs) debugPrint('ProgressDialog already dismissed');
    }
  }

  Future<bool> hide() async {
    if (_isShowing) {
      try {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop(true);
        if (showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } catch (_) {
        return Future.value(false);
      }
    } else {
      if (showLogs) debugPrint('ProgressDialog already dismissed');
      return Future.value(false);
    }
  }

  Future<bool> show() async {
    if (!_isShowing) {
      try {
        _isShowing = true;
        _dialog = _Body(
          progressDialogType: type,
          dialogMessage: _dialogMessage,
          progressWidget: _progressWidget,
          messageStyle: _messageStyle,
          progressTextStyle: _progressTextStyle,
          progress: _progress,
          maxProgress: _maxProgress,
        );
        showDialog<dynamic>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              onWillPop: () async => isDismissible,
              child: Dialog(
                backgroundColor: _backgroundColor,
                insetAnimationCurve: _insetAnimCurve,
                insetAnimationDuration: const Duration(milliseconds: 100),
                elevation: _dialogElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
                ),
                child: _dialog,
              ),
            );
          },
        );
        await Future.delayed(const Duration(milliseconds: 200));
        if (showLogs) debugPrint('ProgressDialog shown');

        return true;
      } catch (_) {
        return false;
      }
    } else {
      if (showLogs) debugPrint("ProgressDialog already shown/showing");
      return false;
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  final ProgressDialogType progressDialogType;
  final String dialogMessage;
  final Widget progressWidget;
  final TextStyle messageStyle;
  final TextStyle progressTextStyle;
  final double progress;
  final double maxProgress;

  _Body({
    required this.progressDialogType,
    required this.dialogMessage,
    required this.progressWidget,
    required this.messageStyle,
    required this.progressTextStyle,
    required this.progress,
    required this.maxProgress,
  });

  final _BodyState _dialog = _BodyState();

  void update() {
    _dialog.update(
      progressDialogType,
      dialogMessage,
      progressWidget,
      messageStyle,
      progressTextStyle,
      progress,
      maxProgress,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  late ProgressDialogType _progressDialogType;
  late String _dialogMessage;
  late Widget _progressWidget;
  late TextStyle _messageStyle;
  late TextStyle _progressTextStyle;
  late double _progress;
  late double _maxProgress;

  @override
  void initState() {
    super.initState();
    _progressDialogType = widget.progressDialogType;
    _dialogMessage = widget.dialogMessage;
    _progressWidget = widget.progressWidget;
    _messageStyle = widget.messageStyle;
    _progressTextStyle = widget.progressTextStyle;
    _progress = widget.progress;
    _maxProgress = widget.maxProgress;
  }

  void update(
    ProgressDialogType progressDialogType,
    String dialogMessage,
    Widget progressWidget,
    TextStyle messageStyle,
    TextStyle progressTextStyle,
    double progress,
    double maxProgress,
  ) {
    setState(() {
      _progressDialogType = progressDialogType;
      _dialogMessage = dialogMessage;
      _progressWidget = progressWidget;
      _messageStyle = messageStyle;
      _progressTextStyle = progressTextStyle;
      _progress = progress;
      _maxProgress = maxProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10.0),
          SizedBox(
            width: 60.0,
            height: 60.0,
            child: _progressWidget,
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: _progressDialogType == ProgressDialogType.Normal
                ? Text(
                    _dialogMessage,
                    textAlign: TextAlign.justify,
                    style: _messageStyle,
                  )
                : Stack(
                    children: <Widget>[
                      Positioned(
                        top: 30.0,
                        child: Text(
                          _dialogMessage,
                          style: _messageStyle,
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 10.0,
                        child: Text(
                          "$_progress/$_maxProgress",
                          style: _progressTextStyle,
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }
}
