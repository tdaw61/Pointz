function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#img_prev')
                .attr('src', e.target.result)
                .width(75)
                .height(90);
            $('#img_prev').show();
            $('.userpost-extras').show();
        };

        reader.readAsDataURL(input.files[0]);
    }
}

function removePhoto(){
    $("#img_prev").hide();
    $('.userpost-extras').hide();
    $('#img_prev').attr('src', '');
    $('#lefile').val("");
}

$( "#img_prev_del" ).click(function() {
    alert( "Handler for .click() called." );
});
