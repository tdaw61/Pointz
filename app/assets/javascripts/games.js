$(document).on("focus", "[data-behaviour~='datepicker']", function (e) {
    $(this).datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true, "orientation": "bottom right"})
});


//$(document).ready(function($) {
//    $(".clickable").click(function() {
//        alert("this just got clicked");
//    });
//});
//

function clickable()
{
    $(document).ready(function ($) {
        $("tr[data-link]").click(function () {
            alert("yeah");
            $.ajax(this.dataset["link"], )
            window.location = this.dataset["link"];
        });
    });
}

$(document).ready(function(){
    clickable();
});