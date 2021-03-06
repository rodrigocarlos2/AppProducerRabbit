#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

class InformationController < ApplicationController

  before_action :authenticate_user!

  # GET /information
  # GET /information.json
  def index
    @information = Information.all
    @city = City.find_by_user_id(current_user.id)
  end

  # GET /information/new
  def new
    @information = Information.new
  end

  # POST /information
  # POST /information.json
  def create
    @information = Information.new(information_params)
    @information.producer = current_user.id
    @city = City.find_by_user_id(current_user.id)

    @info = current_user.email + " says " + @information.content

    respond_to do |format|
      if @information.save

        conn = Bunny.new(:automatically_recover => false)
        conn.start

        ch       = conn.create_channel
        x        = ch.topic("topic_logs")
        severity = ARGV.shift || @city.name
        msg      = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

        x.publish(@info, :routing_key => severity)

        conn.close

        format.html { redirect_to information_index_path, notice: 'Information was successfully created.' }
        format.json { render :show, status: :created, location: information_index_path }
      else
        format.html { render :new }
        format.json { render json: @information.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_information
      @information = Information.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def information_params
      params.require(:information).permit(:content)
    end
end
