Rails.application.routes.draw do

  get    '/posts'          => 'posts#index'
  get    '/posts/new'      => 'posts#new'
  get    '/posts/:id'      => 'posts#show'  
  post   '/posts'          => 'posts#create'
  get    '/posts/:id/edit' => 'posts#edit'
  patch  '/posts/:id'      => 'posts#update'
  put    '/posts/:id'      => 'posts#update'
  delete '/posts/:id'      => 'posts#destroy'

  root "application#list_post"
  get "/home"=> "application#home"
  get "/home/:name"=> "application#home"
  get "/list_post" => "application#list_post"
  get "/list_post/:id" => "application#show_post"
  get "/edit_post/:id" => "application#edit_post"
  get "/new_post" => "application#new_post"
  get  '/list_comments' => 'application#list_comments'
  post "/create_post" => "application#create_post"
  post '/create_comment_for_post/:post_id' => 'application#create_comment'
  post "/delete_post/:id" => "application#destroy"
  post "/update_post/:id" => "application#update_post"
  post '/list_post/:post_id/delete_comment/:comment_id' => 'application#delete_comment'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
