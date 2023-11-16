pipeline {
  agent any
  stages {
    stage ("Build") {
       steps {
         echo "Build"
         echo " $env.BUILD_NUMBER"
         echo " $env.BUILD_ID"
         echo "$env.JOB_NAME"
    }
    }
     stage ("Test") {
       steps {
         sh ' mvn --version ' 
     }
     }
     stage ("Integration est") {
       steps {
        echo "Intration Test"
      }
     }
  }
  post {
    always {
      echo "Iam awesome"
    }

    success {
       echo "build is fail"
    }

    failure {
      echo " Job is fail"
    }
    }
}
