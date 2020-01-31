Feature: Getting user reactions count
    Provided the service has loaded cache, I should be able to get user reaction counts for a known content invalid
    Unknown content id should respond with erros

    Scenario Outline: Get user reactions count success
        Given I have a valid api key
        And There is data in the cache
        When I send a GET request to /api/reaction_counts/<content_id>
        Then I should get a response with status <expected_status_code>
        And Body to have property data
        And Data to have propert reaction_count
        And Reaction count to be <expected_reaction_count>
        Examples:
          | expected_status_code | content_id  | expected_reaction_count |
          |    200               | valid       | valid                   |
          |    200               | valid       | valid                   |
          |    200               | valid       | valid                   |
          |    200               | valid       | valid                   |
          |    200               | valid       | valid                   |
    
    Scenario Outline: Get user reactions count fail
        Given I have a valid api key
        When I send a GET request to /api/reaction_counts/<content_id>
        Then I should get a response with status <expected_status_code>
        Examples:
          | expected_status_code | content_id  |
          |    404               | unknown     |
    
    Scenario Outline: Get user reactions count fail - Invalid Token
        Given I have <api_key_type> api key
        When I send a GET request to /api/reaction_counts/<content_id>
        Then I should get a response with status <expected_status_code>
        Examples:
          | api_key_type      | content_id     | expected_status_code |
          | null              | valid_1        | 401                  |
          | invalid           | valid_2        | 401                  |
    