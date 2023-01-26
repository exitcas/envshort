# Envshort

A simple private URL shortener powered by [Nim](https://nim-lang.org/).

## Demo
Want to see it working? Take a look at our [demo](https://envshort.atico.eu.org/).
- [/example](https://envshort.atico.ga/example)
- [/test](https://envshort.atico.ga/test)

## Install
### Getting ready the environment.
1. Install [Nim](https://nim-lang.org/install.html) on your computer.
2. Install [Prologue](https://planety.github.io/prologue/).
### Compile
3. Execute `nim c main.nim` on your PC.
### Configure
4. Select if you want to use a JSON file or your environment variables as your database, editing the variable "`type`" at `config.json`.
   - Option 0 => JSON file
     - Edit `config.json`.
     - Add keys to `urls`. The name will be the path and the content will be the address it will redirect to.
   - Option 1 => Environment variables
     - Take as a base `.env`.
     - Create URLs creating variables starting with "`url_`", followed by the desired path. The value will be the address it will redirect to.
### Execute
5. Execute `main.exe` if you are on Windows or run `main` if you are running Linux or Mac.

## Support
Need help? Found a bug? Take a look at our [issues page](https://github.com/exitcas/envshort/issues)!
