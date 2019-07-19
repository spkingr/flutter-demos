import 'package:flutter/material.dart';

class ScrollableTabsPage extends StatefulWidget{

  static const PAGE_NAME = "scrollable_tabs";

  @override
  _ScrollableTabsPageState createState() => _ScrollableTabsPageState();
}

class TabData{
  TabData({this.title, this.icon, this.content});

  TabData.generate(this.title, this.icon) : content = Icon(icon) ;

  final String title;
  final IconData icon;
  final Widget content;
}

class _ScrollableTabsPageState extends State<ScrollableTabsPage>{
  final _data = <TabData>[
    TabData.generate("Wifi", Icons.wifi),
    TabData.generate("Tethering", Icons.wifi_tethering),
    TabData.generate("OffLine", Icons.portable_wifi_off),
    TabData.generate("SignalBar", Icons.signal_wifi_4_bar),
    TabData.generate("Network", Icons.network_wifi),
    TabData.generate("Lock", Icons.wifi_lock),
    TabData.generate("Scan", Icons.perm_scan_wifi),
    TabData.generate("WifiOff", Icons.signal_wifi_off),
  ];

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: this._data.length,
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Scrollable Tabs"),
        bottom: TabBar(indicator: this._getIndicator(), isScrollable: true ,tabs: this._data.map((data) => this._buildTabBar(data)).toList(),),
      ),
      body: TabBarView(children: this._data.map((data) => this._buildTabContent(data)).toList(),),
    ),
  );

  ShapeDecoration _getIndicator() => ShapeDecoration(
      shape: const CircleBorder(side: BorderSide(color: Colors.yellow, width: 4.0)) + const CircleBorder(side: BorderSide(color: Colors.transparent, width: 4.0)),
  );
  Widget _buildTabContent(TabData data) => Center(child: Card(child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(data.icon, color: Colors.amber, size: 256.0,),),),);
  Widget _buildTabBar(TabData data) => Tab(icon: Icon(data.icon),);
}