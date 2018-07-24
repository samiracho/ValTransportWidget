using Toybox.System;
using Toybox.WatchUi;
using Toybox.Communications;

class UpdateBehaviorDelegate extends WatchUi.BehaviorDelegate {
 
 	var callback;
 	var bikeStations      = "166,13";
 	var requestInProgress = false;
 	var progressBar;
    
    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        callback = handler;   
        progressBar = new WatchUi.ProgressBar(
            "Actualizando",
            null
        );
        getData();
    }
    
    function onSelect() {
        getData();
    }
    
    function getData(){  
    	if( !System.getDeviceSettings().phoneConnected ){
    		callback.invoke("COMM_ERROR");
    	} else {
    		if( !requestInProgress ){
    			makeRequest();
    		}
    	}
    }
    
    function makeRequest() {
        requestInProgress = true;
        setProgressBar(true);
        Communications.makeWebRequest(
            "https://script.google.com/macros/s/AKfycbxSzTHbpz5Lp4YCfH8qK2kkoD_iIjXgw1q8x38ixFrbMHtxb-E7/exec?number="+bikeStations+"&fields=address",{},
            {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            method(:onReceive)
        );
    }
    
    function onReceive(responseCode, data) {
        requestInProgress = false;
        if (responseCode == 200) {
             callback.invoke(data);
        } else {
            callback.invoke("Failed to load\nError: " + responseCode.toString());
        }
        setProgressBar(false);
    }
    
    function setProgressBar(show){  
    	if (show) {
	        WatchUi.pushView(
	            progressBar,
	            new ProgressDelegate(),
	            WatchUi.SLIDE_IMMEDIATE
	        );
	    } else {
	    	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	    }
    }
}