import 'dart:async';

import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:flutter_picker/flutter_picker.dart';

import '../../services/auth_service.dart';
import '../../services/driver_service.dart';
import '../../services/routes_service.dart';
import '../../services/service_exception.dart';

import '../../widgets/toast.dart';
import '../../widgets/block_ui.dart';

import '../../utils/mask.dart';
import '../../provider/driver_provider.dart';
import '../../models/itinerary.dart';
import '../../environments/environment.dart';
import '../chat.dart';
import './home_driver_tab.dart';

class MainDriverTab extends StatefulWidget {
  @override
  _MainDriverTabState createState() => _MainDriverTabState();
}

class _MainDriverTabState extends State<MainDriverTab>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final DriverService _driverService = DriverService();
  final RoutesService _routesService = RoutesService();

  final CustomMask _customMask = CustomMask();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Toast _toast = Toast();

  StreamController<bool> _blockUIStream;
  TabController _tabController;
  List<Widget> _myTabs;

  @override
  void initState() {
    _blockUIStream = StreamController.broadcast();
    _myTabs = [HomeDriverPage(_blockUIStream), ChatScreen()];
    _tabController =
        TabController(length: _myTabs.length, initialIndex: 0, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _blockUIStream.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  DefaultTabController build(BuildContext context) {
    return DefaultTabController(
      length: _myTabs.length,
      child: BlockUI(
        blockUIController: _blockUIStream,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              Environment.APP_NAME,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            backgroundColor: Colors.transparent,
            actionsIconTheme: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor,
            ),
            elevation: 0,
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                  onTap: _onSharingDriverCode,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.share),
                  label: 'Compartilhar Código'),
              SpeedDialChild(
                  onTap: _onCreatingItinerary,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.add),
                  label: 'Novo itinerário'),
              SpeedDialChild(
                  onTap: _logout,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close),
                  label: 'Sair')
            ],
          ),
          bottomNavigationBar: _buildTabBar(context),
          body: TabBarView(
            controller: _tabController,
            dragStartBehavior: DragStartBehavior.down,
            children: _myTabs,
          ),
        ),
      ),
    );
  }

  TabBar _buildTabBar(BuildContext context) => TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Tab(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Tab(
            icon: Icon(
              Icons.chat,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      );

  bool _isSharing(final List<Itinerary> list) =>
      list.any((item) => item.isAtivo == true);

  void _onStarDriving(final List<Itinerary> list) {
    final Picker picker = Picker(
        onConfirm: (one, two) => _onItinerarySelected(one, list[two.first]),
        confirmText: 'Confirmar',
        cancelText: 'Cancelar',
        adapter: PickerDataAdapter(
            data: list
                .map((item) => PickerItem(
                      text: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: item.description,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                            TextSpan(
                              text: ' | ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                            TextSpan(
                              text: DecodeItineraryTypeEnum.getDescription(
                                  item.type),
                              style: TextStyle(
                                color:
                                    DecodeItineraryTypeEnum.getColor(item.type),
                                fontSize: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList()));
    picker.show(_scaffoldKey.currentState);
  }

  void _onItinerarySelected(final Picker picker, final Itinerary itinerary) {
    try {
      final DriverProvider driverProvider =
          Provider.of<DriverProvider>(context);
      picker.doCancel(context);
      _driverService.initItinerary(
          context, driverProvider, itinerary, _blockUIStream);
    } on ServiceException catch (err) {
      _toast.show(err.msg, _scaffoldKey.currentState.context);
    }
  }

  _onSharingDriverCode() async {
    try {
      final String code = await _driverService.findMyCode();
      WcFlutterShare.share(
        sharePopupTitle: 'Compartilhar via',
        text: code,
        mimeType: 'text/plain',
      ).catchError((err) {
        _toast.show('Não foi possivel compartilhar seu código', context);
        Catcher.reportCheckedError(err,
            'NoStackTrace | method: _onSharingDriverCode - class MainDriverTab');
      });
    } on ServiceException catch (err) {
      _toast.show(err.msg, context);
    }
  }

  Future<void> _onCreatingItinerary() async {
    try {
      final children = await _driverService.findMyChildren();
      _routesService.goToItineraryFormPage(context, children);
    } on ServiceException catch (err) {
      _toast.show(err.msg, _scaffoldKey.currentState.context);
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout(_scaffoldKey.currentState.context);
    } on ServiceException catch (err) {
      _toast.show(err.msg, _scaffoldKey.currentState.context);
    }
  }
}
