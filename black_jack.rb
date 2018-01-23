# implementation of BlackJack card game (pre-MTG!!)

require 'pry'

Suits = ["Clubs","Hearts","Spades","Diamonds"]
Ranks = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]

#define cards
  #display rank
class Card
  include Enumerable

  # Private class variables
  @@suit_value = Hash[ Suits.each_with_index.to_a ]
  @@rank_value = Hash[ Ranks.each_with_index.to_a ]

  attr_reader :rank, :suit
  attr_accessor :value

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    value = case @rank.to_i
    when 1
      11
    when 2..10
      @rank
    when 11..13
      10
    else
      nil
    end
  end

  def display_rank
    case @rank
    when "11"
      "Jack"
    when "12"
      "Queen"
    when "13"
      "King"
    when "1"
      "Ace"
    else
      @rank
    end
  end

  def output
    "#{ display_rank } of #{ @suit }, value #{ value }"
  end
end

#define deck
  #draw cards
  #shuffle cards
class Deck
  attr_accessor :cards

  # Create the deck of @cards[], for each suit and rank
  def initialize
    @cards = []
    Suits.each do | suit |
      Ranks.each do | rank |
        @cards << Card.new(rank, suit)
      end
    end
  end

  # Shuffle the deck destructively
  def shuffle!
    @cards.shuffle!
  end

  # Draw a card from the deck
  def draw
    @cards.pop
  end

  # Number of cards left in deck
  def remaining
    @cards.length
  end
end

$d = Deck.new

#define Player class
  #hand
  #ace ??
  #hit

class Player

  attr_accessor :hand, :hand_value, :ace_count

  def initialize
    @hand = []
    @hand_value = 0
    @ace_count = ace_count

    # Draw 2 cards and add to player's @hand[]
    2.times do
      card = $d.draw
      @hand_value == 0 ? @hand_value = card.value.to_i : @hand_value += card.value.to_i
      @hand << card
    end

  end

  def hit
    card = $d.draw
    @hand_value == 0 ? @hand_value = card.value.to_i : @hand_value += card.value.to_i
    @hand << card
  end

  # Ace: 11 or 1 ?
  # Treat the ace as 1 if otherwise busted
  def switch_ace
    # While hand > 21, at least 1 ace in hand
    while @hand_value > 21 && @ace_count > 0
      @ace_count -= 1
      @hand_value -= 10
    end
  end

  def output
    puts "#{@hand.to_s}, #{@hand_value} points!!"
  end
end

$d.shuffle!

player1 = Player.new
puts "Player 1 hand: #{ player1.output }"

player2 = Player.new
puts "Player 2 hand: #{ player2.output }"

#hit or stay?
if( player1.hand_value === 21 )
  puts "Player 1 wins!!!"
else
  # While player1
  until ( player1.hand_value > 21 )
    player1.switch_ace
    puts "hit or stay?"
    action = $stdin.gets.chomp

    if( action == "hit" )
      player1.hit
      puts player1.output
    else
      puts player1.output
      break
    end
  end
end

# Comapre player
if ( player1.hand_value <= 21)
  if ( player1.hand_value > player2.hand_value )
    puts "Player 1 wins!!"
  elsif ( player1.hand_value == player2.hand_value )
    puts "Game drawn!"
  else
    puts "Player 2 wins!"
  end
else
  puts "Player 1 bust :( Player 2 wins"
end

# binding.pry
