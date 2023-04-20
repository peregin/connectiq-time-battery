using Toybox.WatchUi as Ui;

class ConnectiqTimeView extends Ui.DataField {

    hidden const CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    hidden const RIGHT_BOTTOM = Graphics.TEXT_JUSTIFY_RIGHT;
    hidden const LEFT_BOTTOM = Graphics.TEXT_JUSTIFY_LEFT;

    hidden var is24Hour = false;

    hidden var x = 0;
    hidden var width = 200; // it is recalculated in onLayout
    hidden var width2 = width/2;
    hidden var y = 0;
    hidden var height = 50; // it is recalculated in onLayout
    hidden var xs = 5;

    hidden var hasBackgroundColorOption = false;
    hidden var backgroundColor = Graphics.COLOR_WHITE;
    hidden var textColor = Graphics.COLOR_BLACK;
    hidden var unitColor = 0x444444;
    
    hidden var temperatureUnit = "C";

    // Set the label of the data field here.
    function initialize() {
        DataField.initialize();

        hasBackgroundColorOption = (self has :getBackgroundColor);
        System.println("has background color=" + hasBackgroundColorOption);
        var settings = System.getDeviceSettings();
        is24Hour = settings.is24Hour;
        System.println("is 24 hour format=" + is24Hour);
        if (settings.temperatureUnits == System.UNIT_STATUTE) {
        	temperatureUnit = "F";
        }
        System.println("temperature unit=" + temperatureUnit);
    }

    function onLayout(dc) {
        calculateSize(dc);
        //System.println("size is [" + width + "," + height + "]");

        onUpdate(dc);
    }

    // Display the value you computed here. This will be called once a second when the data field is visible.
    // Resolution, WxH	200 x 265 pixels for both 520 and 820
    function onUpdate(dc) {
        setupColors();

        // clear background
        dc.setColor(textColor, backgroundColor);
        dc.clear();

        // current time of day
        var clockTime = System.getClockTime();
        var font = Graphics.FONT_NUMBER_MILD;
        var text;
        if (is24Hour) {
            text = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        } else {
            text = Lang.format("$1$:$2$", [compute12Hour(clockTime.hour), clockTime.min.format("%.2d")]);
        }
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        //dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
        var curTextSize = dc.getTextDimensions(text, font);

        var x = width2 + curTextSize[0] / 2 - xs;
        var y = height - curTextSize[1] + 1;
        var rightX = x; // store the right size of the time to align temperature with it
        dc.drawText(x, y, font, text, RIGHT_BOTTOM);
        if (!is24Hour) {
         	font = Graphics.FONT_XTINY;
            var amOrPm = (clockTime.hour < 12) ? "am" : "pm";
            dc.drawText(x, y, font, amOrPm, LEFT_BOTTOM);
            rightX += dc.getTextDimensions(amOrPm, font)[0]; // plus the am or pm indicator
        }

        // draw battery
        x = width2 - curTextSize[0] / 2 - xs;
        drawBattery(dc, x, 3, 27, 17);
        
        // draw temperature - the simulator on version 4.2.4 is it not shown
        var temperature = Application.Storage.getValue("sensor_temp");
        if (temperature != null) {
            // the sensor temperature is always in C, when statue unit is set needs to be converted
        	if (temperatureUnit.equals("F")) {
        		temperature = (temperature * 1.8) + 32;
        	}
        	text = format("$1$$2$", [temperature.format("%.1d"), temperatureUnit]);
        	font = Graphics.FONT_MEDIUM;
        	curTextSize = dc.getTextDimensions(text, font);
        	x = rightX - curTextSize[0];
        	y = curTextSize[1];
        	
        	dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        	dc.drawText(x, 0, font, text, LEFT_BOTTOM);
        	
        	//dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_TRANSPARENT);
        	//var r = y/4;
        	//dc.fillCircle(x - r*2, y - r, y/4);
        	//dc.fillRectangle(x - r*2-2, r/2, 5, y - r);
        }
    }

    function drawBattery(dc, xs, ys, width, height) {
        var battery = System.getSystemStats().battery;
        dc.setColor(textColor, Graphics.COLOR_LT_GRAY);
        dc.drawRectangle(xs, ys, width, height);

        if (battery < 15) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else if (battery < 30) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(xs + 1, ys + 1, (width-2) * battery / 100, height - 2);

        dc.setColor(textColor, textColor);
        dc.fillRectangle(xs + width - 1, ys + 3, 3, height - 6);

        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xs + 1 + width / 2, ys - 1 + height / 2, Graphics.FONT_XTINY, format("$1$%", [battery.format("%d")]), CENTER);
    }

    function compute12Hour(hour) {
        if (hour < 1) {
            return hour + 12;
        }
        if (hour >  12) {
            return hour - 12;
        }
        return hour;
    }

    function calculateSize(dc) {
        x = 0;
        width = dc.getWidth();
        y = 0;
        height = dc.getHeight();

        width2 = width/2;
    }

    function setupColors() {
        if (hasBackgroundColorOption) {
            backgroundColor = getBackgroundColor();
            if (backgroundColor == Graphics.COLOR_BLACK) {
                // night
                textColor = Graphics.COLOR_WHITE;
                unitColor = Graphics.COLOR_LT_GRAY;
            } else {
                // daylight
                textColor = Graphics.COLOR_BLACK;
                unitColor = 0x444444;
            }
        }
    }
}