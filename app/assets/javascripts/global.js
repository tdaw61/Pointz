//bind events
$(document).ready(function(){
    $('body').on('click', '.img-prev-del', function(){
        element = this.getAttribute("data-target");
        removePhoto(element);
    })
});

$(document).ready(function(){
    $("body").on('click','.photo-btn', function(){
        form = this.getAttribute("data-target");
        $(form).find('input[id=lefile]').click();
    })
});

$(document).ready(function(){
    $("#apply-crop-btn").on('click', function(){
//        var file = $("#lefile").prop("files")[0]
        var src = $("#user_picture_previewbox").attr("src");
        $("#img-prev").attr('src', src);
        resizePreview();
    })
});


function addPhoto(input, id) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            ele= $(id);
            ele.find("#img-prev")
                .attr('src', e.target.result)
                .width(75)
                .height(90);
            ele.find("#img-prev").show();
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

function removePhoto(ele){

    ele.find("#img-prev").hide();
    ele.find('.post-extras').hide();
    ele.find('#img-prev').attr('src', '');
    ele.find('#lefile').val("");
}

function resizePreview(){
    var coordx = $('#user_picture_crop_x').val();
    var coordy = $('#user_picture_crop_y').val();
    var coordw = $('#user_picture_crop_w').val();
    var coordh = $('#user_picture_crop_h').val();
    $('#img-prev').css({
        width: Math.round(100 / coordw * $('#user_picture_cropbox').width()) + 'px',
        height: Math.round(100 / coordh * $('#user_picture_cropbox').height()) + 'px',
        marginLeft: '-' + Math.round(100 / coordw * coordx) + 'px',
        marginTop: '-' + Math.round(100 / coordh * coordy) + 'px'
    });
}
