require_relative 'ruby_wars'

describe RubyWars, "#initialize" do
  it "Generates one human player and one computer player by default" do
    G = RubyWars.new( false )
    G.humans.should eq(1)
    G.computers.should eq(1)
  end
end

