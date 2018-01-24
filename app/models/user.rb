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
    if player.action == 2 then return end
    Message.create! content: "#{ username }: Hit"
    game = player.game
    game_card = game.cards.order( "random()" ).limit(1)
    player.cards << game.cards.delete( game_card )

    getHandValue( player )

    checkWinners( player_id )

    # player_card_values = player.cards.map { |cardObj| cardObj.value }
    # player_cards_to_i = player_card_values.map { |i| getValue(i) }
    # # sum = player_card_values.reduce { |memo, i| memo + getValue(i) }
    # sum = player_cards_to_i.reduce { |memo, i| memo + i }
    # if sum > 21
    #   player.update( action: 2 )
    # elsif sum == 21
    #   player.update( action: 1 )
    # end
    # p "*******************Player Action***************", player.action

    GameCardJob.perform_later( game_card[0], player_id )
  end

  def stay( player_id )
    Message.create! content: "#{ username }: Stay"
    player = User.find( player_id )
    player.update( action: 2 )

    checkWinners( player_id )

    # if ( player.game.users.all? { |player| player.action == 2 } )
    #   # get user hand values
    #   all_players = player.game.users.map { |player| getHandValue( player ) }
    #   sorted_players = all_players.sort { |x, y| y[ "hand_value" ] <=> x[ "hand_value" ] }
    #   filtered_players = sorted_players.select { |e| e[ "hand_value" ] <= 21 }
    #   # max of 21 less
    #   winners = []
    #   filtered_players.each_with_index do |value, i|
    #     if filtered_players.count == 1
    #       winners << filtered_players[i]
    #       break
    #     elsif filtered_players[i][ "hand_value" ] == filtered_players[ i + 1 ][ "hand_value" ]
    #       winners << filtered_players[i] << filtered_players[ i + 1 ]
    #     else
    #       winners << filtered_players[i]
    #       break
    #     end
    #   end
    #   winners
    #   p "*******************All Hand values***************", winners
    #   if winners.count == 1
    #     winner_id = winners[0][ "id" ]
    #     p "*******************Winner ID***************", winner_id
    #
    #     username = User.find( winner_id ).username
    #     Message.create! content: "#{ username } WINS"
    #   end
    # end
  end

  def getValue( card )
    if card == "ACE"
      value = 11
    elsif card.to_i == 0
      value = 10
    else
      value = card.to_i
    end
  end

  def getHandValue( player )
    player_card_values = player.cards.map { |cardObj| cardObj.value }
    player_cards_to_i = player_card_values.map { |i| getValue(i) }
    # sum = player_card_values.reduce { |memo, i| memo + getValue(i) }
    sum = player_cards_to_i.reduce { |memo, i| memo + i }
    if sum > 21
      player.update( action: 2 )
    elsif sum == 21
      player.update( action: 1 )
    end
    hand_value = { 'id' => player.id, 'hand_value' => sum }
  end

  def checkWinners( player_id )
    player = User.find( player_id )
    if ( player.game.users.all? { |player| player.action == 2 } )
      # get user hand values
      all_players = player.game.users.map { |player| getHandValue( player ) }
      sorted_players = all_players.sort { |x, y| y[ "hand_value" ] <=> x[ "hand_value" ] }
      filtered_players = sorted_players.select { |e| e[ "hand_value" ] <= 21 }
      # max of 21 less
      winners = []
      filtered_players.each_with_index do |value, i|

        if filtered_players.count == 1
          winners << filtered_players[i]
          break
        elsif i == filtered_players.length - 1
          break
        else
          p "*******************All Hand values***************", filtered_players , filtered_players[i]
          if filtered_players[i][ "hand_value" ] == filtered_players[ i + 1 ][ "hand_value" ]
            winners << filtered_players[i] << filtered_players[ i + 1 ]
          end
        end
        # if filtered_players.count == 1
        #   winners << filtered_players[i]
        #   break
        # elsif filtered_players[i][ "hand_value" ] == filtered_players[ i + 1 ][ "hand_value" ]
        #   winners << filtered_players[i] << filtered_players[ i + 1 ]
        # else
        #   winners << filtered_players[i]
        #   break
        # end
      end
      winners
      # p "*******************All Hand values***************", winners
      if winners.count == 1
        winner_id = winners[0][ "id" ]
        # p "*******************Winner ID***************", winner_id

        username = User.find( winner_id ).username
        Message.create! content: "#{ username } WINS"
      else
        p "*******************Multiple Winners***************", winners
        winners.each do |winner|
          username = User.find( winner["id"] ).username
          Message.create! content: "#{ username } WINS"
        end
      end
    end
  end

end
