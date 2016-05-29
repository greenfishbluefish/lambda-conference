# lambda-conference

Creating conference management software with Angular over REST in AWS Lambda

# Architecture

* Angular SPA hosted in S3+CloudFront
* SPA talks to a REST API
* REST API is hosted in AWS Lambda+API Gateway
* Development environment is Angular + ExpressJS REST API
  * Key is to have one file edited, multiple deployments

# Usage

## Initial setup

* `npm install`
  * This will setup all dependencies as specified in `package.json`.

## Development

All files are located in app/routes and are written in Coffeescript. Each route
has two files:

  * N.coffee - this is the body of the function, uploaded to AWS Lambda.
  * N.json - this is the configuration for the API Gateway of this route. It can
  contain the following:
    * (R) method (GET, POST, etc)
    * (R) path (The URL to respond to, can contain templating)
    * (O) requestTemplates (how to map the params given different request formats)
    * (O) responses (how to handle different response codes)
      * selectionPattern
      * responseTemplates (how to map the response given different formats)


The task runner is the Gruntfile, also written in Coffeescript.

To run the server, use `grunt serve`, then navigate to http://localhost:3000/

To run the tests, use `grunt test` (or just `grunt`). The expected coverage is
enforced at 100%. (Enforcement is set within the package.json file.)
