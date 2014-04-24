module KnowledgebaseHelper
  include Redmine::Export::PDF
  include KnowledgebaseSettingsHelper

  def format_article_summary(article, format, options = {})
    output = case format
    when "normal"
       truncate article.summary, :length => options[:truncate]
    when "newest"
      l(:label_summary_newest_articles,
        :ago => time_ago_in_words(article.created_at),
        :category => link_to(article.category.title, {:controller => 'categories', :action => 'show', :id => article.category_id}))
    when "updated"
      l(:label_summary_updated_articles,
        :ago => time_ago_in_words(article.updated_at),
        :category => link_to(article.category.title, {:controller => 'categories', :action => 'show', :id => article.category_id}))
    when "popular"
      l(:label_summary_popular_articles,
        :count => article.view_count,
        :created => article.created_at.to_date.to_formatted_s(:rfc822))
    when "toprated"
      l(:label_summary_toprated_articles,
        :rating_avg => article.rating_average.to_s,
        :rating_max => "5",
        :count => article.rated_count)
    else 
      nil
    end
    
    content_tag(:div, raw(output), :class => "summary")
  end

  def sort_categories?
    redmine_knowledgebase_settings_value(:sort_category_tree)
  end
  
  def show_category_totals?
    redmine_knowledgebase_settings_value(:show_category_totals)
  end
  
  def updated_by(updated, updater)
     l(:label_updated_who, :updater => link_to_user(updater), :age => time_tag(updated)).html_safe
  end

  def sort_column
    KbArticle.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:id => params[:id], :sort => column, :direction => direction }, {:class => css_class}
  end

  def article_to_pdf(article, project)
    pdf = ITCPDF.new(current_language)
    pdf.SetTitle("#{project} - #{article.title}")
    pdf.alias_nb_pages
    pdf.footer_date = format_date(Date.today)
    pdf.AddPage
    pdf.SetFontStyle('B',11)
    pdf.RDMMultiCell(190,5,
          "#{project} - #{article.title}")
    pdf.Ln
    # Set resize image scale
    pdf.SetImageScale(1.6)
    pdf.SetFontStyle('',9)
    write_article(pdf, article)
    pdf.Output
  end

  def write_article(pdf, article)
    pdf.RDMwriteHTMLCell(190,5,0,0,
          article.content.to_s, article.attachments, 0)
    if article.attachments.any?
      pdf.Ln
      pdf.SetFontStyle('B',9)
      pdf.RDMCell(190,5, l(:label_attachment_plural), "B")
      pdf.Ln
      for attachment in article.attachments
        pdf.SetFontStyle('',8)
        pdf.RDMCell(80,5, attachment.filename)
        pdf.RDMCell(20,5, number_to_human_size(attachment.filesize),0,0,"R")
        pdf.RDMCell(25,5, format_date(attachment.created_on),0,0,"R")
        pdf.RDMCell(65,5, attachment.author.name,0,0,"R")
        pdf.Ln
      end
    end
  end
  
  def article_tabs
    tabs = [{:name => 'content', :action => :content, :partial => 'articles/sections/content', :label => :label_content},
            {:name => 'comments', :action => :comments, :partial => 'articles/sections/comments', :label => :label_comment_plural},
            {:name => 'attachments', :action => :attachments, :partial => 'articles/sections/attachments', :label => :label_attachment_plural},
            {:name => 'history', :action => :history, :partial => 'articles/sections/history', :label => :label_history}
            ]
    # TODO permissions?            
    # tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
  end

  def create_preview_link
    v = Redmine::VERSION.to_a
    if v[0] == 2 && v[1] <= 1 && v[2] <= 0
      link_to_remote l(:label_preview), 
                     { :url => { :controller => 'articles', :action => 'preview' }, 
                       :method => 'post', 
                       :update => 'preview', 
                       :with => "Form.serialize('articles-form')" }
    else
      preview_link({ :controller => 'articles', :action => 'preview' }, 'articles-form')
    end
  end
end
