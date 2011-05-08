---
layout: post
title: Removing ASP.NET Membership Objects from SQL Server
---

On a recent project using ASP.NET MVC 3, I started out using the stock ASP.NET membership provider with SQL Server. I later decided that it was going to be too heavy, and went about making my own simpler membership, roles, and form services.

As part of the change, I created the following script that I used in a database migration when I switched over to my new users and roles mechanism. I hope this helps someone if they need to quickly rip out the default membership provider:

<script src="https://gist.github.com/942148.js"> </script>