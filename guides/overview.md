## Overview
Infuse is a filesystem router powered by [Simplates](Simplates.md). Simplates are a file format for server-side web programming. They're are a clean way of bringing your templates and code closer together. Infuse works by giving you a web_root that you can use for Simplates or static files.

## Quick Start

Installing Infuse is as simple as creating a new Elixir app and requiring the server, from then on anything you put in your `www` directory will be served. Any application code you write in your `lib` folder will be available to your simplates.

Start by creating a new mix application

    $ mix new my_website

Now modify your `deps()` function to include Infuse.

    def deps do
      [{:infuse, "~> 0.3.0"}]
    end

Create a `www` directory

    $ mkdir www 

Create a new simplate called `index.html.spt` in that www directory

    <script>
      IO.puts("I live in a Simplate")
      rand_num = :rand.uniform(10)
    </script>

    <template>

      <h1>Hello, my favorite random number is <%= rand_num %>!</h1>

      <p style="font-size: 24px; line-height: 24px;">
        <span style="margin-left: 80px;">☄</span><br />
        <br />
        ☃
      </p>
      Help save the unicode snowman!
    </template>

Start your server
    
    $ mix run --no-halt

Open your browser to: http://localhost:8101/