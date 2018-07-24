using Toybox.Application;
using Toybox.WatchUi;
 

class ValTransportWidgetApp extends Application.AppBase {
    
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
    	var widgetView = new ValTransportWidgetView();
        return [ widgetView, new UpdateBehaviorDelegate(widgetView.method(:onDataRetrieved)) ];
    }
}