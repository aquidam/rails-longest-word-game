require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    generate_start_time
    generate_game_array
  end

  def score
    generate_end_time
    @answer = params[:answer]
    @game_array = params[:game_array].split(' ')
    @result_message = ''
    dictionary_validation if letters_validation
  end

  private

  def wording
    @test = "Sorry but #{@answer.upcase} can't be build out of #{@game_array.join(', ').upcase}"
  end

  def generate_start_time
    @start_time = Time.now
  end

  def generate_end_time
    @start_time = Time.new(params[:start_time])
    @end_time = Time.now
  end

  def generate_game_array
    alphabet_array = ('a'..'z').to_a
    @game_array = []
    10.times do
      @game_array << alphabet_array.sample
    end
  end

  def dictionary_validation
    url = 'https://wagon-dictionary.herokuapp.com/'
    response = open("#{url}#{@answer}").read
    @dictionary_response = JSON.parse(response)
  end

  def letters_validation
    answer_hash = letters_to_hash(@answer.split(//))
    game_hash = letters_to_hash(@game_array)
    answer_hash <= game_hash
  end

  def letters_to_hash(word)
    new_hash = {}
    word.each { |char| new_hash[char.to_sym] = word.count(char) }
    new_hash
  end
end
