class KbMailer < Mailer

  add_template_helper(KnowledgebaseHelper)

  def article_create(article)
	redmine_headers 'Project' => article.project.identifier
	@project = article.project
	@article = article
    @article_url = url_for(:controller => 'articles', :action => 'show', :id => article.id, :project_id => @project)
	recipients = article.recipients
	cc = article.category.watcher_recipients - recipients
	mail :to => recipients, 
		:cc => cc,
    :subject => "[#{@project.name}] #{@article.category.title}: \"#{article.title}\" - #{l(:label_new_article)}"
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
		:subject => "[#{@project.name}] #{@article.category.title}: \"#{article.title}\" - #{l(:label_article_updated)}"
  end
  
  def article_destroy(article)
	redmine_headers 'Project' => article.project.identifier
	@project = article.project
 	@article = article
	@destroyer = User.current
	recipients = article.recipients
	cc = ((article.watcher_recipients + article.category.watcher_recipients).uniq - recipients)
	mail :to => recipients, 
		:cc => cc,
		:subject => "[#{@project.name}] #{@article.category.title}: \"#{article.title}\" - #{l(:label_article_removed)}"
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
		:subject => "[#{@project.name}] #{@article.category.title}: \"#{article.title}\" - #{l(:label_comment_added)}"
  end
  
end
