module KnowledgebaseHelper
  # Display a link if the user is logged in
  def link_to_if_logged_in(name, options = {}, html_options = nil, *parameters_for_method_reference)
    link_to(name, options, html_options, *parameters_for_method_reference) if User.current.logged?
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
    end
    
    content_tag(:div, output, :class => "summary")
  end
end
