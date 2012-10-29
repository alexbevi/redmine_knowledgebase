match "/knowledgebase", :to => "knowledgebase#index", :via => :get

scope "/knowledgebase" do
  resources :categories, :via => [:get, :post]
  resources :articles do
    collection do
      get "tagged"
      post "preview"
    end
    get "comment"
    member do
      put  "preview"
      post "add_comment"
      post "destroy_comment"
      post "rate"
    end
  end
end
