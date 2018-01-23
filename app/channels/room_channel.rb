class RoomChannel < ApplicationCable::Channel

  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    if ActionCable.server.connections.none?(&:current_user)
      Message.destroy_all
    end
  end

  def speak(data)
    client_action = data[ "message" ]
    p '*****************CLIENT_ACTION*****************', client_action
    @game = Game.find_by( started: false ) || Game.find( @current_user.game.id )
    current_user.user_action( client_action[ "user_action" ] ) if client_action[ "user_action" ]

    if client_action["join"]
      @game.add_player( current_user )
    elsif client_action["start-game"]
      start_game( @game )
    elsif @game.started
      @game = Game.find( @game.id )
      game_play( @game )
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
    game_play( game )
  end

  def update_players( game )
    RenderPlayerJob.perform_later game
  end

  def game_play( game )

  end

end
