require 'sinatra'
require 'sinatra/activerecord'
require './config/environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require_relative 'models/post.rb'

enable :sessions



helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# Get all posts
get '/' do
  @posts = Post.order("created_at DESC")
  @title = "Welcome."
  erb :"posts/index"
end

# Get view for new post
get "/posts/create" do
  @title = "Create post"
  @post = Post.new
  erb :"posts/create"
end
# Create new post
post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}", :notice => 'Congrats! Love the new post. (This message will desappear in 4 seconds.)'
  else
    redirect "posts/create", :error => 'Something went wrong. Try again. (This message will desappear in 4 seconds.)'
  end
end

# view post
get "/posts/:id" do
  @post = Post.find(params[:id])
  @title = @post.title
  erb :"posts/view"
end

# edit post
get "/posts/:id/edit" do
  @post = Post.find(params[:id])
  @title = "Edit Form"
  erb :"posts/edit"
end

put "/posts/:id" do
  @post = Post.find(params[:id])
  @post.update(params[:post])
  redirect "/posts/#{@post.id}"
end
