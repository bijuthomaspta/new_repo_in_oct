pipeline {
  agent any
  stages {
    stage ("Build") {
       steps {
         echo "Build"
    }
    }
     stage ("Test") {
       steps {
         echo "Tst"
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
       echo "build is fail
    }

    failre {
      echo " Job is fail"
    }
    }
}
