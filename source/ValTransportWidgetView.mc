using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;


class ValTransportWidgetView extends WatchUi.View {

	hidden var _data    = null;
	hidden var _error   = null;
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
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        _data = Application.getApp().getProperty("STATIONSDATA");  
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
		
		printData();
    }
    
    function onDataRetrieved(data) {
    	if (data instanceof Dictionary) {
    		_error = null;
    		_data  = data;	
    		Application.getApp().setProperty("STATIONSDATA", data);
    	} else {
    		_error = data;
    		WatchUi.requestUpdate();
    	}
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
		
		if(_error) {
			var commErrorLayout = new Rez.Drawables.CommError();
    		commErrorLayout.draw(dc);
		}
		
        printData();        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    
    }
    
    function printData(){
        
        if(_data instanceof Dictionary) {
            
        	var station1Name = cutText(_data["stations"][0]["address"],7);
        	var station2Name = cutText(_data["stations"][1]["address"],7);
        	
        	// Bike station 1
        	station1NameView.setText(station1Name);
        	station1AvaiView.setText(_data["stations"][0]["available"]);
        	station1AvaiView.setColor(colors.get(_data["stations"][0]["color"]));
        	
        	// Bike station 2    	
        	station2NameView.setText(station2Name);
        	station2AvaiView.setText(_data["stations"][1]["available"]);
        	station2AvaiView.setColor(colors.get(_data["stations"][1]["color"]));
        	
			viewLastUpdate.setText(calcUpdatedSince());
        }
        return true;
    }
    
    function calcUpdatedSince(){
    	var lastUpdate = _data["lastUpdateEpoch"].toNumber();
	  	var now        = Time.now().value();
	  	var diffSecs   = now - lastUpdate;
	  	
	  	var minutes    = Math.floor(diffSecs / 60);
	  	var seconds    = diffSecs - minutes * 60;
	  	var text       = minutes > 0 ? minutes+"m "+seconds+"s" : seconds+"s";
	  	return text;
    }
    
    function cutText(text, maxSize) {
		var myText = text.length() > maxSize ? text.substring(0, maxSize) : text;
		return myText.toString();    
	}
}
