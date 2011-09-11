---
layout: post
title: Custom Error Pages with ASP.NET MVC 3 and ELMAH
---

I was having a problem in an MVC 3 app with the `HandleErrorAttribute` hiding exceptions from ELMAH and also clashing with the  `<customErrors>` section in the Web.config (similar to [this](http://stackoverflow.com/questions/7265193/mvc-problem-with-custom-error-pages) Stack Overflow question). TL;DR version: I ended up just removing the default registration of `HandleErrorAttribute` and leaning on what's specified in `<customErrors>`.

Some details...

By default, a new MVC 3 project has a global filter registered in Global.asax that applies the `HandleErrorAttribute` to each controller action. This attribute will essentially appy a try/catch around each controller action and render the Error.cshtml file (or .vbhtml if you're using Razor with VB.NET, or .aspx if you're using the WebForms view engine) in the Views/ControllerName or Views/Shared directory. A new MVC 3 project has a Error.cshtml file in the Views/Shared directory by default.

If custom errors are enabled (either via the mode attribute being set to "On" or "RemoteOnly" on the `<customErrors>` element), then `HandleErrorAttribute` will render the Error.cshtml view.

My first problem was that I was using ELMAH to log errors, and exceptions would be swallowed by `HandleErrorAttribute` and not logged in ELMAH. I saw a few posts such as [this](http://www.hanselman.com/blog/ELMAHErrorLoggingModulesAndHandlersForASPNETAndMVCToo.aspx) one from Scott Hanselman about making a custom attribute to handle errors and log to ELMAH, but stay with me for a few minutes more...

To handle different kinds of custom errors, I removed the stock Error.cshtml from Views/Shared, made a new controller and set the following in the Web.config file:

{% highlight html %}
<customErrors mode="On" defaultRedirect="~/Error/ServerError">
  <error statusCode="404" redirect="~/Error/NotFound" />
  <!-- Other status codes here -->
</customErrors>
{% endhighlight %}

However, if an exception was thrown with `HandleErrorAttribute` and the `<customErrors>` settings applied, I would first get another exception (logged in ELMAH):

>The view 'Error' or its master was not found or no view engine supports the searched locations. The following locations were searched: ~/Views/ControllerName/Error.aspx ~/Views/ControllerName/Error.ascx ~/Views/Shared/Error.aspx ~/Views/Shared/Error.ascx ~/Views/ControllerName/Error.cshtml ~/Views/ControllerName/Error.vbhtml ~/Views/Shared/Error.cshtml ~/Views/Shared/Error.vbhtml

Then, the app would fall back to rendering Error/ServerError as I had directed it to in `<customErrors>`. The real error was masked in ELMAH. This is because the `HandleErrorAttribute` was looking for Shared/Error.cshtml, couldn't find it, then threw up and fell back to what was specified in `<customErrors>`.

(Note that 404 errors still passed through; it turns out `HandleErrorAttribute` ignores all but 500 errors).

Why did I even need to use the `HandleErrorAttribute`? Can't I just lean on the `<customErrors>` section in vanilla ASP.NET? I ended up taking the attribute's registration out of Global.asax and doing just that. Errors were then properly picked up by Elmah, and I would see friendly error messages when enabled in production.