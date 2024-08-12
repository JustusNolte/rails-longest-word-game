require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    session[:scores]= 0
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @valid_word = valid_word?(@word, @letters)

    if @valid_word && english_word?(@word)
      @message = "Congratulations #{@word.upcase} is a valid English word!"
      round_score = @word.length  # Calculate the score for this round
      session[:scores] ||= []     # Initialize the session scores array if it doesn't exist
      session[:scores] << round_score # Add the round score to the session array
    elsif @valid_word
      @message = "Sorry #{@word.upcase} is not a valid English word!"
      round_score = 0  # No points for an invalid English word
      session[:scores] ||= []
      session[:scores] << round_score
    else
      @message = "Sorry, but #{@word.upcase} can't be built out of the given letters."
      round_score = 0  # No points if the word can't be built
      session[:scores] ||= []
      session[:scores] << round_score
    end

    @total_score = session[:scores].sum  # Calculate the total score
    render :score
  end

  def reset_score
    session[:scores] = []  # Clear the scores array
    redirect_to new_game_path, notice: 'Score has been reset!'
  end

  private

  def valid_word?(word, letters)
    word.upcase.chars.all? { |letter| letters.count(letter) >= word.upcase.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"

    begin
      response = URI.open(url).read
      json = JSON.parse(response)
      puts "API response: #{json.inspect}"
      json['found']
    rescue OpenURI::HTTPError => e
      if e.io.status[0] == '404'
        false
      else
        raise e
      end
    end
  end
end
