# Redmine Knowledgebase plugin

This plugin adds generic knowledgebase funcationlity to the redmine project management application.

## Introduction

Redmine (www.redmine.org) is just plain awesome, and has proven to provide 90% of the functionality I need. The one feature that was missing was a usable knowledgebase component. I've looked at some of the open source solutions available, but couldn't find anything that fit my needs exactly. Seeing as redmine is so easily extended, I figured why not create it for this platform instead of starting yet another project from scratch :P

## Features

* Categorization of Articles
* Article ratings
* File attachments
* Article Comments
* Article Tags

## Requirements

Note that whenever possible, the necessary plugins for the knowledgebase have been stripped into the project (so they're not setup as plugins, but modules). The copyright information has been preserved when available, and the links are provided below.
I figure if there's ever a need for these plugins in the greater Redmine application, they can be incorporated into the trunk at that point and called accordingly.

* acts_as_viewed (http://rubyforge.org/projects/acts-as-viewed)
* acts_as_rated (http://rubyforge.org/projects/acts-as-rated)
* acts_as_taggable_on_steroids (http://github.com/jviney/acts_as_taggable_on_steroids)

# Redmine Knowledgebase Plugin install guide

### Overview (Linux/UNIX systems)

To install the Redmine Knowledgebase Plugin, you will need to have
command line access to the server where Redmine is installed, and be able to work as the root user.


## Downloading and installing the Knowledgebase Plugin

To download the files for the plugin, run the following command from the
Redmine application root directory, as the root user:

<pre><code>script/plugin install git://github.com/alexbevi/redmine_knowledgebase.git</code></pre>

This downloads the files for the plugin from the GitHub repository, and
installs them in the *$redmine\_root/vendor/plugins/redmine\_knowledgebase*
directory.

After the plugin has been installed, you will need to do a db migration
to update your Redmine database (make a backup of the database before
running this command).

In the Redmine application root directory, run this command as the root
user:

<pre><code>rake db:migrate_plugins RAILS_ENV=production</code></pre>


More information on installing Redmine plugins can be found here: [http://www.redmine.org/wiki/redmine/Plugins](http://www.redmine.org/wiki/redmine/Plugins "Redmine Plugins")


After the plugin is installed and the db migration completed, you will
need to restart Redmine for the plugin to be available.

# Redmine Knowledgebase Plugin User Guide

## Overview

Once the Redmine Knowledgebase Plugin is installed, there will be a
Knowledgebase link in the Redmine navigation header. Unlike the Redmine
Wiki, which is only available at the per-project or subproject level,
the Knowledgebase is available at the root level of the Redmine
application.

## Configuring the Knowledgebase

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


## Using the Knowledgebase

Once you have created categories, you can then add articles and
sub-categories.

### Creating Sub-categories

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


### Creating Articles

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

### Managing Articles

Once you click on Create to add the article, you are taken to the article main page. This page shows the name and content of the article, the creator (Added by username), how long ago the article was created, and how many times it has been viewed.

You can also Edit or Delete the article, as well as rate the article. Clicking on any of the tags in the Tags section will search for any other articles with the same tags.

You can also comment on an article by clicking on Add a comment.

## Knowledgebase Home Page

Now that categories and articles have been created, the Home page of the Knowledgebase will show the *Newest Articles*, *Recently Updated Articles*, *Most Popular Articles*, and *Top Rated Articles*. You can use this page to help navigate the Knowledgebase, as well as using the *Jump to Category* drop down menu or the *Browse by Category* menu on the right of the screen. You can reach this page from anywhere inside the Knowledgebase by clicking on the Home link.

