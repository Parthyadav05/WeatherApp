import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlanCardComponent extends StatefulWidget {
  final weatherData;

  const PlanCardComponent({Key? key, required this.weatherData}) : super(key: key);

  @override
  State<PlanCardComponent> createState() => _PlanCardComponentState();
}

class _PlanCardComponentState extends State<PlanCardComponent>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _radialProgressAnimationController;
  late Animation<double> _progressAnimation;
  final Duration fillDuration = const Duration(seconds: 2);

  double progressDegrees = 0;
  final double goalCompleted = 0.7;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController = AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0)
        .animate(CurvedAnimation(parent: _radialProgressAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = goalCompleted * _progressAnimation.value;
        });
      });

    _radialProgressAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var temp = widget.weatherData.main?.temp;
    temp = (temp - 273).toInt();

    super.build(context);
    double humidity = widget.weatherData.main?.humidity?.toDouble() ?? 0.0;
    double humidityInDegrees = humidity * 3.6; // Convert percentage to degrees (0-100% -> 0-360 degrees)

    return Container(
      width: 280,
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [ Color.fromRGBO(137,207,240,1),Colors.black]),
        color: Colors.purple,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.location_on,color: Colors.red,),
                    title: Text('${widget.weatherData.name}', style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.temperatureArrowUp),
                    title: Text('${temp} °C', style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud,color: Colors.blue,),
                    title: Text('${widget.weatherData.weather?.first.main}', style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind,color: Colors.indigo,),
                    title: Text('${widget.weatherData.wind?.speed} m/s', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              width: 150,
              child: CustomPaint(
                painter: RadialPainter(humidityInDegrees),
                child: Center(
                  child: AnimatedOpacity(
                    opacity: progressDegrees > 30 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      "${humidity.toInt()}%",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            )
          ],)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }
}

class RadialPainter extends CustomPainter {
  double progressInDegrees;

  RadialPainter(this.progressInDegrees);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..shader = const LinearGradient(colors: [Colors.deepPurple, Colors.purple, Colors.purpleAccent])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2), -90 * (math.pi / 180.0),
        progressInDegrees * (math.pi / 180.0), false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
