def rps(user_choice)
  winning_choices = {:rock => :scissors, :scissors => :paper, :paper => :rock }
  ai_choice = winning_choices.keys.to_a.sample
  game_status_list = { :win => "Win", :lose => "Lose", :draw => "Draw" }
  if user_choice.to_sym == ai_choice
    game_status = :draw
  elsif winning_choices[user_choice.to_sym] == ai_choice
    game_status = :win
  else
    game_status = :lose
  end
  puts "#{ai_choice.to_s.capitalize}, #{game_status_list[game_status]}"
end

def remix(arr)
  alcohols = []
  mixers = []
  new_drinks = []
  arr.each do |pair|
    alcohols << pair[0]
    mixers << pair[1]
  end
  alcohols.each { |alc| new_drinks << [alc, mixers.sample] }
  p new_drinks
end


#test

rps("Rock") # => "Paper, Lose"
rps("Scissors") # => "Scissors, Draw"
rps("Scissors") # => "Paper, Win"

remix([
  ["rum", "coke"],
  ["gin", "tonic"],
  ["scotch", "soda"]
])
