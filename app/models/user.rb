class User < ApplicationRecord
  has_secure_password

  validates_presence_of :username, :email
  validates_uniqueness_of :username, :email

  belongs_to :game, required: false
  has_many :cards

  def user_action( action, player_id )
    if action == "hit"
      hit( player_id )
    elsif action == "stay"
      stay( player_id )
    end
  end

  def hit( player_id )
    player = User.find( player_id )
    p "*******************Player Action***************", player.action
    if player.action == 2 then return end
    Message.create! content: "#{ username }: Hit"
    game = player.game
    game_card = game.cards.order( "random()" ).limit(1)
    player.cards << game.cards.delete( game_card )

    GameCardJob.perform_later( game_card[0], player_id )
  end

  def stay( player_id )
    Message.create! content: "#{ username }: Stay"
    player = User.find( player_id )
    player.update( action: 2 )
  end

end
