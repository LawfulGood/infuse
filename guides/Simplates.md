## Simplates
Simplates are a file format for server-side web programming.

## Why Simplates? 
Mixing code into templates leads to unmaintainable spaghetti. On the other 
hand, putting closely-related templates and code in completely separate 
subdirectories makes it painful to switch back and forth.

Simplates improve web development by bringing code and templates as close 
together as possible, _without_ mixing them.

## What does a Simplate look like?
Here's an example: 

    <script>
      program = "hellö"
      excitement = :rand.uniform(100)
    </script>

    <template type="text/html" via="EEx">
      <h1><%= hello %>, program, my favorite number is <%= num %></h1>
    </template>

