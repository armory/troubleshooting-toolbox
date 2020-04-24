#!/usr/bin/env groovy

node {
        checkout scm

        if (env.BRANCH_NAME == "master") {
            stage("Build and push") {
                sh("""#!/bin/bash -xe
                export DOCKER_TAG=latest
                ./docker-debugging-tools/bin/build.sh
                ./docker-debugging-tools/bin/push.sh
                """)
            }
        }
}
