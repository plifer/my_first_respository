#lesson_4 twenty-one

SUITS = ['Hearts', 'Spades', 'Diamonds', 'Clubs']
CARDS = ('2'..'10').to_a + ['Jack', 'Queen', 'King', 'Ace']
DECK = SUITS.product CARDS

def prompt(msg)
  puts "===> #{msg}"
end

def deck_shuffle
  DECK.shuffle
end

def remove_card_from_deck!(new_deck, card)
  card.flatten!
  new_deck.delete(card)
end

def draw_card(num, new_deck)
  card = []
  num.times do
    new_card = new_deck.sample  
    card << new_card
    remove_card_from_deck!(new_deck, new_card)
  end
  card
end

def game_message
prompt "           "
prompt "      ---------------"
prompt "      Welcome to 21!"
prompt "    Casino Patti Royale"
prompt "      ---------------"

end

def display_players_hand(players_hand) 
  arr = players_hand.collect(&:last)
  puts "Player has: #{arr.join(", ")}.\n"
end

def display_dealers_hand(dealers_hand)
  puts "\nDealer has #{dealers_hand.first.last} and an unknown card.\n\n"
end

def display_hand_with_suits(hand)
  hand.each {|x| puts "#{x[1]} of #{x[0]}"}
end

def input_answer
  puts "Would you like to hit or stay?"
  gets.chomp.downcase
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "Ace"
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
  end

  values.select { |value| value == "Ace" }.count.times do
    sum -= 10 if sum > 21
  end
  sum
end

def dealers_turn(dealers_hand, new_deck)
  while total(dealers_hand) < 17
    dealers_hand << draw_card(1, new_deck).first
  end
end

def busted?(hand)
  total(hand) > 21 
end

def player_hit(new_deck, players_hand)
  players_hand << draw_card(1, new_deck).first
end

def display_hands(dealers_hand, players_hand)
  display_dealers_hand(dealers_hand)
  display_players_hand(players_hand)
end

def compare_cards(dealers_hand, players_hand)
  player_total = total(players_hand)
  dealer_total = total(dealers_hand)

  if player_total > dealer_total
    return 'Player'
  end
  if dealer_total > player_total
    return 'Dealer'
  end
end

def display_winner(winner)
  if winner
    puts " "
    puts "***************** #{winner} is the winner!******************"
  else 
    puts "It's a tie."
  end 
end

def display_results(dealers_hand, players_hand)
  dealer_total = total(dealers_hand)
  player_total = total(players_hand)
  if (busted?(dealers_hand)) || (busted?(players_hand))
    busted_message(dealers_hand, players_hand)
  end
  puts "SCORE:"
  puts "\tDealer: #{dealer_total}\n\tPlayer: #{player_total}\n\n" 
  puts "GAME OVER!"
  puts "\nDealer had: "
  display_hand_with_suits(dealers_hand)
  puts "\nPlayer had: "
  display_hand_with_suits(players_hand)
end  

def busted_message(dealers_hand, players_hand)
  if busted?(dealers_hand)
    puts "\nDealer BUSTED!\n"
  elsif busted?(players_hand)
    puts "\nPlayer BUSTED!\n"
  else
    nil  
  end
end

def continue_game
  puts "\n ==>Play again? (enter 'y' to continue the game, enter any key to quit)\n"
  answer = gets.chomp
  answer.downcase == 'y'
end

loop do

  new_deck = deck_shuffle
  winner = nil
  answer = nil
  dealers_hand = draw_card(2, new_deck)
  players_hand = draw_card(2, new_deck)
  game_message
  display_hands(dealers_hand, players_hand)

  loop do 
    answer = input_answer

    if answer == 'hit'
      players_hand = player_hit(new_deck, players_hand)
      display_hands(dealers_hand, players_hand)
    end
    break if busted?(players_hand) || answer == 'stay'
  end

  if busted?(players_hand)
    winner = 'Dealer'
  end

  if answer == 'stay'
    dealers_turn(dealers_hand, new_deck)
    
    if busted?(dealers_hand)
      winner = 'Player' 
    end
  end

  if winner.nil?
    winner = compare_cards(dealers_hand, players_hand)
  end
  display_winner(winner)
  display_results(dealers_hand, players_hand)
  break unless continue_game
end
puts " "
puts "Thank you for playing 21 ~~ Hope you had fun!\n"
puts "  "