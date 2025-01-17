require './lib/game.rb'

describe Game do 

  let(:player){ double :player, 
                name: 'Jake',
                pins_rest: 5,
                frame: 5,
                roll: 1,
                score: 100,
                count_next: 1
              }
  let(:player_4_left){ double :player, 
                name: 'Jake',
                pins_rest: 4
              }
  let(:player_end){ double :player, 
                name: 'Jake', 
                pins_rest: 4,
                frame: 10, 
                roll: 2, 
                score: 200, 
                count_next: 0
              }
  let(:player_extra){ double :player,
                count_next: 1
              }

  let(:subject){ described_class.new(player.name) }
  let(:subject_4_left){ described_class.new(player_4_left.name, player_4_left.pins_rest) }
  let(:subject_game_has_ended){ described_class.new(player_end.name, player_end.pins_rest, player_end.frame, player_end.roll, player_end.score, player_end.count_next) }
  let(:subject_game_has_extra_roll){ described_class.new(player_end.name, player_end.pins_rest, player_end.frame, player_end.roll, player_end.score, player_extra.count_next) }

  let(:list){ ['player', 'frame', 'roll', 'score', 'count_next'] }

  it 'expects the instantiated class should hold these state instance variables' do
    list.each do |state|
      expect(subject).to respond_to(state)
    end
  end

  it 'expected to respond to method register_pins with 1 argument and return true' do 
    expect(subject).to respond_to(:register_pins).with(1).argument
  end

  it 'expects register_pins to raise error if argument(dropped pins number) passed is non digit' do 
    expect{ subject.register_pins('a') }.to raise_error('pins registration failed, not a number')
  end

  it 'expects register_pins to raise error if argument(dropped pins number) is smaller than 0 ' do
    expect{ subject.register_pins(-1) }.to raise_error('pins registration failed, number smaller than 0')
  end

  it 'expects register_pins to raise error if argument(dropped pins number) is greater than 10 ' do
    expect{ subject.register_pins(11) }.to raise_error('pins registration failed, number greater than 10')
  end

  it 'expects register_pins to raise error if argument(dropped pins number) is greater than pins_rest(left standing) ' do
    expect{ subject_4_left.register_pins(5) }.to raise_error('pins registration failed, number greater than rest of pins')
  end
  
  it 'expects register_pins to raise error if game has ended ' do
    expect{ subject_game_has_ended.register_pins(3) }.to raise_error('pins registration failed, game has ended')
  end

  # it 'expects register_pins to register pins having an extra round' do
  #   expect(subject_game_has_extra_roll.register_pins(3)).to eq('extra roll')
  # end

  context "check all values are numbers" do
    described_class.new("name").list_boundaries.each do |arg, max|
      it 'expects subject to raise error when initialized argument is a non-number' do
        allow(player).to receive(arg).and_return('a')
        expect{ described_class.new(player.name, player.pins_rest, player.frame, player.roll, player.score, player.count_next) }.to raise_error('player has non-number ' << arg.to_s)
      end
    end
  end

  context "check all values are not smaller than 0" do
    described_class.new("name").list_boundaries.each do |arg, max|
      it 'expects subject to raise error when initialized argument smaller than 0' do
        allow(player).to receive(arg).and_return(-1)
        expect{ described_class.new(player.name, player.pins_rest, player.frame, player.roll, player.score, player.count_next) }.to raise_error('player has negative ' << arg.to_s)
      end
    end
  end

  context "check all values are not greater than maximum allowed" do
    player_name = "Jake"
    described_class.new(player_name).list_boundaries.each do |arg, max|
      it 'expects subject to raise error when initialized argument greater than #{max}' do
        allow(player).to receive(arg).and_return(max + 1)
        expect{ described_class.new(player.name, player.pins_rest, player.frame, player.roll, player.score, player.count_next) }.to raise_error('player has ' << arg.to_s << ' greater than ' << max.to_s)
      end
    end
  end

  it 'expects the be 300(perfect game) ' do
    game = described_class.new(player.name)
    12.times do 
      game.register_pins(10)
    end
    expect(game.score).to eq(300)
  end

  it 'expects the be 0(gutter game) ' do
    game = described_class.new(player.name)
    20.times do 
      game.register_pins(0)
    end
    expect(game.score).to eq(0)
  end

  it 'expects the be 133(known game) ' do
    game = described_class.new(player.name)
    [1,4,4,5,6,4,5,5,10,0,1,7,3,6,4,10,2,8,6].each do |pins|
      game.register_pins(pins)
    end
    expect(game.score).to eq(133)
  end

end
