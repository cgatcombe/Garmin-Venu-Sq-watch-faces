using Toybox.System as System;
using Rez as Resources;

class SurfsUpWatchFace extends Toybox.WatchUi.WatchFace
{ 
  function onLayout(deviceContext) 
  {
    setLayout(Resources.Layouts.WatchFaceLayout(deviceContext));
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