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

  const PspdfkitManualSaveExampleWidget({Key? key, required this.documentPath, this.configuration})
      : super(key: key);

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
                ElevatedButton(
                  onPressed: () async {
                    // String? annotationsJSON = await pspdfkitWidgetController.exportInstantJson();
                    // log(annotationsJSON!);
                    // final SharedPreferences prefs = await SharedPreferences.getInstance();
                    // bool isSave = await prefs.setString('Annotation', annotationsJSON);
                    // log('Save Anotation: $isSave');
                  },
                  child: const Text('Save'),
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
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // final String? annotationsJson = prefs.getString('Annotation');
      // if (annotationsJson != null) {
      //   await pspdfkitWidgetController.applyInstantJson(annotationsJson);
      // }
      addAnnotation();
    });
  }

  Future<void> addAnnotation() async {
    dynamic annotationText = {
      "v": 1,
      "pageIndex": 0,
      "bbox": [150, 250, 150, 100],
      "opacity": 1,
      "pdfObjectId": 200,
      "creatorName": "John Doe",
      "createdAt": "2012-04-23T18:25:43.511Z",
      "updatedAt": "2012-04-23T18:28:05.100Z",
      "id": "01F46S31WM8Q46MP3T0BAJ0F85",
      "name": "01F46S31WM8Q46MP3T0BAJ0F85",
      "type": "pspdfkit/text",
      "text": "Content for a text annotation",
      "fontSize": 14,
      "fontStyle": ["bold"],
      "fontColor": "#000000",
      "horizontalAlign": "left",
      "verticalAlign": "center",
      "rotation": 0
    };
    dynamic annotationStamp = {
      "v": 1,
      "pageIndex": 0,
      "bbox": [20, 250, 150, 100],
      "opacity": 1,
      "pdfObjectId": 300,
      "creatorName": "John Doe",
      "createdAt": "2020-05-23T18:25:43.511Z",
      "updatedAt": "2020-06-23T18:28:05.100Z",
      "id": "01F46S31WM8Q46MP3T0BAJ0F8F",
      "name": "01F46S31WM8Q46MP3T0BAJ0F8F",
      "type": "pspdfkit/stamp",
      "stampType": "Approved",
      "title": " Approved ",
      "color": "#122241",
      "rotation": 0
    };
    dynamic annotationRectangle = {
      "v": 1,
      "pageIndex": 0,
      "bbox": [294.62025146484376, 314.54970703124997, 54.55937499999999, 23.603906250000023],
      "opacity": 1,
      "pdfObjectId": 300,
      "creatorName": "John Doe",
      "createdAt": "2012-05-23T18:25:43.511Z",
      "updatedAt": "2012-06-23T18:28:05.100Z",
      "id": "01F46S31WM8Q46MP3T0BAJ0F88",
      "name": "01F46S31WM8Q46MP3T0BAJ0F88",
      "type": "pspdfkit/shape/rectangle",
      // "strokeDashArray": [3, 3],
      "strokeWidth": 2,
      "strokeColor": "#000000"
    };
    await pspdfkitWidgetController.addAnnotation(annotationRectangle);
  }
}
