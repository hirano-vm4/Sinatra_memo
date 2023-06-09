# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

class MemoApp
  def initialize
    @connection = PG.connect(dbname: 'simple_memo')
  end

  def sort
    @connection.exec('SELECT * FROM memos ORDER BY created_at DESC')
  end

  def create(title, content)
    @connection.exec('INSERT INTO memos (title, content) VALUES ($1, $2);', [title, content])
  end

  def find(id)
    @connection.exec('SELECT * FROM memos WHERE id = $1', [id]).first
  end

  def edit(title, content, id)
    @connection.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def delete(id)
    @connection.exec('DELETE FROM memos WHERE id = $1', [id])
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def format_to_instance_variable(file)
    @id = file['id']
    @title = file['title']
    @content = file['content']
  end
end

memo = MemoApp.new

get '/' do
  redirect to('/memos')
end

get '/memos' do
  @memos = memo.sort
  erb :top
end

get '/memos/new' do
  erb :form
end

post '/memos' do
  memo.create(params[:title], params[:content])
  redirect to('/memos')
end

get '/memos/:id' do
  memo_data = memo.find(params[:id])
  format_to_instance_variable(memo_data)
  erb :detail
end

get '/memos/:id/edit' do
  edit_file = memo.find(params[:id])
  format_to_instance_variable(edit_file)
  erb :edit
end

patch '/memos/:id/edit' do
  memo.edit(params[:title], params[:content], params[:id])
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  memo.delete(params[:id])
  redirect to('/memos')
end
