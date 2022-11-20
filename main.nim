import prologue
import std/[strutils, os]


# Index
proc index(ctx: Context) {.async.} =
  var site = readFile("template.html")
  site = site.replace("{{ name }}", getEnv("name"))
  site = site.replace("{{ msg }}", getEnv("description"))
  resp site
# Path managment
proc urls(ctx: Context) {.async.} =
  if existsEnv("url_" & ctx.getPathParams("url")):
    resp redirect(getEnv("url_" & ctx.getPathParams("url")))
  else:
    # 404 error
    var site = readFile("template.html")
    site = site.replace("{{ name }}", getEnv("name"))
    site = site.replace("{{ msg }}", "<b>404</b> - Not found")
    resp site, Http404
# 500 error
proc go500(ctx: Context) {.async.} =
  var site = readFile("template.html")
  site = site.replace("{{ name }}", getEnv("name"))
  site = site.replace("{{ msg }}", "<b>500</b> - Internal Server Error")
  resp site, Http500


var app = newApp(settings = newSettings(
  port = Port(8080)
))

app.registerErrorHandler(Http500, go500)
app.addRoute("/", index)
app.addRoute("/{url}$", urls)
app.run()