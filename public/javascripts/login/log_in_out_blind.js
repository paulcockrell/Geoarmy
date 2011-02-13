var log_in_out_blind = function(action) {

    function do_login() {
            new Effect.BlindUp('main_intro', { 
                duration: 1.0,
                afterFinish: function() { new Effect.BlindDown('main_user', { duration: .25 }) }
            });
    };

    function do_logout() {
            new Effect.BlindUp('main_user', {
                duration: .25,
                afterFinish: function() { $('main_intro').setStyle('display:none'); $('main_intro').removeClassName('main_closed'); $('main_intro').addClassName('main'); new Effect.BlindDown('main_intro', { duration: 1.0 }) }
            });
    };

    if (action=='login') {
        do_login();
    } 
    else if (action=='logout') {
        do_logout();
    }

}
