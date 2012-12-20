module KnowledgebaseHelper
  include Redmine::Export::PDF

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
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
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
            {:name => 'summary', :action => :summary, :partial => 'articles/sections/summary', :label => :label_summary},
            {:name => 'comments', :action => :comments, :partial => 'articles/sections/comments', :label => :label_comment_plural},
            {:name => 'attachments', :action => :attachments, :partial => 'articles/sections/attachments', :label => :label_attachment_plural},
            {:name => 'history', :action => :history, :partial => 'articles/sections/history', :label => :label_history}
            ]
    # TODO permissions?            
    # tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
  end
end
