$(document).on("turbolinks:load", () => {
  $("#reveal-button").on("click", () => {
    if ($("#reveal-button").attr("revealed")) {
      $("#api-key-input").get(0).type = "password";
      $("#reveal-button").html("Reveal");
      $("#reveal-button").attr("revealed", null);
    } else {
      $("#api-key-input").get(0).type = "text";
      $("#reveal-button").html("Hide");
      $("#reveal-button").attr("revealed", "true");
    }
  });
});
