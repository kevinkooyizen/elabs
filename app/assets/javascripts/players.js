document.addEventListener("turbolinks:load", function (){
	$('#slider').slider({
	range: true,
	min: 1000,
	max: 10000,
	values: [1000,10000],
	 slide: function(event, ui){
		$('#search_mmr_lower_range').val(ui.values[0]);
		$('#search_mmr_upper_range').val(ui.values[1]);
	}
	
	});
	$('#search_mmr_lower_range').val($('#slider').slider('values', 0));
	$('#search_mmr_upper_range').val($('#slider').slider('values', 1));

	$('#search_mmr_lower_range').change(function(){
		$('#slider').slider('values', 0, $(this).val());
	});

	$('#search_mmr_upper_range').change(function(){
		$('#slider').slider('values', 1, $(this).val());
	});
		
});