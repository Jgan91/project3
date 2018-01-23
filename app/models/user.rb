class User < ApplicationRecord
  has_secure_password

  validates_presence_of :username, :email
  validates_uniqueness_of :username, :email

  belongs_to :game, required: false
  has_many :cards

  def user_action( action )
    if action == "hit"
      hit
    end
  end

  def hit
    Message.create! content: "#{ username }: Hit"
    p "Self:", self
    self.cards << cards.delete( cards.order( "random()" ).limit(1) )
    p self.cards
    # current_user.cards << cards.delete( cards.order( "random()" ).limit(1) )
  end

end
