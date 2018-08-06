require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []

    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end

  def score
    @word = params[:letter].upcase
    @included_result = included?(@word, params[:letters])
    @english_word_check = english_word?(@word)

    if @included_result && @english_word_check
      return @answer = "Congratulations #{@word} is a valid english word!"
    elsif @included_result && !@english_word_check
      return @answer = "Sorry but #{@word} does not seem a valid English word"
    else
      return @answer = "Sorry but #{@word} can't be build out of #{params[:letters]}"
    end
  end

  private

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

end
