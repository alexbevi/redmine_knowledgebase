module KnowledgebaseHelper

  # Display a link if the user has a global permission
  def link_to_if_authorized_globally(name, options = {}, html_options = nil, *parameters_for_method_reference)
    if authorized_globally(options[:controller],options[:action])
      link_to(name, options, html_options, *parameters_for_method_reference)
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
    
    content_tag(:div, raw(output), :class => "summary")
  end

  def sort_categories?
    Setting['plugin_redmine_knowledgebase']['knowledgebase_sort_category_tree'].to_i == 1
  end
  
  def show_category_totals?
    Setting['plugin_redmine_knowledgebase']['knowledgebase_show_category_totals'].to_i == 1
  end
  
  def updated_by(updated, updater)
     l(:label_updated_who, :updater => link_to_user(updater), :age => time_tag(updated)).html_safe
  end

  def create_preview_link
    v = Redmine::VERSION.to_a
    if v[0] == 2 && v[1] <= 1
      link_to_remote(l(:label_preview), { :url => { :controller => 'articles', :action => 'preview' }, :method => 'post', :update => 'preview', :with => "Form.serialize('articles-form')")
    else
      preview_link({ :controller => 'articles', :action => 'preview' }, 'articles-form')
    end
  end
end
