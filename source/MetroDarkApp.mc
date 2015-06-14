using Toybox.Application as App;

class MetroDarkApp extends App.AppBase {
    function getInitialView() {
        return [ new MetroDarkView() ];
    }
}