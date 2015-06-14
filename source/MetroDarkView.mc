using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as AM;

class MetroDarkView extends Ui.View {
    
    hidden var bluetoothActiveIcon;
    hidden var bluetoothInactiveIcon;
    hidden var tonesOn;
    hidden var vibrateOn;
    hidden var EmptyBattery;
    hidden var AlmostEmpty;
    hidden var TwentyFivePercentBattery;
    hidden var FiftyPercentBattery;
    hidden var SeventyFivePercentBattery;
    hidden var AlmostFull;
    hidden var FullBattery;
    
    function initialize(sensor, index) {
        bluetoothActiveIcon = Ui.loadResource(Rez.Drawables.bluetoothOn);
        bluetoothInactiveIcon = Ui.loadResource(Rez.Drawables.bluetoothOff);
        tonesOn = Ui.loadResource(Rez.Drawables.tonesOn);
        vibrateOn = Ui.loadResource(Rez.Drawables.vibrateOn);
        EmptyBattery = Ui.loadResource(Rez.Drawables.EmptyBattery);
        AlmostEmpty = Ui.loadResource(Rez.Drawables.AlmostEmpty);
        TwentyFivePercentBattery = Ui.loadResource(Rez.Drawables.TwentyFivePercentBattery);
        FiftyPercentBattery = Ui.loadResource(Rez.Drawables.FiftyPercentBattery);
        SeventyFivePercentBattery = Ui.loadResource(Rez.Drawables.SeventyFivePercentBattery);
        AlmostFull = Ui.loadResource(Rez.Drawables.AlmostFull);
        FullBattery = Ui.loadResource(Rez.Drawables.FullBattery);
    }
    
    function onLayout(dc) {
    	setLayout(Rez.Layouts.MainLayout(dc));
    }
    
