module KnowledgebaseHelper
  # Display a link if the user is logged in
  def link_to_if_logged_in(name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to(name, options, html_options, *parameters_for_method_reference) if User.current.logged?
  end
  
  def link_to_remote_if_logged_in(name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to_remote(name, options, html_options, *parameters_for_method_reference) if User.current.logged?
  end
  
  def format_article_summary(article, format)
    output = nil
    case format
      when "normal"
        output = article.summary
      when "newest"
        output = "Created " + time_ago_in_words(article.created_at) + " ago in " + link_to(article.category.title, {:controller => 'categories', :action => 'show', :id => article.category.id})
      when "updated"
        output = "Updated " + time_ago_in_words(article.updated_at) + " ago"
      when "popular"
        output = "Viewed " + article.view_count.to_s + " since " + article.created_at.to_s
      when "toprated"
        output = "Rating: " + article.rating_average.to_s + "/5 from " + article.rated_count.to_s + " Votes"
    end
    
    content_tag(:div, output, :class => "summary")
  end

  def rating_links(article)
    average = (article.rating_average.blank?) ? 0 : article.rating_average * 100 / 5
    html = "<ul class='stars'>"
    html += "<li class='current_rating' style='width: #{average}%'>#{average}%</li>"
    html += "<li>#{link_to_remote "One",   :update => "article_rating_#{article.id}", :url => {:controller => 'articles', :action => 'rate', :article_id => article, :rating => 1 }, :html => {:class => "one_star"},    :method => :get}</li>"
    html += "<li>#{link_to_remote "Two",   :update => "article_rating_#{article.id}", :url => {:controller => 'articles', :action => 'rate', :article_id => article, :rating => 2 }, :html => {:class => "two_stars"},   :method => :get}</li>"
    html += "<li>#{link_to_remote "Three", :update => "article_rating_#{article.id}", :url => {:controller => 'articles', :action => 'rate', :article_id => article, :rating => 3 }, :html => {:class => "three_stars"}, :method => :get}</li>"
    html += "<li>#{link_to_remote "Four",  :update => "article_rating_#{article.id}", :url => {:controller => 'articles', :action => 'rate', :article_id => article, :rating => 4 }, :html => {:class => "four_stars"},  :method => :get}</li>"
    html += "<li>#{link_to_remote "Five",  :update => "article_rating_#{article.id}", :url => {:controller => 'articles', :action => 'rate', :article_id => article, :rating => 5 }, :html => {:class => "five_stars"},  :method => :get}</li>"
    html += "</ul>"
    return html
  end

end