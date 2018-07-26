using Toybox.System;
using Toybox.WatchUi;
using Toybox.Communications;

class UpdateBehaviorDelegate extends WatchUi.BehaviorDelegate {
 
 	var callback;
 	var bikeStations      = "166,13";
 	var requestInProgress = false;
    
    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        callback = handler;   
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
		callback.invoke(requestInProgress);
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
        callback.invoke(requestInProgress);
        if (responseCode == 200) {
             callback.invoke(data);
        } else {
            callback.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
    
}