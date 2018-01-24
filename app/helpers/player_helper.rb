module PlayerHelper
  def reset( player )
    player.cards.delete_all
    player.update( action: 0 )
    player
  end
end
