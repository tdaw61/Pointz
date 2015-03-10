function addPhoto(input, id) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            ele= $(id);
            ele.find("#img_prev")
                .attr('src', e.target.result)
                .width(75)
                .height(90);
            ele.find("#img_prev").show();
            ele.find('.post-extras').show();
        };

        reader.readAsDataURL(input.files[0]);
    }
}

function addAvatar(input, id) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $("#crop-window").modal("show");
            $("#crop-window").find("#user_picture_cropbox").attr('src', e.target.result);
            $(".jcrop-holder img").attr('src', e.target.result);
            $("#user_picture_previewbox").attr('src', e.target.result);
        };
        reader.readAsDataURL(input.files[0]);
    }
}

function removePhoto(id){

    if(id)
        ele = $('#userpost_'+id);
    else
        ele = $('#userpost-form');
    ele.find("#img_prev").hide();
    ele.find('.post-extras').hide();
    ele.find('#img_prev').attr('src', '');
    ele.find('#lefile').val("");
}

$(document).ready(function(){
    $("#apply-crop-btn").on('click', function(){
//        var file = $("#lefile").prop("files")[0]
        var src = $("#user_picture_previewbox").attr("src");
        $("#img_prev").attr('src', src);
        resizePreview();
    })
});


function resizePreview(){
    var coordx = $('#user_picture_crop_x').val();
    var coordy = $('#user_picture_crop_y').val();
    var coordw = $('#user_picture_crop_w').val();
    var coordh = $('#user_picture_crop_h').val();
    $('#img_prev').css({
        width: Math.round(100 / coordw * $('#user_picture_cropbox').width()) + 'px',
        height: Math.round(100 / coordh * $('#user_picture_cropbox').height()) + 'px',
        marginLeft: '-' + Math.round(100 / coordw * coordx) + 'px',
        marginTop: '-' + Math.round(100 / coordh * coordy) + 'px'
    });
}

$(document).ready(function(){
    $('.modal-backdrop').on('click', function(){
        $('#photo-lightbox').modal('hide');
        $('body').removeClass('modal-open');
        $('.modal-backdrop').remove();
    });

});