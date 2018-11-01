var $checks = $("input[type='checkbox']").change(function() {
    var checked = $checks.is(':checked');
    $("#rm_pkgs").toggle(checked);
});
$checks.first().change();

// $('#rm_pkgs').click(function(){
$('#confirmed').click(function(){
    var pkgs = [];
    $.each($("input[name='rm_pkg']:checked"), function(){
        pkgs.push($(this).val());
    });

    if (pkgs.length == 0) {
        alert('Please choose at least one value.');
    }
    else {
        alert(pkgs);

        data = JSON.stringify(pkgs);

        $.ajax({
            url: '/delete_pkgs/' + data + '/',
            type: 'DELETE',
            success: function(result) {
                alert(result)
                window.location.replace("/info");
            }
        });
    }
});
$('.message a').click(function(){
   $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
});