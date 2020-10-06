class BoardPolicy < ApplicationPolicy
  attr_reader :user, :board

  def initialize(user, board)
    @user = user
    @board = board
  end

  def show?
    Board.find(board.id).user_id == user.id ||
      UserBoard.where('user_id = ? AND board_id = ?', user.id, board.id).any?
  end

  def update
    Board.find(board.id).user_id == user.id
  end

end