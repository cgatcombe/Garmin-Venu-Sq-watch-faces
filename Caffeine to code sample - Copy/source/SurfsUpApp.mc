//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;

class SurfsUpApp extends Toybox.Application.AppBase
{
  // initialize the AppBase class
  function initialize() {
    AppBase.initialize();
  }
    
  // onStart() is called on application start up
  function onStart(state) {
  }

  // onStop() is called when your application is exiting
  function onStop(state) {
  }
  
  function getInitialView()
  {
    return [ new SurfsUpWatchFaceView() ];
  }
}