$(document).on("focus", "[data-behaviour~='datepicker']", function (e) {
    $(this).datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true, "orientation": "bottom right"})
});


//$(document).ready(function($) {
//    $(".clickable").click(function() {
//        alert("this just got clicked");
//    });
//});
//
//$(document).ready(function($) {
//    $("tr[data-link]").click(function() {
//        alert("yeah");
//        window.location = this.data("link");
//    });
//});