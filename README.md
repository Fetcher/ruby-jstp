# JSTP Ruby Gem

Server & Client reference implementation of the sketch protocol JSTP (JavaScript Serialization Transfer Protocol). Here follows the basics of the protocol as of version 0.1.

JSTP
----

JSTP is a communication protocol based on JSON serialization that works over websockets in the default TCP port `33333`. It's inspired and aimed to maintain compatibility with HTTP as used in REST architectures but using JSON as the protocol language.

The protocol is symmetrical: this means that there is only one type of message, in constrast to _Request-Response_ kind of protocols such as `HTTP`. Sending a message is called `dispatch` in the JSTP vocabulary. As JSTP is built upon Web Sockets, is also by design asynchronous, meaning that a Dispatch is not necessarily follow by any kind of response by the receiver. To facilitate the follow up in communication threads, JSTP provides a `token` header which we suggest to fill with a control hash (a similar concept to HTTP's Etag header). As much of the headers, the `token` header is extensible to an array capable of containing several tokens ordered by priority (is still to be seen is all JSTP headers by default will support or not multiple values).

The headers types, available protocol methods, resource taxonomy and message body are designed to be 100% compatible with REST (implying that system that make use of JSTP for their network communications may fall back to plain HTTP if technical limitations require it). Headers are not bound to include all of the same data that HTTP regular _Requests_ or _Responses_, but can.

An sample Dispatch will look like:

    {
      "protocol": ["JSTP", "0.1"]
      "method": "POST", 
      "resource": [
        "session.manager",
        "User"
      ],
      "timestamp": 1357334118,
      "token": 3523902859084057289594,
      "referer": [
        "browser",
        "Registerer"
      ],
      "body": {
        "login": "xavier",
        "email": "xavier@fetcher.com",
        "password": "secret"
      }
    }

A **JSTP Dispatch** can also be formatted in a short hand notation similar to that of an HTTP Request. The previous example can be presented as follows:

    POST session.manager/User JSTP/0.1
    timestamp: 1357334118
    token: 3523902859084057289594
    referer: browser/Registerer
    
    login: xavier
    email: xavier@fetcher.com
    password: secret

Gateways
--------

Every JSTP server knows its own hostname, which should match the first string in the resource array of the message. If the host as received in the message does not corresponds to this server, it should look up for the right server and dispatch it.

API
---

The API of the JSTP Ruby Gem remained undocumented, mainly because right now it is sketchy. Here I write some guidelines:

- It should be possible to pass a Logger as argument to JSTP so that ingoing and outgoing dispatches and exceptions are logged.
- Now that JSTP is an engine, lets drop the DSL in the main object and use the standard Ruby configuration strategy:

    JSTP.config do lconfigl
      config.strategy outgoing: :tcp, ingoing: :websocket
      config.port outgoing: 80, ingoing: 65
      config.hostname "session.manager"
    end 

- A block as a middleware should also be configurable in the dispatch, similar to the former implementation.
- The engine should be configured with a hostname that will override the linux hostname found automatically by JSTP. This hostname will be used to detect dispatches as aimed to this node.
- The engine should automatically forward ingoing dispatches that carry a different hostname from the one of this node to the corresponding node. In this way, each JSTP Node is automatically a gateway.
- There should be a DSL in the Controller class for creating aahnd sending a JSTP Dispatch. The library should be able to recognize when an outgoing dispatch is actually aimed at self, so it gets mapped correctly without the need to generate network activity. This DSL should provide also an easy way to switch outgoing strategies.
- The message as passed to the Controller's initializer should be made into a Private Class Data. In this context, I should explore a little the idea of mapping the ingoing Dispatch into a class.
- Test implementation with Oj JSON parser/dumper.
- The Dispatch class should have a Writer an Reader that make it possible to log and parse dispatches from the abbreviated, similar-to-HTTP syntax.
- [distant future] Support for SSL/TLS.

## Installation
Add this line to your application's Gemfile: 

    gem 'jstp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jstp
