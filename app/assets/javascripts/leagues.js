$('#submit').click(function(){
    this.prop("disabled",true)
});


function collapse(type)
{
    $(document).ready(function ($) {
        $("tr[data-link]").off("click").on('click', function () {
            alert("yeah");
            $.ajax(this.dataset["link"], {type: 'get'})
        });
    });
}
