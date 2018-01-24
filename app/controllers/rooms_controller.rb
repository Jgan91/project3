class RoomsController < ApplicationController
  def show
    if @current_user
      @current_user.cards.destroy_all
      @messages = Message.all.reverse
      @game = join_or_create_game
      @game_cards = Card.where(user_id: @current_user.id)
      @cards = @current_user.cards
    end
  end

  def join_or_create_game
    if Game.last && !Game.last.started
      Game.last
    else
      Game.create
    end
  end
end
