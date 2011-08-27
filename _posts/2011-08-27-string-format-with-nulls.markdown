---
layout: post
title: Using String.Format with Nulls
---

Just a quick tip from my [last post](/2011/07/20/templates-nullable-types-mvc.html)...

Notice how I didn't check for nulls in the code sample:

{% highlight csharp %}
@model DateTime?
@string.Format("{0:yyyy-MM-dd}", Model)
{% endhighlight %}

You'd think it would be necessary to do something like so instead:

{% highlight csharp %}
@model DateTime?
@(Model.HasValue ? Model.Value.ToString("yyyy-MM-dd") : "")
{% endhighlight %}

However, String.Format in the .NET framework will [just return an empty string](http://geekswithblogs.net/mnf/archive/2008/01/09/passing-null-parameters-to-string.format-is-safe.aspx) when formatting null values. I thought this was handy, and it seems to pop up in a surprising number of cases.