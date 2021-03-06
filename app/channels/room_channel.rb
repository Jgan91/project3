class RoomChannel < ApplicationCable::Channel

  def subscribed
    stream_from "room_channel"
    stream_from current_user.id
    current_user.cards.destroy_all
  end

  def unsubscribed
    if ActionCable.server.connections.none?(&:current_user)
      Message.destroy_all
    end
  end

  def speak(data)
    @game = Game.find_by( started: false ) || Game.find( current_user.game.id )

    client_action = data[ "message" ]
    current_user.user_action( client_action[ "user_action" ], current_user.id ) if client_action[ "user_action" ]

    if client_action["join"]
      @game.add_player( current_user )
    elsif client_action["start-game"]
      start_game( @game )
    elsif @game.started
      @game = Game.find( @game.id )
      # game_play( @game )
    end
  end

  private

  def broadcast( message )
    ActionCable.server.broadcast "room_channel", message
  end

  def start_game( game )
    return Message.create! content: "There must be at least 2 players to start" if Game.find( game.id ).players.count < 2
    game.update( started: true )
    p 'GAME.STARTED', game.started
    game.set_up_game

    update_players( game )
    broadcast start_game: "start_game"
    Message.create! content: "LET THE GAMES BEGIN!!!"
    # game_play( game )
  end

  def update_players( game )
    RenderPlayerJob.perform_later game
  end

  def game_play( game )
    action = game.game_action
    update_players( game )

    # game_play( game ) if action.is_a? Message
    if action.is_a User?
      broadcast user_id: action.id
      Message.create! content: "#{ action.username }'s turn"
      broadcast turn: "#{ action.id }"
    end
  end

end
