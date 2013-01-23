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

Scenario: Mixed arguments in the query
  Given the class:
  """
  class Mixed
    class Argument < JSTP::Controller
      def delete params
        Testing.test_log << params["query"]
      end
    end
  end
  """
  When I send the dispatch:
  """
  {
    "method": "DELETE",
    "resource": ["localhost", "Mixed", "54s3453", "Argument", "35asdf"]
  }
  """
  Then I should have '["54s3453", "35asdf"]' in the test log

Scenario: A complex example just for the fun
  Given the class:
  """
  class Deeper
    class Inside
      class Klass < JSTP::Controller
        def get params
          Testing.test_log << params["query"]
          Testing.test_log << params["body"]
          Testing.test_log << @protocol
          Testing.test_log << @token
        end
      end
    end
  end
  """
  When I send the dispatch:
  """
  {
    "protocol": ["JSTP", "0.1"],
    "resource": ["localhost", "Deeper", "52345", "Inside", "Klass", "53afas", "54234"],
    "method": "GET",
    "token": ["25353"],
    "body": {
      "id": 20
    }
  }
  """
  Then I should have '["JSTP", "0.1"]' in the test log
  Then I should have '["52345", "53afas", "54234"]' in the test log
  Then I should have '["25353"]' in the test log
  Then I should have '{"id": 20}' in the test log