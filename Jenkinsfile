pipeline {
  agent { docker { image ' httpd:latest '}}
  stages {
    stage ("Build") {
       steps {
         // sh ' systemctl start httpd'
    }
    }
     stage ("Test") {
       steps {
         // sh 'systemctl enable httpd' 
     }
     }
     stage ("Integration est") {
       steps {
        // sh ' systemctl status httpd '
      }
     }
  }
  post {
    always {
      echo "I am awesome"
    }

    success {
       echo "build is Success"
    }

    failure {
      echo " Job is fail"
    }
    }
}
