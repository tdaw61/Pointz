$(document).on("focus", "[data-behaviour~='datepicker']", function (e) {
    $(this).datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true, "orientation": "bottom right"})
});

$(function(){
    $(".datepicker-icon").datepicker({"format": "yyyy-mm-dd", "weekStart": 1, "autoclose": true, "orientation": "bottom right"});
});

function clickable()
{
    $(document).ready(function ($) {
        $("tr[data-link]").off("click").on('click', function () {
            alert("yeah");
            $.ajax(this.dataset["link"], {type: 'get'})
        });
    });
}

//$(document).ready(function(){
//    clickable();
//});