pipeline {
  agent { docker { image 'maven:3.9-amazoncorretto-8-al2023'}}
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
