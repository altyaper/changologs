// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  const cleanSelectedColors = function() {
    var colorTags = $('.color-select__color');
    for (let i = 0; i < colorTags.length; i++) {
      var tag = colorTags[i];
      $(tag).removeClass('selected');
    }
  }
  $('.color-select__color').on('click', function() {
    cleanSelectedColors()
    $(this).addClass('selected');
    var color = $(this).data('color');
    $("#color-input").attr("value", color);
  });
});