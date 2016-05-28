# lambda-conference

Creating conference management software with Angular over REST in AWS Lambda

# Architecture

* Angular SPA hosted in S3+CloudFront
* SPA talks to a REST API
* REST API is hosted in AWS Lambda+API Gateway
* Development environment is Angular + ExpressJS REST API
  * Key is to have one file edited, multiple deployments
