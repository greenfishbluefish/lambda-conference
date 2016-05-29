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

All files are located in app/ and are written in Coffeescript. The task runner
is the Gruntfile, also written in Coffeescript.

To run the server, use `npm serve`, then navigate to http://localhost:3000/
