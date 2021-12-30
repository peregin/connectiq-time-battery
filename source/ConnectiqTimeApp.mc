using Toybox.Application as App;

/**
 * Data field to show time of day and additional information on teh top of the screen.
 *
 * Garmin Edge 820
 * ---------------
 * Screen Size: 2.3"
 * Resolution: 200px x 265px
 * 16-bit Color Display
 *
 * Garmin Forerunner 735XT
 * -----------------------
 * Resolution: 215px x 185px
 */
class ConnectiqTimeApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	if (Toybox.System has :ServiceDelegate) {
    		System.println("registering backround event listener");    	 
    		Background.registerForTemporalEvent(new Time.Duration(5 * 60)); // tick every 5th minute
   		}
        return [new ConnectiqTimeView()];
    }
    
    // value provided by the TemperatureServiceDelegate
    function onBackgroundData(temperature) {
        if (temperature != null) {
            Storage.setValue("sensor_temp", temperature);
        }
	}
    
    function getServiceDelegate(){
		return [new TemperatureServiceDelegate()];
	}

}