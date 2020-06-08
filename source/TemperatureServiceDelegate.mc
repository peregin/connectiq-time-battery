(:background)
class TemperatureServiceDelegate extends Toybox.System.ServiceDelegate {

	function initialize() {
		System.ServiceDelegate.initialize();
	}

	function onTemporalEvent() {
		var si = Sensor.getInfo();
		if (si has :temperature && si.temperature != null) {
		    //System.println("temperature=" + si.temperature);
			Background.exit(si.temperature);
		} else {
			Background.exit(0);
		} 
	}
}