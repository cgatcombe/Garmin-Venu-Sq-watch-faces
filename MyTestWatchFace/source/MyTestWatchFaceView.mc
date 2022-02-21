import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.Time.Gregorian as Gregorian;

class MyTestWatchFaceView extends WatchUi.WatchFace
{
    // Constants for main watch screen display
    const WATCH_useInbuiltSensors as Lang.Boolean = false; // If true, use sensors (doesn't work yet)
    const WATCH_useViewsAndLayout as Lang.Boolean = false; // If true, use views and layout defined in layout.xml; otherwise draw graphics directly
    const WATCH_labelOffset as Lang.Number = 15; // For graphic text drawing
    //var screenWidth as Lang.Number = dc.getWidth();
    //var screenHeight as Lang.Number = dc.getHeight();

    // Constants for the LED digital display
    const LED_angleDeg as Lang.Float = 8.0;
    const LED_angleRad as Lang.Float = (2*Math.PI)*(LED_angleDeg/360.0);
    const LED_width as Lang.Number = 20;
    const LED_height as Lang.Number = 40;
    const LED_topOffs as Lang.Float = (Math.tan(LED_angleRad)) * LED_height;
    const LED_midOffs as Lang.Float = (Math.tan(LED_angleRad)) * (LED_height/2);
    const LED_showBoundingBox as Lang.Boolean = false; // If true, show bounding box around the LED

    // Constants for enabling/disabling test functions 
    const TEST_showRuleLines as Lang.Boolean = false; // If true, display horizontal test lines for alignment checking
    const TEST_showColoredBoxes as Lang.Boolean = false; // If true, shows boxes with all the colours for testing
    const TEST_showAllLedDigits as Lang.Boolean = false; // If true, show all LED digits; if false show time

