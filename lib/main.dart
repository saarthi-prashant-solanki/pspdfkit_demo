import 'package:flutter/material.dart';
import 'package:pspdfdemo/pspdfkit_manual_save_example.dart';
import 'package:pspdfdemo/utils/file_utils.dart';
import 'package:pspdfdemo/utils/platform_utils.dart';
import 'package:pspdfkit_flutter/pspdfkit.dart';
import 'package:pspdfkit_flutter/widgets/pspdfkit_widget.dart';
import 'package:pspdfkit_flutter/widgets/pspdfkit_widget_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const String _documentPath = 'PDFs/Algebra.pdf';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late PspdfkitWidgetController view;

  void showDocument() async {
    final extractedDocument = await extractAsset(context, _documentPath);
    await Navigator.of(context).push<dynamic>(
      MaterialPageRoute<dynamic>(
        builder: (_) => Scaffold(
          extendBodyBehindAppBar: PlatformUtils.isAndroid(),
          resizeToAvoidBottomInset: PlatformUtils.isIOS(),
          appBar: AppBar(),
          body: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              padding: PlatformUtils.isCupertino(context) ? null : const EdgeInsets.only(top: kToolbarHeight),
              child: PspdfkitWidget(
                documentPath: extractedDocument.path,
                configuration: const {
                  disableAutosave: true,
                  scrollDirection: 'vertical',
                  pageTransition: 'scrollContinuous',
                  spreadFitting: 'fit',
                  immersiveMode: false,
                  userInterfaceViewMode: 'automaticBorderPages',
                  androidShowSearchAction: false,
                  inlineSearch: false,
                  showThumbnailBar: 'floating',
                  androidShowThumbnailGridAction: false,
                  androidShowOutlineAction: false,
                  androidShowAnnotationListAction: false,
                  showPageLabels: true,
                  documentLabelEnabled: false,
                  invertColors: false,
                  androidGrayScale: false,
                  startPage: 0,
                  enableAnnotationEditing: true,
                  enableTextSelection: false,
                  androidShowBookmarksAction: false,
                  androidEnableDocumentEditor: false,
                  androidShowShareAction: true,
                  androidShowPrintAction: false,
                  androidShowDocumentInfoView: true,
                  appearanceMode: 'default',
                  androidDefaultThemeResource: 'PSPDFKit.Theme.Example',
                  iOSRightBarButtonItems: ['thumbnailsButtonItem', 'activityButtonItem', 'searchButtonItem', 'annotationButtonItem'],
                  iOSLeftBarButtonItems: ['settingsButtonItem'],
                  iOSAllowToolbarTitleChange: false,
                  toolbarTitle: 'Custom Title',
                  settingsMenuItems: [
                    'pageTransition',
                    'scrollDirection',
                    'androidTheme',
                    'iOSAppearance',
                    'androidPageLayout',
                    'iOSPageMode',
                    'iOSSpreadFitting',
                    'androidScreenAwake',
                    'iOSBrightness'
                  ],
                  showActionNavigationButtons: false,
                  pageMode: 'double',
                  firstPageAlwaysSingle: true
                },
                onPspdfkitWidgetCreated: (view) async {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final extractedWritableDocument = await extractAsset(context, _documentPath, shouldOverwrite: false, prefix: 'persist');
            await Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                builder: (_) => PspdfkitManualSaveExampleWidget(
                  documentPath: extractedWritableDocument.path,
                  configuration: const {
                    startPage: 0,
                    disableAutosave: true,
                    documentLabelEnabled: false,
                    appearanceMode: 'default',
                    showThumbnailBar: 'floating',
                    androidShowThumbnailGridAction: false,
                    androidShowOutlineAction: false,
                    androidShowAnnotationListAction: false,
                    androidShowBookmarksAction: false,
                    androidEnableDocumentEditor: false,
                    androidShowShareAction: false,
                    androidShowPrintAction: false,
                    androidShowDocumentInfoView: false,
                    androidDefaultThemeResource: 'PSPDFKit.Theme.Example',
                    androidShowSearchAction: false,
                    inlineSearch: false,
                    showActionNavigationButtons: true,
                    settingsMenuItems: [],
                  },
                ),
              ),
            );
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }

  Future<void> onPlatformViewCreated(int id) async {
    view = PspdfkitWidgetController(id);
  }
}
