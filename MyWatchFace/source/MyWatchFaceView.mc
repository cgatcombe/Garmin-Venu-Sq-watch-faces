import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.Time.Gregorian as Gregorian;

class MyWatchFaceView extends WatchUi.WatchFace
{
    // Constants for main watch screen display
    const WATCH_useInbuiltSensors as Lang.Boolean = false; // If true, use sensors (doesn't work yet)
    const WATCH_labelOffset as Lang.Number = 15; // For graphic text drawing
    const WATCH_showTimeWithLeds as Lang.Boolean = true; // True for LED display; false for string
    const WATCH_showBackgroundBitmap as Lang.Boolean = false; // True to show bitmap
    const WATCH_24HourMode as Lang.Boolean = false; // True for 24hr display; false for 12 hour display (though no am/pm indicator)
    const WATCH_showMonth as Lang.Boolean = true; // False just shows Day/Date; true additionally shows Month
    const WATCH_showIcons as Lang.Boolean = true; // True shows icons (via definitions in layout.xml and view) with text labels; false just shows text labels
    const WATCH_showCalendarIcon as Lang.Boolean = true; // If true show calendar icon with text; false show text only

    // Constants for the LED digital display
    var LED_spacing as Lang.Number = 50; // Spacing between LED digits
    const LED_angleDeg as Lang.Float = 8.0;
    const LED_angleRad as Lang.Float = (2*Math.PI)*(LED_angleDeg/360.0);
    var LED_width as Lang.Number = 20;
    var LED_height as Lang.Number = 40;
    var LED_topOffs as Lang.Float = (Math.tan(LED_angleRad)) * LED_height;
    var LED_midOffs as Lang.Float = (Math.tan(LED_angleRad)) * (LED_height/2);
    const LED_showBoundingBox as Lang.Boolean = false; // If true, show bounding box around the LED

    // Constants for enabling/disabling test functions 
    const TEST_showRuleLines as Lang.Boolean = false; // If true, display horizontal/vertical test lines for alignment checking
    const TEST_showColoredBoxes as Lang.Boolean = false; // If true, shows boxes with all the colours for testing
    const TEST_showAllLedDigits as Lang.Boolean = false; // If true, show all LED digits; if false show time

    var doneFirstUpdate as Lang.Boolean = false; // Will get set to true after first time calling onUpdate(), so we initialze things only once
    var backgroundBitmap;

    // Screen size should be 240x240 (at least on Venu Sq)
    var screenWidth as Lang.Number;
    var screenHeight as Lang.Number;

    // Screen objects (access using the layout):
    var dateLabelPosX as Lang.Number;
    var dateLabelPosY as Lang.Number;
    var monthLabelPosX as Lang.Number;
    var monthLabelPosY as Lang.Number;
    
    var calendarBitmap;
    var calendarBitmapLayoutObj as Lang.View;

    var batteryBitmap;
    var batteryBitmapLayoutObj as Lang.View;
    var batteryLabelPosX as Lang.Number;
    var batteryLabelPosY as Lang.Number;

    var heartBitmap;
    var heartBitmapLayoutObj as Lang.View;
    var heartLabelPosX as Lang.Number;
    var heartLabelPosY as Lang.Number;

    var stepsBitmap;
    var stepsBitmapLayoutObj as Lang.View;
    var stepsLabelPosX as Lang.Number;
    var stepsLabelPosY as Lang.Number;