    function initialize()
    {
        WatchFace.initialize();

        if (WATCH_useInbuiltSensors)
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
        // Get and show the current time and other items of interest
        var clockTime as Lang.ClockTime = System.getClockTime();
        var timeString as Lang.String = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var battery as Lang.String = getBattery();
        var date as Lang.String = getDate();
        var steps as Lang.String = getSteps();
        var heartRate as Lang.String = getHeartRate();

        if (WATCH_useViewsAndLayout)
        {
            var view as Lang.View = View.findDrawableById("TimeLabel") as Text;
            view.setText(timeString);

            var view2 as Lang.View = View.findDrawableById("TopLeft") as Text;
            view2.setText("B: " + battery);

            var view3 as Lang.View = View.findDrawableById("TopRight") as Text;
            view3.setText("D: " + date);

            var view4 as Lang.View = View.findDrawableById("BottomLeft") as Text;
            view4.setText("S: " + steps);

            var view5 as Lang.View = View.findDrawableById("BottomRight") as Text;
            view5.setText("H: " + heartRate);

            // Call the parent onUpdate function to redraw the layout
            View.onUpdate(dc);
        }
        else
        {
            // Screen size should be 240x240 (at least on Venu Sq)
            var screenWidth as Lang.Number = dc.getWidth();
            var screenHeight as Lang.Number = dc.getHeight();

            // Seem to need to do this first before any other graphic calls in this function
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
            dc.clear();

            // Test lines at extremes
            if (TEST_showRuleLines)
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
 
            dc.drawText(WATCH_labelOffset, WATCH_labelOffset, Graphics.FONT_SMALL, battery, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(screenWidth-WATCH_labelOffset, WATCH_labelOffset, Graphics.FONT_SMALL, date, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(WATCH_labelOffset, screenHeight-WATCH_labelOffset, Graphics.FONT_SMALL, steps, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(screenWidth-WATCH_labelOffset, screenHeight-WATCH_labelOffset, Graphics.FONT_SMALL, heartRate, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        
            if (TEST_showColoredBoxes)
            {
                // These are all the colours we know about
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

            if (TEST_showAllLedDigits)
            {
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
            else
            {
                var x as Lang.Number = 40;
                var timeArr as Lang.Array = timeString.toCharArray();
                for (var i=0; i<timeArr.size(); i++)
                {
                    var asciiChar as Lang.Number = timeArr[i].toNumber();
                    var digit as Lang.Number = asciiChar - 48; // Subtract 48 from ASCII code to get the digit
                    if (digit >= 0 && digit <= 9) // Only draw the digits, nothing else
                    {
                        drawLED(dc, digit, x, 100);
                        x+=50;
                    }
                }
            }
        }
    }

    function drawBox(dc as Dc, x, y, size, colour as Graphics.ColorValue) as Void
    {
        dc.setColor(colour, Graphics.COLOR_TRANSPARENT);
        // Draw box outline
        //dc.setPenWidth(7);
        //dc.drawRectangle(x, y, size, size);
        // Draw filled box
        dc.fillRectangle(x, y, size, size);
    }

    function drawLED(dc as Dc, digit as Lang.Number, x, y) as Void
    {
        System.println("drawLED: digit " + digit);
        if (LED_showBoundingBox)
        {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(1);
            dc.drawRectangle(x, y, LED_width, LED_height);
        }

        /*
            The LED digit segments:

                o   ___a___
                   |       |
                  f       b
                  |       |
                  ---g---
                 |       |
                e       c
                |       |
                 ---d---

                o = (x,y) the top left corner
                Size is LED_width x LED_height
                Top segment is offset by LED_topOffs
                Middle segment is offset by LED_midOffs
                The segment offsets are computed from LED_angleDeg, the angle of the lean
        */
        var aSegment as Lang.Boolean = false;
        var bSegment as Lang.Boolean = false;
        var cSegment as Lang.Boolean = false;
        var dSegment as Lang.Boolean = false;
        var eSegment as Lang.Boolean = false;
        var fSegment as Lang.Boolean = false;
        var gSegment as Lang.Boolean = false;

        switch (digit)
        {
            case 0:
            {
                aSegment = true;
                bSegment = true;
                cSegment = true;
                dSegment = true;
                eSegment = true;
                fSegment = true;
                gSegment = false;
                break;
            }
            case 1:
            {
                aSegment = false;
                bSegment = true;
                cSegment = true;
                dSegment = false;
                eSegment = false;
                fSegment = false;
                gSegment = false;
                break;
            }
            case 2:
            {
                aSegment = true;
                bSegment = true;
                cSegment = false;
                dSegment = true;
                eSegment = true;
                fSegment = false;
                gSegment = true;
                break;
            }
            case 3:
            {
                aSegment = true;
                bSegment = true;
                cSegment = true;
                dSegment = true;
                eSegment = false;
                fSegment = false;
                gSegment = true;
                break;
            }
            case 4:
            {
                aSegment = false;
                bSegment = true;
                cSegment = true;
                dSegment = false;
                eSegment = false;
                fSegment = true;
                gSegment = true;
                break;
            }
            case 5:
            {
                aSegment = true;
                bSegment = false;
                cSegment = true;
                dSegment = true;
                eSegment = false;
                fSegment = true;
                gSegment = true;
                break;
            }
            case 6:
            {
                aSegment = true;
                bSegment = false;
                cSegment = true;
                dSegment = true;
                eSegment = true;
                fSegment = true;
                gSegment = true;
                break;
            }
            case 7:
            {
                aSegment = true;
                bSegment = true;
                cSegment = true;
                dSegment = false;
                eSegment = false;
                fSegment = false;
                gSegment = false;
                break;
            }
            case 8:
            {
                aSegment = true;
                bSegment = true;
                cSegment = true;
                dSegment = true;
                eSegment = true;
                fSegment = true;
                gSegment = true;
                break;
            }
            case 9:
            {
                aSegment = true;
                bSegment = true;
                cSegment = true;
                dSegment = true;
                eSegment = false;
                fSegment = true;
                gSegment = true;
                break;
            }
            default:
            {
                System.println("Invalid digit: " + digit);  
                break;         
            }
        }

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(5);
        if (aSegment) {
             dc.drawLine(x+LED_topOffs, y, x+LED_width+LED_topOffs, y); // a
        }
        if (bSegment) {
            dc.drawLine(x+LED_width+LED_topOffs, y, x+LED_width+LED_midOffs, y+(LED_height/2)); // b
        }
        if (cSegment) {
            dc.drawLine(x+LED_width+LED_midOffs, y+(LED_height/2), x+LED_width, y+LED_height); // c
        }
        if (dSegment) {
            dc.drawLine(x, y+LED_height, x+LED_width, y+LED_height); // d
        }
        if (eSegment) {
            dc.drawLine(x, y+LED_height, x+LED_midOffs, y+(LED_height/2)); // e
        }
        if (fSegment) {
            dc.drawLine(x+LED_midOffs, y+(LED_height/2), x+LED_topOffs, y); // f
        }
        if (gSegment) {
            dc.drawLine(x+LED_midOffs, y+(LED_height/2), x+LED_width+LED_midOffs, y+(LED_height/2)); // g
        }
    }

    function getHeartRate() as Lang.String
    {
        var hrIterator as Lang.HeartRateIterator = ActivityMonitor.getHeartRateHistory(1, true);
        var previous as Lang.HeartRateIterator = hrIterator.next();

        if (previous == null || previous.heartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
            return "--";
        }
        return previous.heartRate.format("%02d");
    }

    function getBattery() as Lang.String
    {
        var stats as Lang.Stats = System.getSystemStats();
        var pwr as Lang.Float = stats.battery;
        var batStr as Lang.String = Lang.format( "$1$%", [ pwr.format( "%2d" ) ] );
        return batStr;
    }

    function getSteps() as Lang.String
    {
        var stats as Lang.System.Stats = System.getSystemStats();
        //var steps = stats.stepCount;
        //var steps = stats.steps;
        //var steps = stats.step;

        //var steps = stats.distance; //.steps;

        // get ActivityMonitor info
        var info as Lang.ActivityMonitor.Info = ActivityMonitor.getInfo();
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

    function getDate() as Lang.String
    {
        var now as Lang.Time.Moment = Time.now();
        var info as Lang.Time.Gre.Info = Gregorian.info(now, Time.FORMAT_LONG);
        var dateStr as Lang.String = Lang.format("$1$ $2$", [info.day_of_week, info.day]);
        return dateStr;
    }

    function onSensor(sensorInfo) as Void
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
