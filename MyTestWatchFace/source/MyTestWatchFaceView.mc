import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.Time.Gregorian as Gregorian;

class MyTestWatchFaceView extends WatchUi.WatchFace {

    const UseInbuiltSensorCode = false;
    const UseViewsAndLayout = false;
    const showRules = false; // Display horizontal test lines for alignment checking
    const offset = 15; // For graphic text drawing

    function initialize()
    {
        WatchFace.initialize();

        if (UseInbuiltSensorCode)
        {
            //System.enableSensorType(SENSOR_ONBOARD_PULSE_OXIMETRY);
            Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
            //Sensor.enableSensorEvents(method(:onSensor));
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void
    {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void
    {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void
    {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var battery = getBattery();
        var date = getDate();
        var steps = getSteps();
        var heartRate = getHeartRate();

        if (UseViewsAndLayout)
        {
            var view = View.findDrawableById("TimeLabel") as Text;
            view.setText(timeString);

            var view2 = View.findDrawableById("TopLeft") as Text;
            //view2.setText("T.Left");
            view2.setText("B: " + battery);

            var view3 = View.findDrawableById("TopRight") as Text;
            view3.setText("D: " + date);

            var view4 = View.findDrawableById("BottomLeft") as Text;
            view4.setText("S: " + steps);

            var view5 = View.findDrawableById("BottomRight") as Text;
            view5.setText("H: " + heartRate);

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        }
        else
        {
            // Screen size should be 240x240 (at least on Venu Sq)
            var screenWidth = dc.getWidth();
            var screenHeight = dc.getHeight();
            System.println("screenWidth " + screenWidth);
            System.println("screenHeight " + screenHeight);

            // Seem to need to do this first before anything else
            //dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_RED);
            //dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_ORANGE);
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();

            // Test lines at extremes
            if (showRules)
            {
                dc.setColor(Graphics.COLOR_PINK, Graphics.COLOR_TRANSPARENT);
                dc.clear();
                dc.setPenWidth(1);
                dc.drawLine(0,0,   240,0);
                dc.drawLine(0,120, 240,120);
                dc.drawLine(0,239, 240,239);
            }

            // test draw line
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(5);
            //dc.drawLine(5,5,25,25);
            //dc.drawRectangle(50, 50, 150, 100);
            //dc.drawText(100, 100, System.Graphics.FONT_SMALL, "test123", Graphics.TEXT_JUSTIFY_CENTER);
        
            //dc.drawText(screenWidth/2, screenHeight/2, Graphics.FONT_GLANCE_NUMBER, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            //dc.drawText(screenWidth/2, screenHeight/2, Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            //dc.drawText(screenWidth/2, screenHeight/2, Graphics.FONT_NUMBER_HOT, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(screenWidth/2, screenHeight/2, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
 
            dc.drawText(offset, offset, Graphics.FONT_SMALL, battery, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(screenWidth-offset, offset, Graphics.FONT_SMALL, date, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(offset, screenHeight-offset, Graphics.FONT_SMALL, steps, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(screenWidth-offset, screenHeight-offset, Graphics.FONT_SMALL, heartRate, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        }
     }

    function getHeartRate() 
    {
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
        return "--";
    }

    function getDate()
    {
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$ $2$", [info.day_of_week, info.day]);
        return dateStr;
    }

    function onSensor(sensorInfo)
    {
        System.println("Heart Rate: " + sensorInfo.heartRate);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void
    {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void
    {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void
    {
    }

}
