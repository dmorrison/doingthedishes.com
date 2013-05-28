---
layout: post
title: Sending Statistics to StatsD with UdpClient in .NET
---

This post is just a note about a quick fix we did at work to remedy a brittle (and embarassing) dependency on StatsD. StatsD is a simple daemon that listens for and aggregates statistics sent over UDP and
can be plugged into various reporting tools and dashboards. We make a lot of calls to StatsD in our app ([measure anything, measure everything](http://codeascraft.com/2011/02/15/measure-anything-measure-everything/)), so any problems doing so is central to performance.

One day, the our main web stack actually went down because our StatsD machine crashed and our app was inadvertently dependent on it. We rebooted the StatsD server and everything was up again, but we then immediately made it a priority to decouple our app from StatsD. 

The problem was in how we were using the `System.Net.Sockets.UdpClient` class. We had a small utility wrapper class that, at its core, just used `UdpClient.Send()` to throw packets at StatsD. At first, I just tried wrapping
the call to `Send()` in a `try...catch` block. When I tested this, though, I found that our app significantly slowed down. Why was this happening for something that sends UDP packets? Shouldn't it be fire and forget? 

I mistakenly took this method to work asynchronously. `Send()` actually seems to stall a bit when sending data (as it presumably establishes a connection), and even longer when it can't reach the destination and throws an exception.

To fix this, I simply switched to using the `SendAsync()` method instead (which is new in .NET 4.5). I could have also used the older `BeginSend()` method if the project wasn't up to 4.5.

Note that I still needed to wrap the call to `SendAync()` in a `try...catch` block in the (rare) case that our StatsD machine is down. More on that in my next post...

In addition to not having a hard dependency on StatsD, we immediately noticed an increase in responsiveness in several central endpoints of our app as we're now making all calls to StatsD aynchronously. Not our best moment, but we'll take the easy wins wherever we can. :)