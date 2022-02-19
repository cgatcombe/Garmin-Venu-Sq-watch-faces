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
    const showColorBoxes = true; // Shows boxes with all the colours for testing

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
            dc.drawText(screenWidth/2, screenHeight/2 -50, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
 
            dc.drawText(offset, offset, Graphics.FONT_SMALL, battery, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(screenWidth-offset, offset, Graphics.FONT_SMALL, date, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(offset, screenHeight-offset, Graphics.FONT_SMALL, steps, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(screenWidth-offset, screenHeight-offset, Graphics.FONT_SMALL, heartRate, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        
            if (showColorBoxes)
            {
                drawBox(dc, 10, 30, 15, Graphics.COLOR_BLACK);
                drawBox(dc, 30, 30, 15, Graphics.COLOR_BLUE);
                drawBox(dc, 50, 30, 15, Graphics.COLOR_DK_BLUE);
                drawBox(dc, 70, 30, 15, Graphics.COLOR_DK_GRAY);
                drawBox(dc, 90, 30, 15, Graphics.COLOR_DK_GREEN);
                drawBox(dc, 110, 30, 15, Graphics.COLOR_DK_RED);
                drawBox(dc, 130, 30, 15, Graphics.COLOR_GREEN);
                drawBox(dc, 150, 30, 15, Graphics.COLOR_LT_GRAY);
                drawBox(dc, 170, 30, 15, Graphics.COLOR_ORANGE);
                drawBox(dc, 190, 30, 15, Graphics.COLOR_PINK);
                drawBox(dc, 210, 30, 15, Graphics.COLOR_PURPLE);
                drawBox(dc, 10, 60, 15, Graphics.COLOR_RED);
                drawBox(dc, 30, 60, 15, Graphics.COLOR_TRANSPARENT);
                drawBox(dc, 50, 60, 15, Graphics.COLOR_WHITE);
                drawBox(dc, 70, 60, 15, Graphics.COLOR_YELLOW);
            }

            drawLED(dc, 0, 10, 100);
            drawLED(dc, 1, 60, 100);
            drawLED(dc, 2, 110, 100);
            drawLED(dc, 3, 160, 100);
            drawLED(dc, 4, 210, 100);
            drawLED(dc, 5, 10, 160);
            drawLED(dc, 6, 60, 160);
            drawLED(dc, 7, 110, 160);
            drawLED(dc, 8, 160, 160);
            drawLED(dc, 9, 210, 160);
        }
    }

    function drawBox(dc, x, y, size, colour)
    {
        dc.setColor(colour, Graphics.COLOR_TRANSPARENT);
        // Draw box outline
        //dc.setPenWidth(7);
        //dc.drawRectangle(x, y, size, size);
        // Draw filled box
        dc.fillRectangle(x, y, size, size);
    }

    function drawLED(dc, digit, x, y)
    {
        var w=20;
        var h=40;
        var gap=2;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawRectangle(x, y, w, h);

        var aSegment as Lang.Boolean = false;
        var bSegment as Lang.Boolean = false;
        var cSegment as Lang.Boolean = false;
        var dSegment as Lang.Boolean = false;
        var eSegment as Lang.Boolean = false;
        var fSegment as Lang.Boolean = false;
        var gSegment as Lang.Boolean = false;

        if (digit == 0)
        {
            aSegment = true;
            bSegment = true;
            cSegment = true;
            dSegment = true;
            eSegment = true;
            fSegment = true;
            gSegment = false;
        }
        else if (digit == 1)
        {
            aSegment = false;
            bSegment = true;
            cSegment = true;
            dSegment = false;
            eSegment = false;
            fSegment = false;
            gSegment = false;
        }
        else if (digit == 2)
        {
            aSegment = true;
            bSegment = true;
            cSegment = false;
            dSegment = true;
            eSegment = true;
            fSegment = false;
            gSegment = true;
        }
        else if (digit == 3)
        {
            aSegment = true;
            bSegment = true;
            cSegment = true;
            dSegment = true;
            eSegment = false;
            fSegment = false;
            gSegment = true;
        }
        else if (digit == 4)
        {
            aSegment = false;
            bSegment = true;
            cSegment = true;
            dSegment = false;
            eSegment = false;
            fSegment = true;
            gSegment = true;
        }
        else if (digit == 5)
        {
            aSegment = true;
            bSegment = false;
            cSegment = true;
            dSegment = true;
            eSegment = false;
            fSegment = true;
            gSegment = true;
        }
        else if (digit == 6)
        {
            aSegment = true;
            bSegment = false;
            cSegment = true;
            dSegment = true;
            eSegment = true;
            fSegment = true;
            gSegment = true;
        }
        else if (digit == 7)
        {
            aSegment = true;
            bSegment = true;
            cSegment = true;
            dSegment = false;
            eSegment = false;
            fSegment = false;
            gSegment = false;
        }
        else if (digit == 8)
        {
            aSegment = true;
            bSegment = true;
            cSegment = true;
            dSegment = true;
            eSegment = true;
            fSegment = true;
            gSegment = true;
        }
        else if (digit == 9)
        {
            aSegment = true;
            bSegment = true;
            cSegment = true;
            dSegment = true;
            eSegment = false;
            fSegment = true;
            gSegment = true;
        }

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        if (aSegment) {
             dc.fillRectangle(x+gap, y-gap, w-(2*gap), 2*gap); // a
        }
        if (bSegment) {
            dc.fillRectangle(x+w-gap, y+gap, 2*gap, (h/2)-(2*gap)); // b
        }
        if (cSegment) {
            dc.fillRectangle(x+w-gap, y+(h/2)+gap, 2*gap, (h/2)-(2*gap)); // c
        }
        if (dSegment) {
            dc.fillRectangle(x+gap, y+h-gap, w-(2*gap), 2*gap); // d
        }
        if (eSegment) {
            dc.fillRectangle(x-gap, y+(h/2)+gap, 2*gap, (h/2)-(2*gap)); // e
        }
        if (fSegment) {
            dc.fillRectangle(x-gap, y+gap, 2*gap, (h/2)-(2*gap)); // f
        }
        if (gSegment) {
            dc.fillRectangle(x+gap, y+(h/2)-gap, w-(2*gap), 2*gap); // g
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
