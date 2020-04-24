#!/usr/bin/env groovy

node {
        checkout scm

        if (env.BRANCH_NAME == "master") {
            stage("Build and push") {
                sh("""#!/bin/bash -xe
                export DOCKER_TAG=latest
                ./bin/build.sh
                ./bin/push.sh
                """)
            }
        }
}
