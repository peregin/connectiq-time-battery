using Toybox.WatchUi as Ui;

class ConnectiqTimeView extends Ui.DataField {

    hidden const CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

    hidden var is24Hour = false;

    hidden var hasBackgroundColorOption = false;
    hidden var backgroundColor = Graphics.COLOR_WHITE;
    hidden var textColor = Graphics.COLOR_BLACK;
    hidden var unitColor = 0x444444;

    // Set the label of the data field here.
    function initialize() {
        DataField.initialize();

        hasBackgroundColorOption = (self has :getBackgroundColor);
        System.println("has background color = " + hasBackgroundColorOption);
    }

    function onLayout(dc) {
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

        //calculateSize(dc);
        //System.println("size is [" + width + "," + height + "] wide = " + isWide);

        onUpdate(dc);
    }

    // Display the value you computed here. This will be called once a second when the data field is visible.
    // Resolution, WxH	200 x 265 pixels for both 520 and 820
    function onUpdate(dc) {
        // clear background
        dc.setColor(textColor, backgroundColor);
        dc.clear();

        // current time of day
        drawTime(dc, 30, 10);
    }

    function drawTime(dc, px, py) {
        var clockTime = System.getClockTime();
        var time;
        if (is24Hour) {
            time = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        } else {
            time = Lang.format("$1$:$2$", [compute12Hour(clockTime.hour), clockTime.min.format("%.2d")]);
        }
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        if (is24Hour) {
            dc.drawText(px + 12, py, Graphics.FONT_MEDIUM, time, CENTER);
        } else {
            dc.drawText(px, py, Graphics.FONT_MEDIUM, time, CENTER);
            var ampm = (clockTime.hour < 12) ? "am" : "pm";
            dc.drawText(px + 28, py + 3, Graphics.FONT_XTINY, ampm, CENTER);
        }
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
}