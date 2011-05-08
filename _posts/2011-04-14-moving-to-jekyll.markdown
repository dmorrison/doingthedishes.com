--- 
layout: post
title: Moving to Jekyll
---

I moved this blog from BlogEngine.NET to a static site generator called [Jekyll](https://github.com/mojombo/jekyll). It was made by some of the smarty pants at GitHub, gives you easy and direct control over your blog's markup, and it even allows you to host your site on GitHub (more on this later).

BlogEngine.NET is backed by a database such as SQL Server and built upon the idea of dynamically generating content on each request. Static site generators work by having you write posts in plain text (in Jekyll's case, in Markdown) and generating html files for the entire site on each update. The generator is smart enough to do things like wrap your posts in templates, insert post dates, and generate next/previous pages and links. While this might sound like a brute force method (generate the **entire** site every time you write a new post???), with today's computers it's really not a big deal. 

There are some interesting side effects to using a static generator for your blog. For one, you get the benefits of high scalability inherent in the capability of web servers to serve simple html files very quickly without the added overhead and complexity of hitting a database, caching, etc. Dan and Marco had a good discussion about this on [episode 18](http://5by5.tv/buildanalyze/18) of the Build and Analyze podcast.

I found myself not needing many of the features that modern blog engines such as WordPress, Movable Type, or (in the .NET space) SubText, dasBlog, and BlogEngine.NET offer. Not maintaining a separate database for the blog as well as an easily customizable and simple template system were also very appealing. I've been writing more and more in Markdown too, so this seemed like a natural way to write posts, and Jekyll supports this.

# Importing Posts from BlogEngine.NET

Jekyll has some support for [importing from an RSS feed](http://coolaj86.info/articles/migrate-from-blogger-to-jekyll.html), but I didn't get good results from this. BlogEngine.NET is capable of exporting to BlogML (which is a nice format - I wish I would have caught on), so I modified the RSS import script in Jekyll to such in my BlogML data and transform it to Jekyll's post format.

# Caveats

Jekyll's not for everyone, and it's squarely aimed at developers or at least advanced geeks. If you don't want to set up your own blog installation, there are several good hosted blog platforms such as Tumblr, WordPress.com, and Blogger. I host my [personal blog](http://www.nightshowerer.com/) at Tumblr, and it's great.

For example, to write and publish a new blog entry, I write a post in Markdown, preview it locally using the Jekyll command line program (which does things like regenerating the site and starting a development web server), the commit my post and push to GitHub.

Not for the faint of heart, but to me it's comfortable and fits in with my desired workflow.

# Hosting at GitHub

You can host your site at GitHub by storing your Jekyll repository there and using the [GitHub Pages](http://pages.github.com/) feature. You can find out more about how this is done by poking around the [Jekyll](https://github.com/mojombo/jekyll) repo on GitHub and by looking at some of the sites using Jekyll that are listed in the project's wiki.

Basically, each time you push a commit to your blog repository on GitHub, your site is regenerated and republished. It's easy enough just to upload the files that Jekyll generates to your own server, but I find the workflow of having my blog automatically refreshed every time I make a commit very appealing.

**Update (May 8, 2011)**: [Here's](https://github.com/dmorrison/dmorrison.github.com) a link to this blog's source on GitHub.