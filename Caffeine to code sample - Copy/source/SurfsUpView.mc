using Toybox.System as System;
using Rez as Resources;

class SurfsUpWatchFaceView extends Toybox.WatchUi.WatchFace
{ 
    //! Constructor
    public function initialize() {
        WatchFace.initialize();
    }

/*
  function onLayout(deviceContext) 
  {
    setLayout(Resources.Layouts.WatchFaceLayout(deviceContext));
  }
  */
    //! Set the layout and layers for the view
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout($.Rez.Layouts.WatchFaceLayout(dc));
        // clear the whole screen with solid color
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();


    }
  function onUpdate(deviceContext) 
  {
    var timeLabel = View.findDrawableById("TimeLabel");
    var hour = System.getClockTime().hour.toString();
    var minute = System.getClockTime().min.toString();
    timeLabel.setText(hour + ":" + minute);
 
    WatchFace.onUpdate(deviceContext);
  }
}