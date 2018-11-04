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

        calculateSize(dc);
        //System.println("size is [" + width + "," + height + "]");

        onUpdate(dc);
    }

    // Display the value you computed here. This will be called once a second when the data field is visible.
    // Resolution, WxH	200 x 265 pixels for both 520 and 820
    function onUpdate(dc) {
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
        var curTextSize = dc.getTextDimensions(text, font);

        var x = width2 + curTextSize[0] / 2;
        var y = height - curTextSize[1] + 5;
        if (is24Hour) {
            dc.drawText(x, y, font, text, RIGHT_BOTTOM);
        } else {
            dc.drawText(x, y, font, text, RIGHT_BOTTOM);
            var amOrPm = (clockTime.hour < 12) ? "am" : "pm";
            dc.drawText(x, y, Graphics.FONT_XTINY, amOrPm, LEFT_BOTTOM);
        }

        drawBattery(dc, 2, 2, 20, 14);
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
            dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(xs + 1, ys + 1, (width-2) * battery / 100, height - 2);

        dc.setColor(textColor, textColor);
        dc.fillRectangle(xs + width - 1, ys + 3, 3, height - 6);

        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xs + 2 + width / 2, ys + 6, Graphics.FONT_XTINY, format("$1$%", [battery.format("%d")]), CENTER);
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
}