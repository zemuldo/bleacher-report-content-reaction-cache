Feature: Updating user reaction
    I should be able to get user reaction counts for a known content invalid
    Unknown content id should respond with erros. 

    Scenario Outline: Update reaction with
        Given I have a valid api key
        When I send a POST request to /api/reaction with <user_id>, <content_id> and action as added
        Then I should get a response with status <expected_status_code>
        When I send a GET request to /api/reaction_counts/<content_id>
        Then I should get a count of 1
        When I send a POST request to /api/reaction with <user_id>, <content_id> and action as removed
        When I send a GET request to /api/reaction_counts/<content_id>
        Then I should get a count of 0
        Examples:
          | expected_status_code | content_id  | user_id |
          |    200               | valid_1     | valid   |
    
    Scenario Outline: Update user reactions count fail - Invalid Token
        Given I have <api_key_type> api key
        When I send a POST request to /api/reaction with <user_id>, <content_id> and action as added
        Then I should get a response with status <expected_status_code>
        Examples:
          | api_key_type      | content_id     | expected_status_code | user_id |
          | null              | valid_1        | 401                  | valid   |
          | invalid           | valid_2        | 401                  | valid   |
    