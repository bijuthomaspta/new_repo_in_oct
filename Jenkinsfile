pipeline {
  agent { docker { image 'maven:3.63'}}
  stages {
    stage ("Build") {
       steps {
         echo "Build"
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
