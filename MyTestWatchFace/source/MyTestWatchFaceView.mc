import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.Time.Gregorian as Gregorian;

class MyTestWatchFaceView extends WatchUi.WatchFace {

    const UseInbuiltSensorCode = false;

    function initialize() {
        WatchFace.initialize();

        if (UseInbuiltSensorCode)
        {
            //System.enableSensorType(SENSOR_ONBOARD_PULSE_OXIMETRY);
            Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
            //Sensor.enableSensorEvents(method(:onSensor));
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);

        var view2 = View.findDrawableById("TopLeft") as Text;
        //view2.setText("T.Left");
        view2.setText("B: " + getBattery());

        var view3 = View.findDrawableById("TopRight") as Text;
        view3.setText("D: " + getDate());

        var view4 = View.findDrawableById("BottomLeft") as Text;
        view4.setText("S: " + getSteps());

        var view5 = View.findDrawableById("BottomRight") as Text;
        view5.setText("H: " + getHeartRate());

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    function getHeartRate() {
        var hrIterator = ActivityMonitor.getHeartRateHistory(1, true);
        var previous = hrIterator.next();

        if (previous == null || previous.heartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
            return "--";
        }
        return previous.heartRate.format("%02d");
    }

    function getBattery()
    {
        var stats = System.getSystemStats();
        var pwr = stats.battery;
        var batStr = Lang.format( "$1$%", [ pwr.format( "%2d" ) ] );
        return batStr;
    }

    function getSteps()
    {
        var stats = System.getSystemStats();
        //var steps = stats.stepCount;
        //var steps = stats.steps;
        //var steps = stats.step;

        //var steps = stats.distance; //.steps;

        // get ActivityMonitor info
        var info = ActivityMonitor.getInfo();
        //var steps = info.steps;
        //var calories = info.calories;



        //var steps = Activity.info.steps;
        //var z = Activity.info;
        //var steps =info.steps[0];
        //var x = info.steps.size();
        //var y = Toybox.Sensor.info;

        //return x;
        return;
    }

    function getDate()
    {
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$ $2$", [info.day_of_week, info.day]);
        return dateStr;
    }

    function onSensor(sensorInfo) {
        System.println("Heart Rate: " + sensorInfo.heartRate);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
