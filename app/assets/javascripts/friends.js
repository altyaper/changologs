// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("turbolinks:load", function () {
  $("#add-friend-form").on("submit", function (event) {
    event.preventDefault();
  });

  $("#friend-request-input").on("keyup", (event) => {
    var value = event.target.value;
    if (value.length < 4) return;
    // if (!validateEmail(value)) return;
    $.get("/api/users/search_friends?q=" + value, (data) => {
      $("#possible-friends-list").html("");
      for (var i = 0; i < data.length; i++) {
        var user = data[i];
        let profilePicture = user.profile_picture
          ? `<img src='${user.profile_picture}' class='profile-picture mr-2' />`
          : `<i class="fa fa-user mr-2"></i>`;

        var newItem = $(
          "<li class='d-flex align-items-center list-group-item'>" +
            profilePicture +
            "<span class='mr-auto'>" +
            user.email +
            "</span><button class='btn btn-primary' data-user-id='" +
            user.id +
            "'>Add</div></li>"
        );
        $("#possible-friends-list").append(newItem);
      }
    });
  });

  var handleAddButton = function (event) {
    var self = $(this);
    var userId = self.data("user-id");
    $.post("/api/friend_requests", { userId: userId }).done(function () {
      self.addClass("friend-request-added").html("Sent").prop("disabled", true);
    });
  };

  $("#possible-friends-list").on("click", "button", handleAddButton);

  var handleAcceptFriendRequest = function (event) {
    var self = $(this);
    var userId = self.data("user-id");
    $.post("/api/friends", { userId: userId }).done(function () {
      self
        .addClass("friend-request-added")
        .html("Added")
        .prop("disabled", true);
    });
  };

  $("#friend-requests-list").on("click", "button", handleAcceptFriendRequest);

  $("#myModal").on("shown.bs.modal", function () {
    $("#myInput").trigger("focus");
  });
});
