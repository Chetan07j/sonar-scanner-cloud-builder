# SonarQube Scanning
This builder allows you to run static code analysis using Sonarqube on your code.

## Building this builder
Run the command below to build this builder

```sh
gcloud builds submit . --config=cloudbuild.yaml
```

## Build image locally
Run this command to build `sonar-scanner` image locally

```sh
docker build --build-arg SONARQUBE_SCANNER_CLI_VERSION=4.4.0.2170 -t <IMAGE-NAME-TO-GIVE> .
```
> e.g. `docker build --build-arg SONARQUBE_SCANNER_CLI_VERSION=4.4.0.2170 -t sonar-scanner .`

## Running the analysis
- Locally (_enter into directory where you want to run sonar scan and execute below command_)

  ```sh
  docekr run -it <IMAGE-NAME-TO-GIVE> sonar-scanner \
    -Dsonar.projectKey=<SONAR-PROJECT-KEY> \
    -Dsonar.projectName=<SONAR-PROJECT-NAME> \
    -Dsonar.host.url=https://<GIT-ORG-URL> \
    -Dsonar.login=<SONAR-LOGIN> \
    -Dsonar.sources=.
  ```

- Cloud build

  ```yaml
  - id: Sonar Analysis
    name: 'gcr.io/$PROJECT_ID/sonar-scanner:latest'
    entrypoint: bash
    args:
      - '-c'
      - |
        sonar-scanner \
          -Dsonar.projectKey=<SONAR-PROJECT-KEY> \
          -Dsonar.projectName=<SONAR-PROJECT-NAME> \
          -Dsonar.host.url=<SONAR-HOST-URL> \
          -Dsonar.login=<SONAR-LOGIN> \
          -Dsonar.sources=. \
          -Dsonar.pullrequest.github.endpoint=https://<GIT-ORG-URL>/api/v3 \
          -Dsonar.pullrequest.github.repository=<GIT-ORG-NAME-IF-ANY>/$REPO_NAME \
          -Dsonar.pullrequest.key=$_PR_NUMBER \
          -Dsonar.pullrequest.branch=$BRANCH_NAME \
          -Dsonar.pullrequest.base=$_BASE_BRANCH \
          -Dsonar.java.binaries=**/target/classes \
          -Dsonar.java.source=1.8 \
          -Dsonar.java.libraries=**/target/*.jar \
          -Dsonar.javascript.lcov.reportPaths=**/coverage/lcov.info \
          -Dsonar.exclusions=**/test/**,**/config/** \
          -Dsonar.eslint.reportPaths=**/eslint-report.json
  ```
