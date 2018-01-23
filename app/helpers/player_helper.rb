module PlayerHelper
  def reset( player )
    player.cards.delete_all
    player
  end
end
