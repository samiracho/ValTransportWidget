using Toybox.WatchUi;

class ProgressDelegate extends WatchUi.BehaviorDelegate
{
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        return true;
    }
}