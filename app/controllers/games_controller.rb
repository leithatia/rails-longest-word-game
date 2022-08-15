require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(7)
    @letters.map! { ("A".."Z").to_a.sample }
    return @letters
  end

  def score
    @letters = params[:letters]
    attempt = params[:word]

    word = check_word(attempt)
    letters_valid = attempt.upcase.chars.all? { |letter| attempt.upcase.count(letter) <= @letters.count(letter) }

    if letters_valid && word["found"]
      @result = "Well done!"
    elsif !letters_valid
      @result = "Sorry, but #{attempt} cannot be made out of the letters #{@letters}"
    else
      @result = "That is not an English word."
    end
  end

  private

  def check_word(user_word)
    url = "https://wagon-dictionary.herokuapp.com/#{user_word}"
    word_serialized = URI.open(url).read
    return JSON.parse(word_serialized)
  end
end
