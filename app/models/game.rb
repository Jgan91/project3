class Game < ApplicationRecord
  has_many :users
  has_many :cards
  include PlayerHelper

  def add_player( player )
    Message.create! content: "#{ player.username }: has joined the game"
    users << reset( player )
  end

  def players
    users
  end

  def set_up_game
    Message.destroy_all
    set_player_order
    load_deck
    deal_starting_hand
  end

  def set_player_order
    if ordered_players = []
      new_order = players.shuffle
    else
      new_order = ordered_players.rotate(-1) if new_order[1] == ordered_players[1]
    end
    new_order = new_order.map do |player|
      player.id
    end
    update( ordered_players: new_order )
  end

  def load_deck
    deck = CardsService.new.deck_of_cards_hash.map do |card|
      Card.find_or_create_by( value: card[ :value ], suit: card[ :suit ], image: card[ :image ] )
    end
    self.cards = deck.shuffle
  end

  def deal_starting_hand
    find_players.each do |player|
      2.times { player.cards << cards.delete( cards.order( "random()" ).limit(1) ) }
    end
  end

  def find_players
    p 'ordered_players', ordered_players
    ordered_players.map do |id|
      User.find( id )
    end
  end


end
