class Piece
  attr_accessor :position

  def initialize(position = nil)
    unless position.nil?
      @position = position
    else
      @posision = [1,10]
    end
  end
end
