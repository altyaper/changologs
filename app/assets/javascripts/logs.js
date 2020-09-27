// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(() => {
  const cleanSelectedColors = function() {
    const colorTags = $('.color-select__color');
    for (let i = 0; i < colorTags.length; i++) {
      const tag = colorTags[i];
      $(tag).removeClass('selected');
    }
  }
  $('.color-select__color').on('click', function() {
    cleanSelectedColors()
    $(this).addClass('selected');
    const color = $(this).data('color');
    console.log(color);
    $("#color-input").attr("value", color);
  });
});