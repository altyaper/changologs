// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {

  $("#shareModal").on('hidden.bs.modal', function() {
    $('#shareModal #list-friends').html('');
  });

  $('#shareModal').on('shown.bs.modal', function () {

    var selectedFriends = [];
    var friends = [];

    $.get('/api/friends', function(data) {
      friends = data;
      for (var i = 0; i < data.length; i++) {
        var friend = data[i];
        $('#shareModal #list-friends').append('<li class="list-group-item d-flex align-items-center"><span class="mr-auto">'+ friend.first_name + ' '+ friend.last_name +'</span><button data-user-selected="false" data-user-id="'+ friend.id +'" data-user-index-id="'+ i +'" class="btn btn-primary">Add</button></li>')
      }
    });

    $("#shareModal #list-friends").on('click', 'button', function() {
      var self = $(this);
      var index = self.data('user-index-id');
      var isSelected = self.data('user-selected');
      if (!isSelected) {
        selectedFriends.push(friends[index]);
        self.data('user-selected', true);
        self.html('Added');
        var tag = "<div data-user-id='"+ friends[index].id +"' class='tag mx-1'><span data-user-badge='"+ friends[index].id +"' class='badge badge-secondary'>"+ friends[index].first_name +" <button class='delete' data-user-id='"+ friends[index].id+"'>x</button></span></div>";
        $("#shareModal .selected-friends").append(tag)
      }
    });

    $("#shareModal .selected-friends").on('click', 'button', function() {
      
      var tags = $('#shareModal .selected-friends div');
      var selectedTag = $(this).data('user-id');
      for (var i = 0; i < tags.length; i++) {
        var tag = tags[i];
        var userId = $(tag).attr('data-user-id');
        if (userId == selectedTag) {
          $(this).closest('.tag').remove();
        }
      }

    });

    $("#share-board-button").on('click', function() {
      $.post('/api/friendship', { users: selectedFriends })
        .done(function() {
          console.log('finished');
        });
    });
  });

})
