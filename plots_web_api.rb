#!/bin/env ruby

require 'date'
require 'json'
require 'sinatra'

def read_plot_file(plot_file)
  fields = [:username, :display_name, :expire_date]
  hidden_fields = [:username]
  data = {}
  File.readlines(plot_file).each do |line|
    field = fields.shift
    break if field.nil?
    next if hidden_fields.include? field

    line = line.chomp
    if field == :expire_date
      line = Time.at(line.to_i).to_datetime.to_s
    end
    data[field] = line
  end
  p data
end

def get_plots
  plots = []
  (0..32).each do |i|
    plot = "#{i}.plot"
    plots.push(read_plot_file(plot)) if File.exist? plot
  end
  plots
end

get '/api/plots' do
  get_plots.to_json
end