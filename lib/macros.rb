# FIXME This just doesn't look very clean ...

def link_to_article(article)
  link_to l(:label_kb_link, :kb_id => article.id.to_s), { :controller => 'articles', :action => 'show', :id => article.id }, :title => article.title
end

def link_to_article_with_title(article)
  link_to "#{l(:label_kb_link, :kb_id => article.id.to_s)}: #{article.title}", { :controller => 'articles', :action => 'show', :id => article.id }
end

def link_to_category_with_title(category)
  link_to category.title, { :controller => 'categories', :action => 'show', :id => category.id }
end

module Macros

  Redmine::WikiFormatting::Macros.register do

    #A macro named KB in upper case will be considered as an acronym and will break the macro
    desc "Knowledge base Article link Macro, using the kb# format"
    macro :kb do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      article = KbArticle.find(args.first)
      link_to_article(article)
    end

    desc "Knowledge base Article link Macro, using the article_id# format"
    macro :article_id do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      article = KbArticle.find(args.first)
      link_to_article(article)
    end

    desc "Knowledge base Article link Macro, using the article# format"
    macro :article do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      article = KbArticle.find(args.first)
      link_to_article_with_title(article)
    end

    desc "Knowledge base Category link Macro, using the category# format"
    macro :category do |obj, args|
      args, options = extract_macro_options(args, :parent)
      raise 'No or bad arguments.' if args.size != 1
      category = KbCategory.find(args.first)
      link_to_category_with_title(category)
    end
  end
end