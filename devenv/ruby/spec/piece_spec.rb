require_relative '../piece'

describe Piece do
  context "teste para teste" do
    it "should not be equal" do
      one = Piece.new([1,2])
      two = Piece.new([2,3])

      expect(one.position).not_to be_equal(two.position)
    end
  end

end
