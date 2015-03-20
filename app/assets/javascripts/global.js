//bind events
$(document).ready(function(){
    $('body').on('click', '.img-prev-del', function(){
        element = this.getAttribute("data-target");
        removePhoto(element);
        event.preventDefault();
    })
});

$(document).ready(function(){
   $('body').on('change', '#lefile', function(){
       form = this.getAttribute("data-target");
       addPhoto(this, form);
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
        var src = $("#user_picture_previewbox").attr("src");
        $("#img-prev").attr('src', src);
        resizePreview();
    })
});

$(document).ready(function(){
    $('body').on('hidden.bs.modal', '#modal-window', function () {
        $(this).removeData('#modal-window');
    });
});


function addPhoto(input, ele) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            img_prev = $('<img />', { id: "img-prev", src: e.target.result, alt: "imgage preview", width: 75, height: 90});
            del_link = $('<a />', {html: "X", class: "img-prev-del", attr: {'data-target': ele}});
            $(ele).find(".post-picture").append(img_prev).append($('<div/>', {class: "center", html: del_link}));
            $(ele).find(".post-extras").show();
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
    $(ele).find("#img-prev").remove();
    $(ele).find(".img-prev-del").remove();
    $(ele).find('.post-extras').hide();
    $(ele).find('#lefile').val("");
    $(ele).find(".center").remove();
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
