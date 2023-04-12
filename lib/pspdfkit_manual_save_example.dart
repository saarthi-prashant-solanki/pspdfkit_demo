///
///  Copyright © 2022 PSPDFKit GmbH. All rights reserved.
///
///  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
///  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
///  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
///  This notice may not be removed from this file.
///

import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import 'package:pspdfkit_flutter/widgets/pspdfkit_widget_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/platform_utils.dart';

class PspdfkitManualSaveExampleWidget extends StatefulWidget {
  final String documentPath;
  final dynamic configuration;

  const PspdfkitManualSaveExampleWidget({Key? key, required this.documentPath, this.configuration}) : super(key: key);

  @override
  _PspdfkitManualSaveExampleWidgetState createState() => _PspdfkitManualSaveExampleWidgetState();
}

class _PspdfkitManualSaveExampleWidgetState extends State<PspdfkitManualSaveExampleWidget> {
  late PspdfkitWidgetController pspdfkitWidgetController;

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'com.pspdfkit.widget';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'document': widget.documentPath,
      'configuration': widget.configuration,
    };
    if (PlatformUtils.isCurrentPlatformSupported()) {
      return Scaffold(
        extendBodyBehindAppBar: PlatformUtils.isAndroid(),
        appBar: AppBar(),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            padding: PlatformUtils.isIOS() ? null : const EdgeInsets.only(top: kToolbarHeight),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PlatformUtils.isAndroid()
                      ? PlatformViewLink(
                          viewType: viewType,
                          surfaceFactory: (BuildContext context, PlatformViewController controller) {
                            return AndroidViewSurface(
                              controller: controller as AndroidViewController,
                              gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
                              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                            );
                          },
                          onCreatePlatformView: (PlatformViewCreationParams params) {
                            return PlatformViewsService.initSurfaceAndroidView(
                              id: params.id,
                              viewType: viewType,
                              layoutDirection: TextDirection.ltr,
                              creationParams: creationParams,
                              creationParamsCodec: const StandardMessageCodec(),
                              onFocus: () async {
                                params.onFocusChanged(true);
                              },
                            )
                              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                              ..addOnPlatformViewCreatedListener(onPlatformViewCreated)
                              ..create();
                          },
                        )
                      : UiKitView(
                          viewType: viewType,
                          layoutDirection: TextDirection.ltr,
                          creationParams: creationParams,
                          onPlatformViewCreated: onPlatformViewCreated,
                          creationParamsCodec: const StandardMessageCodec(),
                        ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     bool? isSave = await pspdfkitWidgetController.save();
                      //     print('IS Save Document: $isSave');
                      //   },
                      //   child: const Text('Save Document'),
                      // ),
                      ElevatedButton(
                        onPressed: () async {
                          String? annotationsJSON = await pspdfkitWidgetController.exportInstantJson();
                          log(annotationsJSON!);
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          bool isSave = await prefs.setString('Annotation', annotationsJSON);
                          log('Save Anotation: $isSave');
                        },
                        child: const Text('Save'),
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     final SharedPreferences prefs = await SharedPreferences.getInstance();
                      //     final String? annotationsJson = prefs.getString('Annotation');
                      //     Log.log('Saved Anotation: $annotationsJson');
                      //     await pspdfkitWidgetController.applyInstantJson(annotationsJson!);
                      //   },
                      //   child: const Text('Load Anotation'),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Text('$defaultTargetPlatform is not yet supported by PSPDFKit for Flutter.');
    }
  }

  Future<void> onPlatformViewCreated(int id) async {
    pspdfkitWidgetController = PspdfkitWidgetController(id);
    Future.delayed(const Duration(milliseconds: 500)).then((value) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? annotationsJson = prefs.getString('Annotation');
      if (annotationsJson != null) {
        await pspdfkitWidgetController.applyInstantJson(annotationsJson);
      }
    });
  }
}
