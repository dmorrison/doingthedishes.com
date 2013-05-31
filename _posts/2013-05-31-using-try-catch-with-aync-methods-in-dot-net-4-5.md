---
layout: post
title: Using Try...Catch Blocks with Async Methods in .NET 4.5
---

In my [last post](/2013/05/28/sending-to-statsd-with-udpclient-in-dotnet.html), I mentioned that you can still use `try...catch` blocks with .NET 4.5 async methods. There is some interesting magic that .NET injects for you under the covers in this case. For example, imagine you have the following (simplified and contrived) code which uses the newer .NET 4.5 `SendAsync()` method on `UdpClient` instead of the older, synchronous `Send()` version:

{% highlight csharp %}
// Do something...

try
{
	var client = new UdpClient();
	client.SendAsync(datagram, datagram.Length, hostname, port);
}
catch (Exception e)
{
	// Handle exception here...
}

// Do something else...
{% endhighlight %}

Let's assume that the host specified by `hostname` is down/invalid. The part about this flow that blew my mind was that the call to `SendAsync()` will return immediately (and not delay the code in `// Do something else...`), but the exception will still bubble up and be handled by the `catch` block. [This](http://www.interact-sw.co.uk/iangblog/2010/11/01/csharp5-async-exceptions) post has an in depth explanation of how the compiler handles this. In the post, he mentions how you can even debug and step through code like this in Visual Studio, pass over an async method and see it return immediately, step through more code, and be jarringly brought back to the thrown exception from a method that has already returned!
