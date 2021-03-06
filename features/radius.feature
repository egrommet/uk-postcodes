Feature: Postcode Radius

  As as user
  I want to get data about postcodes within a defined radius
  
  Background:
    Given there are the following postcodes:
      | ABC 123  | 51.525994048543595 | -0.08776187896728516 |
      | ABC 345  | 51.52156160130253  | -0.08334159851074219 |
      | ABC 678  | 51.52967852566192  | -0.09698867797851562 |
      | ABC 910  | 51.52284331713511  | -0.12033462524414062 |
  
  Scenario: Getting HTML version of radius from postcode
    And I make a request for postcodes within 1 mile of "ABC 123"
    Then I should see 3 postcodes
    And I should see the following postcodes:
      | ABC 123 |
      | ABC 345 |
      | ABC 678 |

  Scenario: Getting HTML version of radius from latlng
    And I make a request for postcodes within 1 mile of 51.525994048543595,-0.08776187896728516
    Then I should see 3 postcodes
    And I should see the following postcodes:
      | ABC 123 |
      | ABC 345 |
      | ABC 678 |

  Scenario: Getting JSON version of radius from latlng
    And I make a request for the JSON version of postcodes within 1 mile of 51.525994048543595,-0.08776187896728516
    Then I should see the following json:
    """
    [
      {
        "postcode": "ABC 123",
        "lat": 51.525994048543595,
        "lng": -0.08776187896728516,
        "distance": 0.0,
        "uri": "http://www.example.com/postcode/ABC123"
      },
      {
        "postcode": "ABC 345",
        "lat": 51.52156160130253,
        "lng": -0.08334159851074219,
        "distance": 0.3604,
        "uri": "http://www.example.com/postcode/ABC345"
      },
      {
        "postcode": "ABC 678",
        "lat": 51.52967852566192,
        "lng": -0.09698867797851562,
        "distance": 0.4713,
        "uri": "http://www.example.com/postcode/ABC678"
      }
    ]
    """
  
  Scenario: Legacy redirects
    And I make a request to "/distance.php?lat=51.525994048543595&lng=-0.08776187896728516&distance=1"
    Then I should see 3 postcodes
    And I should see the following postcodes:
      | ABC 123 |
      | ABC 345 |
      | ABC 678 |
      
  Scenario: Missing longitude  
    And I make a request to "/postcode/nearest.json?miles=1&lat=51.525999"
    Then the response should be "422"
    And I should see the error "You must specify a latitude and longitude"

  Scenario: Missing longitude  
    And I make a request to "/postcode/nearest.json?lat=51.525999&lng=-0.087761878"
    Then the response should be "422"
    And I should see the error "You must specify a distance"
    
  Scenario: Radius is more than the permitted maximum
    And I make a request for postcodes within 10 mile of "ABC 123"
    Then the response should be "422"
    And I should see the error "The maximum radius is 5 miles"

