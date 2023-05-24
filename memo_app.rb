# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def get_file_path(id)
    "data/memo_#{id}.json"
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end

  def convert_to_hash(file_path)
    File.open(file_path) { |file| JSON.parse(file.read) }
  end

  def format_to_instance_variable(file)
    @title = file['title']
    @content = file['content']
    @id = file['id']
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  memos = Dir.glob('data/*').map { |file| JSON.parse(File.open(file).read) }
  @memos = memos.sort_by { |file| file['time'] }.reverse
  erb :top
end

get '/memos/new' do
  erb :form
end

post '/memos' do
  memo_data = { 'id' => SecureRandom.uuid, 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
  File.open("data/memo_#{memo_data['id']}.json", 'w') { |file| JSON.dump(memo_data, file) }
  redirect to("/memos/#{memo_data['id']}")
end

get '/memos/:id' do
  file_path = get_file_path(params[:id])
  memo = convert_to_hash(file_path)
  format_to_instance_variable(memo)
  erb :detail
end

get '/memos/:id/edit' do
  file_path = get_file_path(params[:id])
  memo = convert_to_hash(file_path)
  format_to_instance_variable(memo)
  erb :edit
end

patch '/memos/:id/edit' do
  file_path = get_file_path(params[:id])
  File.open(file_path, 'w') do |file|
    memo = { 'id' => params[:id], 'title' => params[:title], 'content' => params[:content], 'time' => Time.now }
    JSON.dump(memo, file)
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  file_path = get_file_path(params[:id])
  File.delete(file_path)
  redirect to('/memos')
end
