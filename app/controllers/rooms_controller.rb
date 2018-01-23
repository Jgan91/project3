class RoomsController < ApplicationController
  def show
    if @current_user
      @messages = Message.all.reverse
      @game = join_or_create_game
      @game_cards = Card.where(id: @current_user.id)
      # @game_cards = Card.where(id: @game.game_cards)
      p "*******************GAME_CARDS*******************", @game_cards
      # @game_cards = @current_user.cards
      @cards = @current_user.cards
    end
  end

  def join_or_create_game
    Game.last && !Game.last.started ? Game.last : Game.create
  end
end
