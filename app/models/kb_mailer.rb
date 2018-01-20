class KbMailer < Mailer
  
  def article_create(article)
	redmine_headers 'Project' => article.project.identifier
	@project = article.project
	@article = article
    @article_url = url_for(:controller => 'articles', :action => 'show', :id => article.id, :project_id => @project)
	recipients = article.recipients
	cc = article.category.watcher_recipients - recipients
	mail :to => recipients, 
		:cc => cc,
		:subject => "#{l(:label_new_article)}: #{article.title}"
  end
  
  def article_update(article)
	redmine_headers 'Project' => article.project.identifier
	@project = article.project
	@article = article
    @article_url = url_for(:controller => 'articles', :action => 'show', :id => article.id, :project_id => @project)
	recipients = article.recipients
	cc = ((article.watcher_recipients + article.category.watcher_recipients).uniq - recipients)
	mail :to => recipients, 
		:cc => cc,
		:subject => "#{l(:label_article_updated)}: #{article.title}"
  end
  
  def article_destroy(article)
	redmine_headers 'Project' => article.project.identifier
 	@article = article
	@destroyer = User.current
	recipients = article.recipients
	cc = ((article.watcher_recipients + article.category.watcher_recipients).uniq - recipients)
	mail :to => recipients, 
		:cc => cc,
		:subject => "#{l(:label_article_removed)}: #{article.title}"
  end
  
  def article_comment(article, comment)
	redmine_headers 'Project' => article.project.identifier
	@project = article.project	
 	@article = article	
	@comment = comment
    @article_url = url_for(:controller => 'articles', :action => 'show', :id => article.id, :project_id => @project)
	recipients = article.recipients
	cc = article.watcher_recipients - recipients
	mail :to => recipients, 
		:cc => cc,
		:subject => "#{l(:label_comment_added)} - #{l(:label_title_articles)}: #{article.title}"
  end
  
end