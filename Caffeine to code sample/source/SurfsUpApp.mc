//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;

class SurfsUpApp extends Toybox.Application.AppBase
{
  function getInitialView()
  {
    return [ new SurfsUpWatchFace() ];
  }
}