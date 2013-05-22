This plugin adds generic knowledgebase funcationlity to the redmine project management application.

## Compatibility

The plugin is available in two (2) versions, which track the Redmine versions to reflect their level of compatibility. If you're using Redmine 1.x.x, use a 0.x.x or 1.x.x version of the Knowledgebase; if you're using Redmine 2+, use a Knowledgebase version >= 2.

This plugin also incorporates the following libraries directly. 

* [acts_as_viewed](http://rubyforge.org/projects/acts-as-viewed)
* [acts_as_rated](http://rubyforge.org/projects/acts-as-rated)

They do _NOT_ need to be installed manually as they have been [patched](https://github.com/alexbevi/redmine_knowledgebase/commit/18c6fd1dff134e8c1f8578b643dc9ba920b7d854) to include Rails 3+ support.

## Introduction

[Redmine](http://www.redmine.org) is just plain awesome, and has proven to provide 90% of the functionality I need. The one feature that was missing was a usable knowledgebase component. I've looked at some of the open source solutions available, but couldn't find anything that fit my needs exactly. Seeing as Redmine is so easily extended, I figured why not create it for this platform instead of starting yet another project from scratch :P

## Features

* Categorization of Articles
* Article ratings
* File attachments
* Article Comments
* Article Tags
* Permissions

## Installation

To install the knowledgebase, execute the following commands from the root of your redmine directory:

    git clone git://github.com/alexbevi/redmine_knowledgebase.git plugins/redmine_knowledgebase
    bundle install
    rake redmine:plugins:migrate NAME=redmine_knowledgebase

More information on installing Redmine plugins can be found here: [http://www.redmine.org/wiki/redmine/Plugins](http://www.redmine.org/wiki/redmine/Plugins "Redmine Plugins")

After the plugin is installed and the db migration completed, you will
need to restart Redmine for the plugin to be available.

### Uninstall

`rake redmine:plugins:migrate NAME=redmine_knowledgebase VERSION=0`

## User Guide

### Overview

Once the Redmine Knowledgebase Plugin is installed, there will be a
Knowledgebase link in the Redmine navigation header. Unlike the Redmine
Wiki, which is only available at the per-project or subproject level,
the Knowledgebase is available at the root level of the Redmine
application.

### Configuration

To start using the Knowledgebase plugin, click on the Knowledgebase link
in the Redmine navigation header.

This takes you to the default page for
the Knowledgebase, with this text: *"No articles have been added to the
knowledgebase yet. Maybe you want to get the ball rolling ..."*. To the
right is a green circle with a plus (+) sign, and the link to add a New
Category.

Click on **New Category**. This takes you to the Create Category page.

* **Root Category** - since this is the first category, this is checked by
default. Root Categories show in the right hand Browse by Category
sidebar.

* **Title** - give the new category a title relevant to your needs. This title
will show in the Browse by Category sidebar as a navigation link.

* **Description** - provide a description of the category. This description
will show on the category main page.

Click on **Create** to create the new category. You can edit this
information again once the category is created by using the Edit link on
the category main page.

The first category created is the Parent Category for all new
Categories.

You can continue to create as many new categories as needed, and add
more new categories at any time. See *Using
the Knowledgebase* for information on how to create sub-categories and add
Articles.

Once you have added categories to the Knowledgebase, there will be a
*Jump to Category* drop down menu on the Knowledgebase Home page. You can
use that to navigate to any category or sub-category. You can also
navigate to categories (not sub-categories) by clicking on the category
name in the right hand *Browse by Category* side bar.


### Using the Knowledgebase

Once you have created categories, you can then add articles and
sub-categories.

#### Creating Sub-categories

To create a sub-category, click on a root category in the right hand
*Browse by Category* sidebar, or use the *Jump to Category* drop down menu
from the Knowledgebase Home page.

Once you are on the main page for that category, click on the **New
Category** link on the right side of the page. This takes you to the
*Create Category* page.

* **Root Category** - uncheck this box if you want this to be a sub-category

* **Parent Category** - choose the relevant parent category from the drop down
menu

* **Title** - give the new sub-category a title relevant to your needs

* **Description** - provide a description for the sub-category. This
description will appear on the sub-category main page.

Click on **Create** to create the new sub-category. You can edit this
information again by using the Edit link on the sub-category main page.

You can have sub-categories of sub-categories.

**NOTE** - sub-categories do not appear in the right hand *Browse by Category*
side bar. Sub-categories only appear in the *Jump to Category* drop down
menu on the Knowledgebase Home page, or in the category main pages.

In the *Jump to Category* drop down menu, sub-categories are shown with a
leading > , sub sub-categories with a leading >> , etc.


#### Creating Articles

To create an Article, navigate to a category or sub-category, and click
on the **Create Article** link. This opens the *Create Article* page.

* **Category** - select the category or sub-category from the drop down menu

* **Title** - give the article a relevant title

* **Summary** - a short summary of what the article is about. This shows under
the article on the category or sub-category main page.

* **Content** - the content of the article. The Content section uses the
Redmine Wiki formatting syntax, so anything that is possible in the
Redmine Wiki is possible here.

* **Tags** - add tags to the article Separate tags or tag groups with commas. Global tag search is currently not implemented, but is in development. Tag search is currently only available at the Article level.

* **Files** - attach any files or images to the article, along with an Optional description. Note that the maximum size of the files or images that can be uploaded is 5MB.

Click on **Create** to add the article. Click on **Preview** to see how the article will look and make any necessary changes before adding the article.

#### Managing Articles

Once you click on Create to add the article, you are taken to the article main page. This page shows the name and content of the article, the creator (Added by username), how long ago the article was created, and how many times it has been viewed.

You can also Edit or Delete the article, as well as rate the article. Clicking on any of the tags in the Tags section will search for any other articles with the same tags.

You can also comment on an article by clicking on Add a comment.

#### Using Wiki Macros

You can easily create links to articles and categories from issues or Wiki pages using the macros.

4 macros are available so far:

* `{{kb(<article_id>)}}` will render a link to the "kb#<article_id>" format. (It may change according to your locale).
* `{{article_id(<article_id>)}}`, identical to the kb macro, will render a link to the "kb#<article_id>" format.
* `{{article(<article_id>)}}` will render a link to the "kb#<article_id>: <article_title>" format.
* `{{category(<category_id>)}}` will render a link to the "<category_title>" format, only renders the title of the category.

### Knowledgebase Home Page

Now that categories and articles have been created, the Home page of the Knowledgebase will show the *Newest Articles*, *Recently Updated Articles*, *Most Popular Articles*, and *Top Rated Articles*. You can use this page to help navigate the Knowledgebase, as well as using the *Jump to Category* drop down menu or the *Browse by Category* menu on the right of the screen. You can reach this page from anywhere inside the Knowledgebase by clicking on the Home link.

### About

Copyright (c) 2010-2013 Alex Bevilacqua, released under the MIT license

Though I initially wrote this plugin, it would not be possible without the many contributions from the community. See [AUTHORS](https://github.com/alexbevi/redmine_knowledgebase/blob/master/AUTHORS) for the full list.

#### Shameless Plug(s)

[![endorse](http://api.coderwall.com/alexbevi/endorsecount.png)](http://coderwall.com/alexbevi)
[![Flattr this][2]][1]

[1]: http://flattr.com/thing/890708/alexbeviredmineknowledgebase
[2]: http://api.flattr.com/button/flattr-badge-large.png
