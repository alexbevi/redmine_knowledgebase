module KnowledgebaseHelper

  # Display a link if the user has a global permission
  def link_to_if_authorized_globally(name, options = {}, html_options = nil, *parameters_for_method_reference)
    if authorized_globally(options[:controller],options[:action])
      link_to(name, options, html_options, *parameters_for_method_reference)
    end
  end
  
  def link_to_remote_if_authorized_globally(name, options = {}, html_options = nil, *parameters_for_method_reference)
    if authorized_globally(options[:url][:controller],options[:url][:action])
      link_to_remote(name, options, html_options, *parameters_for_method_reference)
    end
  end

  def authorized_globally(controller,action)
    User.current.allowed_to?({:controller => controller, :action => action}, nil, :global => true)
  end
 
  def format_article_summary(article, format, options = {})
    output = nil
    case format
    when "normal"
      output = truncate article.summary, :length => options[:truncate]
    when "newest"
      output = l(:label_summary_newest_articles,
        :ago => time_ago_in_words(article.created_at),
        :category => link_to(article.category.title, {:controller => 'categories', :action => 'show', :id => article.category_id}))
    when "updated"
      output = l(:label_summary_updated_articles,
        :ago =>time_ago_in_words(article.updated_at),
        :category => link_to(article.category.title, {:controller => 'categories', :action => 'show', :id => article.category_id}))
    when "popular"
      output = l(:label_summary_popular_articles,
        :count => article.view_count,
        :created => article.created_at.to_formatted_s(:rfc822))
    when "toprated"
      output = l(:label_summary_toprated_articles,
        :rating_avg => article.rating_average.to_s,
        :rating_max => "5",
        :count => article.rated_count)
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
    html
  end
  
  def sort_categories?
    Setting['plugin_redmine_knowledgebase']['knowledgebase_sort_category_tree'].to_i == 1
  end
  
  def show_category_totals?
    Setting['plugin_redmine_knowledgebase']['knowledgebase_show_category_totals'].to_i == 1
  end

  def link_to_article(article)
    link_to(l(:label_kb_link,{:kb_id=>article.id.to_s}),{ :controller => 'articles', :action => 'show', :id => article.id}, :title => article.title)
  end

  def link_to_article_with_title(article)
    link_to(l(:label_kb_link,{:kb_id=>article.id.to_s})+": "+article.title,{ :controller => 'articles', :action => 'show', :id => article.id})
  end

  def link_to_category_with_title(category)
    link_to(category.title,{ :controller => 'categories', :action => 'show', :id => category.id})
  end
  
  def tag_cloud(tags, classes)
    return if tags.empty?
    
    max_count = tags.sort_by(&:count).last.count.to_f
    
    tags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end
end
