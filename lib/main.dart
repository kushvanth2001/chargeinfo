import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:chargeinfo/tempraturegauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:thermal/thermal.dart';

import 'batterydata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charging Info',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue,
        brightness: Brightness.dark),
        useMaterial3: true,
      ),

      theme: ThemeData(
      brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final BatteryInfoPlugin _batteryInfoPlugin = BatteryInfoPlugin();
     int batcap=0;
       Thermal _thermal = Thermal();
  double _batteryTemperature = 0.0;

  @override
  void initState() {
    super.initState();
    _getBatteryCapacity();

  }
  

 
  Future<void> _getBatteryCapacity() async {
    try {
      print(await _thermal.thermalStatus);
      final  batteryInfo = await _batteryInfoPlugin.androidBatteryInfo;
       int? batteryCapacity = batteryInfo!.batteryCapacity;

       setState(() {
      batcap=batteryCapacity!;
    });
    } catch (e) {
      print('Failed to get battery capacity: $e');
    }

    setState(() {
      
    });
  }


final int _healthpointer=0;


double getHealthValue(String health) {
  switch (health) {
    case 'HEALTH_GOOD':
      return 56.0;
    case 'HEALTH_POOR':
      return 20.0;
    case 'HEALTH_GREAT':
      return 80.0;
    default:
      return 0; // Default value if the health string does not match any condition
  }
}



  @override
  Widget build(BuildContext context) {
  var _thermal = Thermal();

    List<BatteryData> batteryData = [
  BatteryData('Initial',3000 ),
  BatteryData('Current', batcap/1000),
];
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Charging Info'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.info)),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: 
           
            StreamBuilder<AndroidBatteryInfo?>(
              stream: BatteryInfoPlugin().androidBatteryInfoStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return 
                   Column(
                     children: [
                      StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 1,
            axisDirection:AxisDirection.down,
                    children: [
            StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child:
             Container(
              margin: EdgeInsets.only(top: 80),
               child: Card(
                
                elevation: 4,
                 child: Container(
                  
                  decoration: BoxDecoration(borderRadius:BorderRadius.circular(20), color: ThemeData().colorScheme.primary, ),
                
                        
                          width: MediaQuery.of(context).size.width*100,
                                child:snapshot.data!.chargingStatus.toString().split(".")[1]=='Charging'?
                                     Center(
                                       child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                     
                                           Center(child: Text(" ${(snapshot.data!.currentNow!< 0?(snapshot.data!.currentNow!*-1/1000):(snapshot.data!.currentNow!/1000)).ceil()} mA",style: TextStyle(fontSize: 45))),
                                         
                                        
                                           Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Text("Voltage: ${(snapshot.data!.voltage!/1000)} V",style: TextStyle(fontSize: 25)),
                                           ),
                     Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Text("Charge time remaining: ${(snapshot.data!.chargeTimeRemaining! / 1000 / 60/60).truncate()} hours ${(snapshot.data!.chargeTimeRemaining! / 1000 / 60%60).truncate()} minutes",style: TextStyle(fontSize: 17),)
                                           ),
                                         ],
                                       ),
                                     ):SpinKitWaveSpinner(size: 250,color: Colors.blue.withOpacity(0.7))),
               ),
             ),
                     ),
                  
                          StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child   :Card(
                        elevation: 4.0,
                        child:  Column(
                              children: [
                            
                                Text(
                                  "Battery Level: ${(snapshot!.data!.batteryLevel)} %",
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: CircularPercentIndicator(
                                    radius: 60.0,
                                    lineWidth: 6.0,
                                    percent: snapshot!.data!.batteryLevel! * 0.01,
                                    center: Text(
                                      snapshot!.data!.batteryLevel.toString(),
                                    ),
                                    progressColor:snapshot.data!.chargingStatus.toString().split(".")[1]=='Charging'? Colors.green:Colors.green.withOpacity(0.5)
                                  ),
                                ),
                              ],
                            ),),),
                     
                  
                           StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child   :    Card(
                        elevation: 4.0,
                        child: Column(
                          children: [
            
                            Container(child: TemperatureWidget()),
                          ],
                        ))),
                         
                    StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 0.7,
                child: Card(
                                                    elevation: 4.0,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:EdgeInsets.only(bottom: 3),
                                                          child: Text(
                                                            
                                                                                        "Charging status: ${(snapshot.data!.chargingStatus.toString().split(".")[1])}",),
                                                        ),
                                                 snapshot.data!.chargingStatus.toString().split(".")[1]=='Charging'?Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Image.asset('assets/images/k.gif',width: 140,),
                                  ) :
                                        
                                          Image(image:   AssetImage('assets/images/u.png',),height: 70,color: Colors.blue,)
                                                      ],
                                                    )
                              ),
                            ),
                                      StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 0.7,
                child   :Card(
                        elevation: 4.0,
                        child:  Column(
                          children: [
                            Text(
                                  "Battery Capacity: ${(snapshot.data!.batteryCapacity! / 1000)} mAh",
                                ),
                        Container(
                          width: 170,
                          height: 80,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
            BarSeries<BatteryData, String>(
              dataSource: batteryData,
              xValueMapper: (BatteryData data, _) => data.label,
              yValueMapper: (BatteryData data, _) => data.value,
            ),
                    ],
                  ),
                ),  ],
                        ),),),
                         
                         
                                       StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 0.7,
                child   : Card(
                        elevation: 4.0,
                        child:Column(
                          children: [
                            Text(
                                  "Battery present: ${snapshot.data!.present! ? "Yes" : "False"}",
                                ),
                      Image.asset('assets/images/8604736.png',height: 70,width: 70,color: Colors.green,)
                      
                          ],
                        ),),),
                  
                                
              
            FutureBuilder<AndroidBatteryInfo?>(
              future: BatteryInfoPlugin().androidBatteryInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
            return            StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 0.7,
                child   : Card(
            elevation: 4.0,
            child:   Column(
            
                              children: [
            
                                Text("Battery condition:"),
            
                                Text(snapshot.data!.health!.toUpperCase()),
                                 Container(
                                  width: 80,
                                  height: 80,
                                   child:SfRadialGauge(
                axes:<RadialAxis>[
                  RadialAxis(showLabels: false, showAxisLine: false, showTicks: false,
                      minimum: 0, maximum: 99, 
                      ranges: <GaugeRange>[GaugeRange(startValue: 0, endValue: 33,
                          color: Color(0xFFFE2A25), label: 'Poor',
                          sizeUnit: GaugeSizeUnit.factor,
                          labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:  10),
                          startWidth: 0.65, endWidth: 0.65
                      ),GaugeRange(startValue: 33, endValue: 66,
                        color:Color(0xFFFFBA00), label: 'good',
                        labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   10),
                        startWidth: 0.65, endWidth: 0.65, sizeUnit: GaugeSizeUnit.factor,
                      ),
                        GaugeRange(startValue: 66, endValue: 99,
                          color:Color(0xFF00AB47), label: 'great',
                          labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   10),
                          sizeUnit: GaugeSizeUnit.factor,
                          startWidth: 0.65, endWidth: 0.65,
                        ),
            
                      ],
                      pointers: <GaugePointer>[NeedlePointer( lengthUnit: GaugeSizeUnit.logicalPixel,
            
                    needleLength: 30,
                         enableAnimation : false,
             animationDuration : 1000,
             needleEndWidth:  5,
            animationType : AnimationType.ease,
            
                        tailStyle: TailStyle(width: 0.01),
                        value: getHealthValue(snapshot.data!.health!.toUpperCase())
                    )]
                  )
                ],
              )
                                 ),
            
                              ],
            
            ),
            ));
            
                }
                return CircularProgressIndicator();
                })
            
            
                                    , StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 0.7,
                child   :  Card(
                        elevation: 4.0,
                        child: Text(
                              "Remaining energy: ${-(snapshot.data!.remainingEnergy! * 1.0E-9)} Watt-hours",
                            ),),
                            
                            
                            ),
            
                                    StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 0.7,
                child   :   Card(
                        elevation: 4.0,
                        child: Text("Technology: ${(snapshot.data!.technology)}"),),),
            
            
            
                      
              
                  ]),
                     ],
                   );
                }
                return CircularProgressIndicator();
              },
            ),
          
        
      ),
    );
  }
}
