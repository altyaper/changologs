$(document).on('turbolinks:load', function() {
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote({
      height: 300
    });
  });
});
    
      