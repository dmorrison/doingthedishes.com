---
layout: post
title: Display and Editor Templates for Nullable Types in ASP.NET MVC
---

I was recently confused about how to specify a display and editor template for a nullable value type (such as int?, double?, and DateTime?) in ASP.NET MVC, and couldn't find much on this topic anywhere, so here's a quick tip on how to do it.

ASP.NET MVC has a feature called display and editor templates that let you specify in a central location how a given data type should be displayed. For example, if you want DateTime values to be displayed in a certain format throughout your app, you can add a file called DateTime.cshtml to the Views\Shared\DisplayTemplates folder. When you use one of the built-in HTML helpers such as @Html.Display() or @Html.DisplayFor() in a view to display a DateTime, it will use the template you specified (note that the same applies for the Views\Shared\EditorTemplates folder and the @Html.Editor() and @Html.EditorFor() methods).

So how would you specify a template for nullable DateTime? Since Windows doesn't allow the characters "?" and "<>" to be in a file name, that kills the convention of naming the file "DateTime?.cshtml" or "Nullable<DateTime>".

It turns out if you just specify a model type of DateTime?, then a template named DataTime.cshtml can cover both cases of displaying a nullable and non-nullable value type. Here's the full contents of my display template for DateTime?:

@model DateTime?
@string.Format("{0:yyyy-MM-dd}", Model)