using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;


class ValTransportWidgetView extends WatchUi.View {

	hidden var _data    = null;
	hidden var _error   = null;
	hidden var _loading = false;
	
    var station1NameView;
    var station1AvaiView;
	var station2NameView;
	var station2AvaiView;
	var viewLastUpdate;
	var commErrorLayout;
	var loadingLayout;
	
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
        commErrorLayout = new Rez.Drawables.CommError();
        loadingLayout   = new Rez.Drawables.Loading();
        _data           = Application.getApp().getProperty("STATIONSDATA");
         
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

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);	
		if(_error) {
    		commErrorLayout.draw(dc);	
		} else if (_loading == true) {
    		loadingLayout.draw(dc);
        } else {
        	printData();
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    
    }
    
    function onDataRetrieved(data) {
    	
    	if (data instanceof Dictionary) {
    		_error   = null;
    		_data    = data;	
    		Application.getApp().setProperty("STATIONSDATA", data);
    	} else if (data instanceof Boolean) {
    		_loading = data;
    	} else {
    		_error = data;	
    	}
    	
    	WatchUi.requestUpdate();
    }
    
    function printData() {
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
    }
    
    function calcUpdatedSince() {
    	var lastUpdate = _data["lastUpdateEpoch"].toNumber();
    	var text = "";
    	
    	if ( lastUpdate instanceof Number ) { 	
		  	var now        = Time.now().value();
		  	var diffSecs   = now - lastUpdate;  	
		  	var minutes    = Math.floor(diffSecs / 60);
		  	var seconds    = diffSecs - minutes * 60;
		  	text           = minutes > 60 ? "+1h" : ( minutes > 0 ? minutes+"m "+seconds+"s" : seconds+"s" );	  	
	  	} else {
	  		text = "N/A";
	  	}
	  	return text;
    }
    
    function cutText(text, maxSize) {
		var myText = text.length() > maxSize ? text.substring(0, maxSize) : text;
		return myText.toString();    
	}
}
