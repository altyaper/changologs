// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$( document ).on('turbolinks:load', function() {

  $('#datepicker').datepicker({
    format: 'mm/dd/yyyy',
    autoclose: true,
    todayHighlight: true,
  });

  $("#shareModal").on('hidden.bs.modal', function() {
    $('#shareModal #list-friends').html('');
  });

  $('#shareModal').on('shown.bs.modal', () => {

    var selectedFriends = [];
    var friends = [];
    
    $.get('/api/friends', {board_id: boardSelector}, (data) => {
      friends = data;
      if (friends.length) {
        $('#shareModal #list-friends').html('');
      }
      for (var i = 0; i < data.length; i++) {
        var friend = data[i];
        $('#shareModal #list-friends').append('<li class="list-group-item d-flex align-items-center"><span class="mr-auto"><strong>'+ friend.first_name + ' '+ friend.last_name + '</strong>('+ friend.email + ')</span><button data-user-selected="false" data-user-id="'+ friend.id +'" data-user-index-id="'+ i +'" class="btn btn-primary">Add</button></li>')
      }
    });

    $("#shareModal #list-friends").on('click', 'button', () => {
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

    $("#shareModal .selected-friends").on('click', 'button', () => {
      
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

    $("#share-board-button").on('click', () => {
      var ids = selectedFriends.map(function(value) { return value.id });
      var board_id = $(this).data('board-id');
      $.post('/api/boards/share', { ids: ids, board_id: board_id })
        .done(function(data) {
          $("#shareModal").modal('hide');
        });
    });
  });

})
