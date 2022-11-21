import prologue
import std/[strutils, os, json]


# Layout
const layout = """<!DOCTYPE html>
<html dir="ltr" lang="en">
<head>
<meta name="viewport" content="width=device-width" />
<title>{{ name }}</title>
</head>
<body>
<h1>{{ name }}</h1>
<p>{{ msg }}</p>
<p>Powered by <a href="https://github.com/exitcas/envshort">Envshort</a> v2.0.0</p>
</body>
</html>"""


# Check types
proc ctype(): int =
  var config = parseJson(readFile("config.json"))
  return config["type"].getInt()

# Serve JSON
proc cjson(): JsonNode =
  var cjson = parseJson(readFile("config.json"))
  return cjson


# Index
proc index(ctx: Context) {.async.} =
  # Set up variables
  var site = layout
  var name = ""
  var description = ""

  # If "type" = 1 (Use enviroment variables as database)
  if ctype() == 1:
    name = getEnv("name")
    description = getEnv("description")
  # If "type" = 0 or other value (Use JSON as database)
  else:
    name = cjson()["name"].getStr()
    description = cjson()["description"].getStr()

  site = site.replace("{{ name }}", name)
  site = site.replace("{{ msg }}", description)
  resp site


# Path managment
proc urls(ctx: Context) {.async.} =
  # Set up variables
  var name = ""
  var link = ""
  var exists = false

  if ctype() == 1:
    # Check if url exists
    if existsEnv("url_" & ctx.getPathParams("url")):
      exists = true
      link = getEnv("url_" & ctx.getPathParams("url"))
    else:
      name = getEnv("name")
  else:
    # Check if url exists
    if cjson()["urls"].hasKey(ctx.getPathParams("url")):
      exists = true
      link = cjson()["urls"][ctx.getPathParams("url")].getStr()
    else:
      name = cjson()["name"].getStr()

  if exists:
    # Redirect if it exists
    resp redirect(link)
  else:
    # Throw a 404 error if not
    var site = layout
    site = site.replace("{{ name }}", name)
    site = site.replace("{{ msg }}", "<b>404</b> - Not found")
    resp site, Http404


# 500 error
proc go500(ctx: Context) {.async.} =
  # Set up variables
  var name = ""

  if ctype() == 1:
    name = getEnv("name")
  else:
    name = cjson()["name"].getStr()

  var site = layout
  site = site.replace("{{ name }}", name)
  site = site.replace("{{ msg }}", "<b>500</b> - Internal Server Error")
  resp site, Http500


# Server settings and setup
var port  = 8080
var debug = false

if ctype() == 1:
  port  = parseInt(getEnv("port"))
  debug = parseBool(getEnv("debug"))
else:
  port  = cjson()["port"].getInt()
  debug = cjson()["debug"].getBool()

var app = newApp(settings = newSettings(
  appName = "Envshort",
  port    = Port(port),
  debug   = debug
))

app.registerErrorHandler(Http500, go500)
app.addRoute("/", index)
app.addRoute("/{url}$", urls)
if not debug: echo "Envshort is serving at http://0.0.0.0:" & intToStr(port)
app.run()
