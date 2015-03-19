$(document).on("focus", "[data-behaviour~='datepicker']", function (e) {
    $(this).datepicker({"format": "mm/dd/yyyy", "weekStart": 1, "autoclose": true, "orientation": "bottom right"})
});

$(document).ready(function(){
    $("#datepicker-icon").on("click", function(){
        $("[data-behaviour~='datepicker']").datepicker('show');
    })
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