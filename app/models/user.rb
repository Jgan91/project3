class User < ApplicationRecord
  has_secure_password

  validates_presence_of :username, :email
  validates_uniqueness_of :username, :email

  belongs_to :game, required: false
  has_many :cards

  def user_action( action, player_id )
    if action == "hit"
      hit( player_id )
    end
  end

  def hit( player_id )
    Message.create! content: "#{ username }: Hit"
    player = User.find( player_id )
    player_cards = player.cards
    game = player.game
    game_card = game.cards.order( "random()" ).limit(1)
    player.cards << game.cards.delete( game_card )
    p "GAME_CARD", game_card[0]

    GameCardJob.perform_later game_card[0]
  end

end
