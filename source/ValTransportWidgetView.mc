using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;


class ValTransportWidgetView extends WatchUi.View {

	hidden var _data    = null;
	hidden var updated  = false;
	var bikeStations    = "166,13";
    var station1NameView;
    var station1AvaiView;
	var station2NameView;
	var station2AvaiView;
	var viewLastUpdate;

	
	hidden var colors = {
    	"1"=>Graphics.COLOR_DK_GRAY,
    	"2"=>Graphics.COLOR_RED, 
    	"3"=>Graphics.COLOR_ORANGE,
    	"4"=>0xffff00,
    	"5"=>Graphics.COLOR_GREEN
    };
	
    function initialize() {
        View.initialize();
        _data = Application.getApp().getProperty("STATIONSDATA");     
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        station1NameView = View.findDrawableById("station1Name");
    	station1AvaiView = View.findDrawableById("station1Avai");
		station2NameView = View.findDrawableById("station2Name");
		station2AvaiView = View.findDrawableById("station2Avai");
		viewLastUpdate   = View.findDrawableById("lastUpdate");
		
    	makeRequest();
    	printData();
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        System.println("onUpdate");
        
        var mySettings = System.getDeviceSettings();
        checkConnected(dc, mySettings);
        
        if(updated) {
        	System.println("Data updated");
        	printData();
        	updated = false;
        }
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    
    }
    
	function checkConnected(dc, mySettings){
		if(!mySettings.phoneConnected){
			var commErrorLayout = new Rez.Drawables.CommError();
    		commErrorLayout.draw(dc);
    		return false;
		} else {
			return true;
		}
	}
    
    function makeRequest() {
        Communications.makeWebRequest(
            "https://script.google.com/macros/s/AKfycbxSzTHbpz5Lp4YCfH8qK2kkoD_iIjXgw1q8x38ixFrbMHtxb-E7/exec?number="+bikeStations+"&fields=address",{},
            {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            method(:onReceive)
        );
    }
    
    function onReceive(responseCode, data) {
        if (responseCode == 200) {
             
             calcUpdatedSince(data);
             Application.getApp().setProperty("STATIONSDATA", data);
             _data = data;
             updated = true;
             WatchUi.requestUpdate();
             

        } else {
            Toybox.System.println("Failed to load\nError: " + responseCode.toString());
        }
    }
    
    function printData(){
        
        if(_data != null) {
            
        	var station1Name = cutText(_data["stations"][0]["address"],7);
        	var station2Name = cutText(_data["stations"][1]["address"],7);
        	
        	station1NameView.setText(station1Name);
        	station1AvaiView.setText(_data["stations"][0]["available"]);
        	station1AvaiView.setColor(colors.get(_data["stations"][0]["color"]));
        	
        	station2NameView.setText(station2Name);
        	station2AvaiView.setText(_data["stations"][1]["available"]);
        	station2AvaiView.setColor(colors.get(_data["stations"][1]["color"]));
        	
			viewLastUpdate.setText(_data["updatedSince"]);
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
    
    function cutText(text, maxSize) {
		var myText = text.length() > maxSize ? text.substring(0, maxSize) : text;
		return myText.toString();    
	}
}
