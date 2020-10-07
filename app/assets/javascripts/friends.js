// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$( document ).on('turbolinks:load', function() {

  $("#add-friend-form").on('submit', function(event) {
    event.preventDefault();
  });

  var validateEmail = function(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
  }

  $("#friend-request-input").on('keyup', function(event) {
    var value = event.target.value;
    if (value.length < 4) return;
    // if (!validateEmail(value)) return;
    $.get('/api/users/search_friends?q=' + value, function(data) {
      $("#possible-friends-list").html('');
      for (var i = 0; i < data.length; i++) {
        var user = data[i];
        var newItem = $("<li class='d-flex align-items-center list-group-item'><span class='mr-auto'>" + user.email + "</span><button class='btn btn-primary' data-user-id='"+ user.id +"'>Add</div></li>");
        $("#possible-friends-list").append(newItem);
      }
    });
  });
  var handleAddButton = function(event) {
    var self = $(this);
    var userId = self.data('user-id');
    $.post('/api/friend_requests', { userId:userId })
      .done(function() {
        self.addClass('friend-request-added').html('Sent').prop('disabled', true);;
      });
  }

  $("#possible-friends-list").on('click', 'button', handleAddButton);

  var handleAcceptFriendRequest = function(event) {
    var self = $(this);
    var userId = self.data('user-id');
    $.post('/api/friends', { userId:userId })
      .done(function() {
        self.addClass('friend-request-added').html('Added').prop('disabled', true);;
      });
  }

  $('#friend-requests-list').on('click', 'button', handleAcceptFriendRequest);
});

