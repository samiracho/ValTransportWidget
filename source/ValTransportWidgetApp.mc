using Toybox.Application;
using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Time;


class ValTransportWidgetApp extends Application.AppBase {

    var bikeStations = "166,13";
    
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	makeRequest();
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new ValTransportWidgetView(null) ];
    }
    
    function makeRequest() {
        Communications.makeWebRequest(
            "https://script.google.com/macros/s/AKfycbxSzTHbpz5Lp4YCfH8qK2kkoD_iIjXgw1q8x38ixFrbMHtxb-E7/exec?number="+bikeStations+"&fields=address",
            {
            },
            {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            method(:onReceive)
        );
    }
    
    function onReceive(responseCode, data) {
        if (responseCode == 200) {
             calcUpdatedSince(data);
             WatchUi.switchToView(new ValTransportWidgetView(data), null, WatchUi.SLIDE_IMMEDIATE);
        } else {
            Toybox.System.println("Failed to load\nError: " + responseCode.toString());
        }
    }
    
    function calcUpdatedSince(data){
    	var lastUpdate = data["lastUpdateEpoch"].toNumber();
	  	var now        = Time.now().value();
	  	var diffSecs   = now - lastUpdate;
	  	
	  	var minutes    = Math.floor(diffSecs / 60);
	  	var seconds    = diffSecs - minutes * 60;
	  	var text       = minutes > 0 ? minutes+"m "+seconds+"s" : seconds+"s";
	  	data.put("updatedSince", text);
    }
}