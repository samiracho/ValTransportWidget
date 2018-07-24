using Toybox.WatchUi;
using Toybox.Graphics;

class ValTransportWidgetView extends WatchUi.View {

	hidden var _data;
	
	var colors = {
    	"1"=>Graphics.COLOR_DK_GRAY,
    	"2"=>Graphics.COLOR_RED, 
    	"3"=>Graphics.COLOR_ORANGE,
    	"4"=>0xffff00,
    	"5"=>Graphics.COLOR_GREEN
    };
	
    function initialize(data) {
        View.initialize();
        
        if(data == null) {
        	_data = Application.getApp().getProperty("STATIONSDATA");
        } else {
        	_data = data;
        	Application.getApp().setProperty("STATIONSDATA", data);
        }
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        
        if(_data != null) {
        
        	var station1NameView = View.findDrawableById("station1Name");
        	var station1AvaiView = View.findDrawableById("station1Avai");
        	var station2NameView = View.findDrawableById("station2Name");
        	var station2AvaiView = View.findDrawableById("station2Avai");
        	var viewLastUpdate   = View.findDrawableById("lastUpdate");
        	
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

	function cutText(text, maxSize) {
		return text.length() > maxSize ? text.substring(0, maxSize) : text;    
	}

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }


}