    function onUpdate(dc) {
    	View.onUpdate(dc);
    	
        var width, height;
        var screenWidth = dc.getWidth();
        var clockTime = Sys.getClockTime();
        var activityInfo = AM.getInfo();
        var systemStats = Sys.getSystemStats();
        var systemDeviceSettings = Sys.getDeviceSettings();
        var hh, hour;
        var m, min;
        var s, sec;
		
        width = dc.getWidth();
        height = dc.getHeight();
		
		var now = Time.now();
        var info = Calendar.info(now, Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
        
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(109, 68, 28);
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(109, 68, 25);
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(109, 54, Gfx.FONT_XTINY, Lang.format("$1$", [activityInfo.steps]), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(109, 68, Gfx.FONT_XTINY, "Steps", Gfx.TEXT_JUSTIFY_CENTER);
        if(activityInfo.steps >= activityInfo.stepGoal) {
        	dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);
			dc.fillCircle(109, 68, 28);
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
			dc.fillCircle(109, 68, 25);
	        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        dc.drawText(109, 54, Gfx.FONT_XTINY, Lang.format("$1$", [activityInfo.steps]), Gfx.TEXT_JUSTIFY_CENTER);
	        dc.drawText(109, 68, Gfx.FONT_XTINY, "Steps", Gfx.TEXT_JUSTIFY_CENTER);
		}
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(63, 114, 28);
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(63, 114, 25);
		
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(63, 102, Gfx.FONT_XTINY, Lang.format("$1$", [activityInfo.calories]), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(63, 116, Gfx.FONT_XTINY, "kCal", Gfx.TEXT_JUSTIFY_CENTER);
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(155, 114, 28);
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
		dc.fillCircle(155, 114, 25);
		
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        var miles = activityInfo.distance/160934.4;
        var milesString = miles.toString();
        var milesSubString = milesString.substring(0, 4);
        
        dc.drawText(155, 102, Gfx.FONT_XTINY, Lang.format("$1$", [milesSubString]), Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(155, 116, Gfx.FONT_XTINY, "MI", Gfx.TEXT_JUSTIFY_CENTER);
        
        drawTrigonometricalMoveBarArc(dc, height/2 - 20, width/2, height/2, activityInfo);
        drawTrigonometricalStepGoalArc(dc, height/2 - 20, width/2, height/2, activityInfo);
        
        var batteryLevel = systemStats.battery;
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(3*width/4-5, 3*height/4-10, Gfx.FONT_TINY, Lang.format("$1$", [batteryLevel.toNumber()])+ "%", Gfx.TEXT_JUSTIFY_RIGHT);
		
		if (batteryLevel >= 1.0 and batteryLevel < 5.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, EmptyBattery);
		} else if(batteryLevel >= 5.0 and batteryLevel < 14.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, AlmostEmpty);
		} else if (batteryLevel >= 14.0 and batteryLevel < 28.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, TwentyFivePercentBattery);
		} else if (batteryLevel >= 28.0 and batteryLevel < 42.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, TwentyFivePercentBattery);
		} else if (batteryLevel >= 42.0 and batteryLevel < 56.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, FiftyPercentBattery);
		} else if (batteryLevel >= 56.0 and batteryLevel < 70.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, FiftyPercentBattery);
		} else if (batteryLevel >= 70.0 and batteryLevel < 84.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, SeventyFivePercentBattery);
		} else if (batteryLevel >= 84.0 and batteryLevel < 98.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, AlmostFull);
		} else if(batteryLevel >= 98.0) {
			dc.drawBitmap(3*width/4-5, 3*height/4-10, FullBattery);
		}
        
        if(systemDeviceSettings.phoneConnected) {
        	dc.drawBitmap(width/2-8, 3*height/4-40, bluetoothActiveIcon);
        } else {
        	dc.drawBitmap(width/2-8, 3*height/4-40, bluetoothInactiveIcon);
        }
        
        if(systemDeviceSettings.tonesOn) {
        	dc.drawBitmap(3*width/4-15, height/4, tonesOn);
        } 
        
        if(systemDeviceSettings.vibrateOn) {
        	dc.drawBitmap(width/4, height/4, vibrateOn);
        }
        
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		
		hh = info.hour;
	    m = info.min;
	    var dd = "AM";
	    var h = hh;
	    
	    if (h >= 12) {
	        h = hh-12;
	        dd = "PM";
	    }
	    
	    if (h == 0) {
	        h = 12;
	    }
	    m = m<10?"0"+m:m;
	    h = h<10?"0"+h:h;
	    
	    var timeStr = Lang.format("$1$:$2$ $3$", [h, m, dd]);
		dc.drawText(width/4-20, (3*height/4 - 18), Gfx.FONT_TINY, timeStr, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(width/4-4,(3*height/4),Gfx.FONT_TINY, dateStr, Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        hour = ( ( ( clockTime.hour % 12 ) * 60 ) + clockTime.min );
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        drawHand(dc, hour, 60, 5);
        
        hour = ( ( ( clockTime.hour+6 % 12 ) * 60 ) + clockTime.min );
        hour = hour / (12 * 60.0);
        hour = hour * Math.PI * 2;
        drawHand(dc, hour, 15, 5);
        
        min = ( clockTime.min / 60.0) * Math.PI * 2;
        drawHand(dc, min, 100, 5);
        min = ( (clockTime.min + 30) / 60.0) * Math.PI * 2;
        drawHand(dc, min, 15, 5);
        
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_BLACK);
        dc.fillCircle(width/2, height/2, 7);
        dc.setColor(Gfx.COLOR_BLACK,Gfx.COLOR_BLACK);
        dc.drawCircle(width/2, height/2, 7);
    }
    
    function drawHand(dc, angle, length, width) {
        var coords = [ [-(width/2),0], 
        			   [-(width/2), -length], 
        			   [width/2, -length], 
        			   [width/2, 0] 
        			 ];
        var result = new [4];
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        for (var i = 0; i < 4; i += 1) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            result[i] = [ centerX+x, centerY+y];
        }
		
        dc.fillPolygon(result);
    }
	
	function drawTrigonometricalMoveBarArc(dc, radius, centerX, centerY, activityInfo) {
		var angle;
		var lessAngle;
		
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
		for (angle = 0.3; angle <= 2*Math.PI/4 - 0.2; angle = angle + Math.PI/75) {
			var x = radius * Math.cos(angle - 3.2) + centerX;
	        var y = radius * Math.sin(angle - 3.2) + centerY;
	        dc.fillCircle(x, y, 3);
		} 
		
		var moveBarLevel = activityInfo.moveBarLevel;
		
		if(moveBarLevel == 0) {
			dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);
			lessAngle = 1.3;
		} else if (moveBarLevel == 1) {
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			lessAngle = 1.1;
		} else if (moveBarLevel == 2) {
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
			lessAngle = 0.88;
		} else if (moveBarLevel == 3) {
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			lessAngle = 0.66;
		} else if (moveBarLevel == 4) {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
			lessAngle = 0.44;
		} else if (moveBarLevel == 5) {
			dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
			lessAngle = 0.2;
		}
		
		for (angle = 0.3; angle <= 2*Math.PI/4 - lessAngle; angle = angle + Math.PI/75) {
			var x = radius * Math.cos(angle - 3.2) + centerX;
	        var y = radius * Math.sin(angle - 3.2) + centerY;
	        dc.fillCircle(x, y, 3);
		}
	}
	
	function drawTrigonometricalStepGoalArc(dc, radius, centerX, centerY, activityInfo) {
		var angle;
		var startAngle = 0;
		
		var steps = activityInfo.steps;
		var stepGoal = activityInfo.stepGoal;
		
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
		for (angle = 0.3; angle <= 2*Math.PI/4 - 0.2; angle = angle + Math.PI/75) {
			var x = radius * Math.cos(angle-1.6) + centerX;
	        var y = radius * Math.sin(angle-1.6) + centerY;
	        dc.fillCircle(x, y, 3);
		}
		
		var level = steps * 100/stepGoal;
		
		if(level >= 0 and level < 10.0) {
			dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
			startAngle = 1.3;
		} else if (level >= 10.0 and level < 20.0) {
			dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
			startAngle = 1.2;
		} else if (level >= 20.0 and level < 30.0) {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
			startAngle = 1.1;
		} else if (level >= 30.0 and level < 40.0) {
			dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
			startAngle = 1.0;
		} else if (level >= 40.0 and level < 50.0) {
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			startAngle = 0.9;
		} else if (level >= 50.0 and level < 60.0) {
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			startAngle = 0.8;
		} else if (level >= 60.0 and level < 70.0) {
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
			startAngle = 0.7;
		} else if (level >= 70.0 and level < 80.0) {
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
			startAngle = 0.6;
		} else if (level >= 80.0 and level < 90.0) {
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			startAngle = 0.5;
		} else if (level >= 90.0 and level < 100.0) {
			dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			startAngle = 0.4;
		} else if (level >= 100.0) {
			dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_TRANSPARENT);
			startAngle = 0.3;
		} 
		
		for (angle = startAngle; angle <= 2*Math.PI/4 - 0.2; angle = angle + Math.PI/75) {
			var x = radius * Math.cos(angle-1.6) + centerX;
	        var y = radius * Math.sin(angle-1.6) + centerY;
	        dc.fillCircle(x, y, 3);
		}
	}
}