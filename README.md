# JSTP Ruby Gem

Server & Client reference implementation of the sketch protocol JSTP (JavaScript Serialization Transfer Protocol). 

The protocol specification can be found in the [RFC](https://github.com/Fetcher/jstp-rfc)


API
---

The API of the JSTP Ruby Gem remained undocumented, mainly because right now it is sketchy. Here I write some guidelines:

-   It should be possible to pass a Logger as argument to JSTP so that ingoing and outgoing dispatches and exceptions are logged.
-   Now that JSTP is an engine, lets drop the DSL in the main object and use the standard Ruby configuration strategy:

        JSTP.config do |config|
            config.strategy outgoing: :tcp, ingoing: :websocket
            config.port outgoing: 80, ingoing: 65
            config.hostname "session.manager"
            config.logger Logger.new
        end 

-   A block as a middleware should also be configurable in the dispatch, similar to the former implementation.
-   The engine should be configured with a hostname that will override the linux hostname found automatically by JSTP. This hostname will be used to detect dispatches as aimed to this node.
-   The engine should automatically forward ingoing dispatches that carry a different hostname from the one of this node to the corresponding node. In this way, each JSTP Node is automatically a gateway.
-   There should be a DSL in the Controller class for creating aahnd sending a JSTP Dispatch. The library should be able to recognize when an outgoing dispatch is actually aimed at self, so it gets mapped correctly without the need to generate network activity. This DSL should provide also an easy way to switch outgoing strategies.
-   The message as passed to the Controller's initializer should be made into a Private Class Data. In this context, I should explore a little the idea of mapping the ingoing Dispatch into a class.
-   The Dispatch class should have a Writer an Reader that make it possible to log and parse dispatches from the abbreviated, similar-to-HTTP syntax.
-   [distant future] Support for SSL/TLS.

## Installation
Add this line to your application's Gemfile: 

    gem 'jstp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jstp
