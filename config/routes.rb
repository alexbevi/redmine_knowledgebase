match "/knowledgebase", :to => "knowledgebase#index", :via => :get
match '/knowledgebase/articles/:article_id' => 'articles#show', :via => :get

scope "/knowledgebase" do
  resources :categories, :via => [:get, :post]
  resources :articles do
    get "rate"
    collection do
      get "tagged"
      post "preview"
    end
    post "comment"
    member do
      put  "preview"
      post "add_comment"
      post "destroy_comment"
    end
  end
end
