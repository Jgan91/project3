class GameCardJob < ApplicationJob
  queue_as :default

  def perform( game_card, player_id  )
    ActionCable.server.broadcast player_id, game_card: render_game_card( game_card )
  end

  def render_game_card( game_card )
    ApplicationController.renderer.render( partial: "game_cards/game_card", locals: { game_card: game_card } )
  end
end
