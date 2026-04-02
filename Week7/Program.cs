var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();

// Enable static files (CSS, JS, Bootstrap, etc.)
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

// Default routing → Start with Contact Controller
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Contact}/{action=ShowContacts}/{id?}");

app.Run();