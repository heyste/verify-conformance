# Behaviour

Feature: Verify Conformance Product Submission

  Background:
    Given a conformance product submission PR

  Scenario: a test label is set
    Given a PR without the label "caleb-is-sorry-that-you-see-this-label"
    Then add the label "caleb-is-sorry-that-you-see-this-label" to the PR
    Then remove the label "caleb-is-sorry-that-you-see-this-label" from the PR
    # Then i will fail for some reason

  Scenario: Files must exist in correct folders
    Given the files in the PR
    Then file folder structure must match regex "(v1.[0-9]{2})/(.*)/.*"
    # $1 is the release version of Kubernetes
    # $2 is the product name
    # example: v1.23/coolthing/some.file

  Scenario: Check for required files
    Given the required <file>
    Then each <file> must not be empty

    Examples:
      | file         |
      | README.md    |
      | PRODUCT.yaml |
      | e2e.log      |
      | junit_01.xml |

  Scenario: PRODUCT.yaml must contain required fields
    Given a "PRODUCT.yaml" file
    Then the yaml must contain the required and non-empty <field>
    And if <type> is "url", the content of the url in the <field>'s value must match it's <dataType>

    Examples:
      | field             | contentType | dataType                         |
      | vendor            | info        | string                           |
      | name              | info        | string                           |
      | version           | info        | string                           |
      | type              | info        | string                           |
      | description       | info        | string                           |
      | website_url       | url         | text/html                        |
      | repo_url          | url         | text/html                        |
      | documentation_url | url         | text/html                        |
      | product_logo_url  | url         | image/svg application/postscript |


  Scenario: Check product name is in PR title
    Given the title of the PR
    Then the title of the PR must match "(.*) (v1.[0-9]{2})[ /](.*)"
    # $1 is the string for conformance results for
    # $2 is the version of Kubernetes
    # $3 is the product name
    # example: Conformance test for v1.23 Cool Engine

  Scenario: Check e2e.log for Kubernetes release version
    Given a "e2e.log" file
    Then a line of the file "e2e.log" must match ".*e2e test version: (v1.[0-9]{2}(.[0-9]{2})?)$"
    # $1 is the release version of Kubernetes
    # $2 is the (optional) point release version of Kubernetes
    # example: Feb 25 10:20:32.383: INFO: e2e test version: v1.23.0
