# lambda-conference

Creating conference management software with Angular over REST in AWS Lambda

# Architecture

* Angular SPA hosted in S3+CloudFront
* SPA talks to a REST API
* REST API is hosted in AWS Lambda+API Gateway
* Development environment is Angular + ExpressJS REST API
  * Key is to have one file edited, multiple deployments

# Initial setup

* `npm install`
  * This will setup all dependencies as specified in `package.json`.

# Development

## Source files

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

## Task Runner

The task runner is the Gruntfile, also written in Coffeescript.

### Development server

To run the server, use `grunt serve`, then navigate to http://localhost:3000/

### Running the tests

To run the tests, use `grunt test` (or just `grunt`). The expected coverage is
enforced at 100%. (Enforcement is set within the package.json file.)

# Deployment

The deployed architecture will be:

* The API will be versioned.
  * The initial version is v1.
  * Versions will be monotoniccally increaseing integers. (v2, v3. No decimals)
  * A new version will be required if:
    * An existing API call must change in calling syntax
    * An existing API call must be removed
    * There is a sufficiently-large change in calling semantics
* Environments: prod-v1, stage-v1, prod-v2, stage-v2, etc
  * Dev is on your workstation
  * If a QA person wants to see your work, they check out the branch.
  * Each version will have its own set of environments.
  * Each environment can be given separate access controls.
    * Each environment will be in a separate VPC (?)
* There will be a URL for each environment:
  * https://api.<name>.com/<version>/ for prod
  * https://<env>.api.<name>.com/<version>/ for <env>
    * Initially, there will only be "stage" and "v1"
* API gateway will have "Stages" corresponding to the environments.
  * The appropriate URLs will map to the API gateway stage for each environment.
  * The Lambda alias will map to the API gateway stage for each environment.
* Lambda functions will be deployed into AWS to the stage  Tenvironment.
  * Deployment is of all functions at the same time.
    * Even if a specific function hasn't changed.
  * This will update the stage alias for all deployed functions.
  * Deploying to a version's prod will be from the version's current stage.
  * Future: possibly deploy to prod from a known-good stage.
* The API gateway can only be added to within the same API version.
  * Existing API syntax cannot change or be deleted in prod.
  * New API calls can be added to prod.
    * These additions will be deployed to stage, then copied from stage to prod.
  * Changes can be made to stage and other environments as development occurs.
    * These changes can only be made to things new to prod.
    * Upon deployment to prod, those items are frozen.

Questions:
* Should https://prod.api.<name>.com/<version>/ will map to the prod URL?

## Notes

Unlike [serverless](http://docs.serverless.com/), this project assumes that the
AWS Lambda functions will only ever be called from the API Gateway or on a timed
(cron) basis. There is no need to support S3 or Kinesis at this time.

The reasons for not using serverless for operations are because it does **NOT**:
* provide an appropriate level of abstraction from AWS details
* handle the initial steps correctly
* transparently handle key management
* enable a purely CLI (no UI) operations infrastructure
* support the SDLC required by most enterprises:
  * provide a good way to manage versioning
  * lock the production API Gateway definitions
  * force promotion from stage to prod in lockstep

These reasons are in addition to the issues with the development environment:
* No support for containers
* No support for a development ExpressJS application
* No support for preambles (DB connection code)

## Initial steps

All of these steps are scripted. This documentation is provided for a reader's
convenience. Please see the appropriate scripts in `devops/provisioning` for
exact details.

These steps must be taken by someone with extended IAM privileges. However, this
will only ever be needed to be done once.

* Create necessary IAM roles
  * There is an IAM role for creating a new environment/version
  * There is an IAM role for deploying to prod-[all versions]
  * There is an IAM role for deploying to stage-[all versions]
* Create and manage any necessary other items, such as datastores.

## Create a new environment/version

All of these steps are scripted. This documentation is provided for a reader's
convenience. Please see the appropriate scripts in `devops/provisioning` for
exact details.

* Create the Route53 URLs
* Create the API Gateway elements
* Create and deploy stub AWS Lambda functions within the right stage.

## Deploy a new version

All of these steps are scripted. This documentation is provided for a reader's
convenience. Please see the appropriate scripts in `devops/provisioning` for
exact details.

* To non-production:
  * Update all Lambda functions simultaneously and move the alias(es)
  * Update any new-to-production API GW definitions
* To production:
  * Point the prod alias to where the stage alias points for all functions
  * Apply any new-to-production API GW definitions

# TODO

- [ ] Deploy to AWS
    - [ ] Initial steps
        - [ ] IAM
        - [ ] VPC (?)
        - [ ] CloudFormation (?)
        - [ ] What does an initial-stepper need from IAM?
    - [ ] New environment / version steps
        - [ ] Route53
        - [ ] KMS
        - [ ] VPC (?)
        - [ ] API Gateway
        - [ ] AWS Lambda
        - [ ] What does an new-version-maker need from IAM?
    - [ ] Modify an environment/version's access controls
        - [ ] What does a access-controller need from IAM?
    - [ ] Deploy new version (updating Lambda and API Gateway)
        - [ ] What does a deployer need from IAM?
        - [ ] Do we want a different IAM for stage vs. prod (edit/delete API-GW)
    - [ ] Extend the development environment to support versions
- [ ] Extend the functions to add counting hits (use DynamoDB / RDS)
    - [ ] Provide a container for datastore in dev
    - [ ] Provide preamble support for DB connections
    - [ ] Provide a NodeJS container to run the ExpressJS application
- [ ] Hoist app/app.coffee out of app/ to save a directory level
    - [ ] Release it to NPM?
- [ ] Sample app needs 2 different versions to show it off.
- [ ] Support cronjobs vs. API calls
