# uber_command_line

This is a Ruby application that runs from the command line and allows you to easily request an Uber.

To start, you'll need to set some environment variables:

````bash
export UBER_SERVER_TOKEN=
export UBER_BEARER_TOKEN=
export UBER_CLIENT_ID=
export UBER_SECRET=

export UBER_REAL_RIDE=true
export UBER_DEFAULT_LOCATION="Address 1235, Blah, Blah City, 32432"
````

Then run `bundle install` to make sure you have all the dependencies. Then run `ruby uber_command_line.rb` to get started.

Happy hailing!