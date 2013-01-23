Feature: Map á la REST

Scenario: Map a really simple dispatch to the correct class
  Given the class:
  """
  class User < JSTP::Controller
    def get
      Testing.test_log << "hola"
    end
  end
  """
  When I send the dispatch:
  """
  {
    "resource":["localhost", "User"],
    "method": "GET"
  }
  """
  Then I should have 'hola' in the test log

Scenario: A dispatch with a body
  Given the class:
  """
  class Article < JSTP::Controller
    def post params
      Testing.test_log << params["body"]
    end
  end
  """
  When I send the dispatch:
  """
  {
    "resource": ["localhost", "Article"],
    "method": "POST",
    "body": "some text"
  }
  """
  Then I should have 'some text' in the test log

Scenario: A compliant dispatch
  Given the class:
  """
  class ForDispatch < JSTP::Controller
    def get params
      Testing.test_log.concat [
        params["body"],
        @token,
        @timestamp,
        @referer,
        @protocol,
        @resource,
        @method
      ]
    end
  end
  """
  When I send the dispatch:
  """
  {
    "protocol": ["JSTP", "0.1"],
    "method": "GET",
    "resource": ["localhost", "ForDispatch"],
    "token": "523asdf243",
    "timestamp": 15453242542245,
    "referer": ["localhost", "Test"],
    "body": {
      "data": "some data"
    }
  }
  """
  Then I should have '["JSTP", "0.1"]' in the test log
  Then I should have 'GET' in the test log
  Then I should have '["localhost", "Test"]' in the test log
  Then I should have 15453242542245 in the test log
  Then I should have '523asdf243' in the test log
  Then I should have '{"data": "some data"}' in the test log
  Then I should have '["localhost", "ForDispatch"]' in the test log

Scenario: A dispatch with query arguments
  Given the class:
  """
  class Argumented < JSTP::Controller
    def put params
      Testing.test_log << params["query"]
    end
  end
  """
  When I send the dispatch:
  """
  {
    "method": "PUT",
    "resource": ["localhost", "Argumented", "querydata"]
  }
  """
  Then I should have '["querydata"]' in the test log
