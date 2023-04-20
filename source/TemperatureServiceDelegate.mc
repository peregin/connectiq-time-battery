(:background)
class TemperatureServiceDelegate extends Toybox.System.ServiceDelegate {

	function initialize() {
		System.ServiceDelegate.initialize();
	}

	function onTemporalEvent() {
		// Symbol 'getInfo' not available to 'Data Field', sensor needs to be accessed from a background service !!!
		var si = Sensor.getInfo();
		//System.println("si=" + si.temperature);
		if (si has :temperature && si.temperature != null) {
		    //System.println("temperature=" + si.temperature);
			Background.exit(si.temperature);
		} else {
			Background.exit(null);
		} 
	}
}