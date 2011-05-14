---
layout: post
title: A Generic Repository
---

I've seen a few examples of repositories that are written for specific types, but I've been using a repository interface very similar to what is described [here](http://weblogs.asp.net/cibrax/archive/2011/05/05/we-have-iqueryable-so-why-bother-with-a-repository.aspx). It's worked out very well for me, and provides a lot of flexibility via a simple interface:

{% highlight csharp %}
public interface IRepository
{
    IQueryable<T> All<T>() where T : class;
    void Add<T>(T item) where T : class;
    void Delete<T>(int id) where T : class;
    void Save();
}
{% endhighlight %}

I tweaked Pablo's example to completely use generics (it seems he uses a concrete type on the Entities property).

Here's an implementation using Entity Framework 4 Code First:

{% highlight csharp %}
public class MyRepository : IRepository, IDisposable
{
    private MyDbContext db = new MyDbContext();

    public IQueryable<T> All<T>() where T : class
    {
        return db.Set<T>();
    }

    public void Add<T>(T item) where T : class
    {
        db.Set<T>().Add(item);
    }

    /// <summary>
    /// Retrieves the entity from the database, then marks
    /// it for deletion in the db context. Note that this
    /// executes a query to retrieve the entity (if it's not
    /// already loaded in the context). Would be better to 
    /// find a way to delete without retrieving the object first.
    /// </summary>
    public void Delete<T>(int id) where T : class
    {
        var entity = db.Set<T>().Find(id);
        db.Set<T>().Remove(entity);
    }

    public void Save()
    {
        db.SaveChanges();
    }

    public void Dispose()
    {
        Dispose(true);
        GC.SuppressFinalize(this);
    }

    protected virtual void Dispose(bool disposing)
    {
        if (disposing)
        {
            // Free managed resources
            if (db != null)
            {
                db.Dispose();
                db = null;
            }
        }

        // Free unmanaged resources here
    }
}
{% endhighlight %}

(The Delete method is a little inefficient, as it seems to be a [little](http://stackoverflow.com/questions/502795/how-do-i-delete-an-object-from-an-entity-framework-model-without-first-loading-it) [difficult](http://stackoverflow.com/questions/2471433/how-to-delete-an-object-by-id-with-entity-framework) to delete without querying in Entity Framework)

Here's how it can be used inside an ASP.NET MVC 3 controller:

{% highlight csharp %}
public ActionResult Index()
{
    return View(repository.All<SomeModel>());
}

[HttpPost]
[Authorize(Roles = "Editor")]
public ActionResult Delete(int id)
{
    repository.Delete<SomeModel>(id);

    repository.Save();

    return Content("");
}
{% endhighlight %}

For unit testing, here's an implementation of a mock repository (which is backed by an ArrayList):

{% highlight csharp %}
public class MockRepository : IRepository
{
    ArrayList list = new ArrayList();

    public bool SaveWasCalled { get; private set; }

    public IQueryable<T> All<T>() where T : class
    {
        return (from Object item in list
               where item.GetType() == typeof(T)
               select item as T).AsQueryable<T>();
    }

    public void Add<T>(T item) where T : class
    {
        list.Add(item);
    }

    public void Delete<T>(int id) where T : class
    {
        throw new NotImplementedException();
    }

    public void Save()
    {
        SaveWasCalled = true;
    }
}
{% endhighlight %}

(I still need to figure out that Delete method using reflection... or something...)