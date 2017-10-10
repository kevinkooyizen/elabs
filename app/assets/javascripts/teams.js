$(document).ready(function (){
	$('#evalSlider').slider({
	range: true,
	min: 500,
	max: 2000,
	values: [500,2000],
	 slide: function(event, ui){
		$('#teams_search_min_rating').val(ui.values[0]);
		$('#teams_search_max_rating').val(ui.values[1]);
	}
	
	});
	$('#teams_search_min_rating').val($('#evalSlider').slider('values', 0));
	$('#teams_search_max_rating').val($('#evalSlider').slider('values', 1));

	$('#teams_search_min_rating').change(function(){
		$('#evalSlider').slider('values', 0, $(this).val());
	});

	$('#teams_search_max_rating').change(function(){
		$('#evalSlider').slider('values', 1, $(this).val());
	});
		
});