    function initialize()
    {
        WatchFace.initialize();

        // Use bigger LEDs in 12 hour mode
        if (!WATCH_24HourMode)
        {
            LED_width = 30;
            LED_height = LED_width*2;
            LED_spacing  = LED_width*2;
        }
        LED_topOffs = (Math.tan(LED_angleRad)) * LED_height;
        LED_midOffs = (Math.tan(LED_angleRad)) * (LED_height/2);

        // Note - can't access View stuff in here, needs to be done in onUpdate()
        if (WATCH_showBackgroundBitmap)
        {
            backgroundBitmap=WatchUi.loadResource(Rez.Drawables.BackgroundPNG);
        }

        if (WATCH_showIcons)
        {
            batteryBitmap=WatchUi.loadResource(Rez.Drawables.BatteryPNG);
            heartBitmap=WatchUi.loadResource(Rez.Drawables.HeartPNG);
            stepsBitmap=WatchUi.loadResource(Rez.Drawables.FootprintsPNG);
        }

        if (WATCH_showCalendarIcon)
        {
            calendarBitmap=WatchUi.loadResource(Rez.Drawables.CalendarPNG);
        }

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
        // Check if this is the first time in here so that some things are only set/computed once
        if (!doneFirstUpdate)
        {
            doneFirstUpdate = true;       
            screenWidth = dc.getWidth();
            screenHeight = dc.getHeight();
        
            // Set positions of the labels:
            // If icons are to be shown, then these positions are based on the icon's location and size.
            // There may be some arbitrary fine tuning for the locations to make them 'look right'.

            if (WATCH_showCalendarIcon)
            {
                calendarBitmapLayoutObj = View.findDrawableById("BitmapCalendar") as Text;
                monthLabelPosX = calendarBitmapLayoutObj.locX + calendarBitmapLayoutObj.width/2;
                monthLabelPosY = calendarBitmapLayoutObj.locY + 20;
                dateLabelPosX = monthLabelPosX;
                dateLabelPosY = monthLabelPosY + 27;
            }
            else 
            {
                dateLabelPosX = screenWidth-WATCH_labelOffset;
                dateLabelPosY = WATCH_labelOffset;
                monthLabelPosX = dateLabelPosX;
                monthLabelPosY = dateLabelPosY+20;
            }
            System.println("onUpdate: dateLabelPos (x,y) = " + dateLabelPosX + "," + dateLabelPosY);
            System.println("onUpdate: monthLabelPos (x,y) = " + monthLabelPosX + "," + monthLabelPosY);

            batteryBitmapLayoutObj = View.findDrawableById("BitmapBattery") as Text;
            System.println("onUpdate: batteryBitmapLayoutObj (x,y) = " + batteryBitmapLayoutObj.locX + "," + batteryBitmapLayoutObj.locY);
            System.println("onUpdate: batteryBitmapLayoutObj (w,h) = " + batteryBitmapLayoutObj.width + "," + batteryBitmapLayoutObj.height);
            if (WATCH_showIcons)
            {
                if (WATCH_showCalendarIcon)
                {
                    batteryBitmapLayoutObj.locY = calendarBitmapLayoutObj.height/2 - batteryBitmapLayoutObj.height/2;
                }
                batteryLabelPosX = batteryBitmapLayoutObj.locX+10;
                batteryLabelPosY = batteryBitmapLayoutObj.locY + batteryBitmapLayoutObj.height/2;
            }
            else 
            {
                batteryLabelPosX = WATCH_labelOffset;
                batteryLabelPosY = WATCH_labelOffset;
            }
            System.println("onUpdate: batteryLabelPos (x,y) = " + batteryLabelPosX + "," + batteryLabelPosY);

            heartBitmapLayoutObj = View.findDrawableById("BitmapHeart") as Text;
            System.println("onUpdate: heartBitmapLayoutObj (x,y) = " + heartBitmapLayoutObj.locX + "," + heartBitmapLayoutObj.locY);
            System.println("onUpdate: heartBitmapLayoutObj (w,h) = " + heartBitmapLayoutObj.width + "," + heartBitmapLayoutObj.height);
            if (WATCH_showIcons)
            {
                heartLabelPosX = heartBitmapLayoutObj.locX + heartBitmapLayoutObj.width/2;
                heartLabelPosY = heartBitmapLayoutObj.locY + heartBitmapLayoutObj.height/2 - 3;
            }
            else 
            {
                heartLabelPosX = screenWidth-WATCH_labelOffset;
                heartLabelPosY = screenHeight-WATCH_labelOffset;
            }
            System.println("onUpdate: heartLabelPos (x,y) = " + heartLabelPosX + "," + heartLabelPosY);

            stepsBitmapLayoutObj = View.findDrawableById("BitmapFootprints") as Text;
            System.println("onUpdate: stepsBitmapLayoutObj (x,y) = " + stepsBitmapLayoutObj.locX + "," + stepsBitmapLayoutObj.locY);
            System.println("onUpdate: stepsBitmapLayoutObj (w,h) = " + stepsBitmapLayoutObj.width + "," + stepsBitmapLayoutObj.height);
            if (WATCH_showIcons)
            {
                stepsLabelPosX = stepsBitmapLayoutObj.locX + stepsBitmapLayoutObj.width;
                stepsLabelPosY = stepsBitmapLayoutObj.locY + stepsBitmapLayoutObj.height/2;
            }
            else 
            {
                stepsLabelPosX = WATCH_labelOffset;
                stepsLabelPosY = screenHeight-WATCH_labelOffset;
            }
            System.println("onUpdate: stepsLabelPos (x,y) = " + stepsLabelPosX + "," + stepsLabelPosY);
        }

        // Get and show the current time and other items of interest
        var time as Lang.String = getTime();
        var battery as Lang.Number = getBattery();
        var date as Lang.String = getDate();
        var steps as Lang.String = getSteps();
        var heartRate as Lang.String = getHeartRate();
      
        // Seem to need to do these first before any other graphic calls in this function
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setAntiAlias(true);

        // Call the view onUpdate function to redraw the layout (makes all bitmaps visible)
        if (WATCH_showIcons)
        {
            View.onUpdate(dc);
        }

        // Now I can draw my own stuff on the display

        if (WATCH_showBackgroundBitmap)
        {
            dc.drawBitmap(0, 0, backgroundBitmap);
        }

        // Test lines at extremes (0-239, 0-239):
        if (TEST_showRuleLines)
        {
            dc.setColor(Graphics.COLOR_PINK, Graphics.COLOR_TRANSPARENT);
            dc.clear();
            dc.setPenWidth(1);
            dc.drawLine(0,0,   239,0);
            dc.drawLine(0,120, 239,120);
            dc.drawLine(0,239, 239,239);
            dc.drawLine(0,0,   0,239);
            dc.drawLine(120,0, 120,239);
            dc.drawLine(239,0, 239,239);
        }       
       
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
            var x as Lang.Number = 10;
            drawLED(dc, 0, x, 100); x+=LED_spacing;
            drawLED(dc, 1, x, 100); x+=LED_spacing;
            drawLED(dc, 2, x, 100); x+=LED_spacing;
            drawLED(dc, 3, x, 100); x+=LED_spacing;
            drawLED(dc, 4, x, 100);
            x = 10;
            drawLED(dc, 5, x, 160); x+=LED_spacing;
            drawLED(dc, 6, x, 160); x+=LED_spacing;
            drawLED(dc, 7, x, 160); x+=LED_spacing;
            drawLED(dc, 8, x, 160); x+=LED_spacing;
            drawLED(dc, 9, x, 160);
        }
        else
        {
            if (WATCH_showTimeWithLeds)
            {
                var x as Lang.Number = 33;
                var y as Lang.Number = 100;
                if (!WATCH_24HourMode)
                {
                    x = 1;
                    y = 90;
                }
                var timeArr as Lang.Array = time.toCharArray();
                // If only 4 characters, then there is only a single hour digit; shift accordingly
                // to make display look better positioned
                if (timeArr.size() == 4)
                {
                    x+=LED_spacing;
                }
                for (var i=0; i<timeArr.size(); i++)
                {
                    var asciiChar as Lang.Number = timeArr[i].toNumber();
                    if (asciiChar == ':')
                    {
                        // Need to fine tune x position here
                        drawColon(dc, x-12, y);
                    }
                    else
                    {
                        var digit as Lang.Number = asciiChar - 48; // Subtract 48 from ASCII code to get the digit
                        if (digit >= 0 && digit <= 9) // Only draw the digits, nothing else
                        {
                            drawLED(dc, digit, x, y);
                            x+=LED_spacing;
                        }
                    }
                }
            }
            else 
            {
                dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(screenWidth/2, screenHeight/2, Graphics.FONT_SYSTEM_NUMBER_THAI_HOT, time, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        if (WATCH_showIcons)
        {
            drawBattery(dc, battery);
        }
        else 
        {
            var batStr as Lang.String = Lang.format( "$1$%", [ battery.format( "%2d" ) ] ); 
            dc.drawText(WATCH_labelOffset, WATCH_labelOffset, Graphics.FONT_SMALL, batStr, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        if (WATCH_showCalendarIcon)
        {
            dc.drawText(dateLabelPosX, dateLabelPosY, Graphics.FONT_SMALL, date, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        else
        {
            dc.drawText(dateLabelPosX, dateLabelPosY, Graphics.FONT_SMALL, date, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        if (WATCH_showMonth)
        {
            var month = getMonth();
            if (WATCH_showCalendarIcon)
            {
                dc.drawText(monthLabelPosX, monthLabelPosY, Graphics.FONT_SMALL, month, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }
            else 
            {
                dc.drawText(monthLabelPosX, monthLabelPosY, Graphics.FONT_SMALL, month, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            }
        }

        dc.drawText(stepsLabelPosX, stepsLabelPosY, Graphics.FONT_SMALL, steps, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        if (WATCH_showIcons)
        {
            dc.drawText(heartLabelPosX, heartLabelPosY, Graphics.FONT_SMALL, heartRate, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER); 
        }
        else 
        {
            dc.drawText(heartLabelPosX, heartLabelPosY, Graphics.FONT_SMALL, heartRate, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER); 
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

    function drawBattery(dc as Dc, percent) as Void 
    {
        /*
            See image file for exact dimensions:
            
                             > t1 < 
              ________________
           ^ |      < w >     |_  v
           h |                 _| t2
           v |________________|   ^

        */

        var width as Lang.Number = (batteryBitmapLayoutObj.width-25)*percent/100;
        var height as Lang.Number = (batteryBitmapLayoutObj.height/2);
        System.println("drawBattery: (w,h) = " + width + "," + height);
        var color = Graphics.COLOR_DK_GREEN;
        if (percent<15)
        {
            color = Graphics.COLOR_RED; 
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(batteryLabelPosX-2, batteryLabelPosY-12, width, height);
        //if (percent>99)
        //{
        //    dc.fillRectangle(x+w-2, y+t2+2, t1, t2+2);
        //}    

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var percentStr as Lang.String = Lang.format( "$1$%", [ percent.format( "%2d" ) ] );  
        dc.drawText(batteryLabelPosX, batteryLabelPosY, Graphics.FONT_SMALL, percentStr, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawColon(dc as Dc, x, y) as Void
    {
        // Need to fine tune the positions of each dot
        dc.fillCircle(x, y+LED_height/2-15, 4);
        dc.fillCircle(x-2, y+LED_height/2+15, 4);
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

    function getTime() as Lang.String
    {
        var clockTime as Lang.ClockTime = System.getClockTime();
        var hour as Lang.Number = clockTime.hour;
        if (!WATCH_24HourMode)
        {
            if (hour>12)
            {
                hour -= 12;
            }
        }
        var timeStr as Lang.String = Lang.format("$1$:$2$", [hour, clockTime.min.format("%02d")]);
        return timeStr;
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

    function getBattery() as Lang.Number
    {
        var stats as Lang.Stats = System.getSystemStats();
        var pwr as Lang.Number = stats.battery;
        return pwr;
    }

    function getSteps() as Lang.String
    {
        // get ActivityMonitor info
        var info as Lang.ActivityMonitor.Info = ActivityMonitor.getInfo();
        var steps as Lang.Number = info.steps;
        return steps.toString();
    }

    function getDate() as Lang.String
    {
        var now as Lang.Time.Moment = Time.now();
        var info as Lang.Time.Gre.Info = Gregorian.info(now, Time.FORMAT_LONG);
        var dateStr as Lang.String = Lang.format("$1$ $2$", [info.day_of_week, info.day]);
        return dateStr;
    }

    function getMonth() as Lang.String
    {
        var now as Lang.Time.Moment = Time.now();
        var info as Lang.Time.Gre.Info = Gregorian.info(now, Time.FORMAT_LONG);
        var monthStr as Lang.String = Lang.format("$1$", [info.month]);
        return monthStr;
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
