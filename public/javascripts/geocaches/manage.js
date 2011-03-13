Event.observe( window, 'load', function() {
    obj = $('rating');
    Event.observe(obj, 'change', function() {saveRating(obj.options[obj.selectedIndex].value)});
});

function saveRating(rating) {
    geocache_id = $('geocache_id').value;
    new Ajax.Request('/geocaches/save_rating',
        {
            method: 'post',
            parameters: {geo_rating: rating, geo_id: geocache_id}, 
            onSuccess: function(transport) {
                    $('rating_div').update("<div id=\'rating_div\'>"+rating+"</div>");
                },
            onFailure: function(){ alert('Failed to save rating, please try again') }
        });
}
