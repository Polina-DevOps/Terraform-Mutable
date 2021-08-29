pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['dev-apply', 'prod-apply'], description: 'Choose Environment')
    }
    stages {
        stage('VPC Apply') {
            steps {
                sh '''
          cd vpc
          make ${ACTION}
        '''
            }
        }
        stage('DB Apply') {
            steps {
                sh '''
          cd databases
          make ${ACTION}
        '''
            }
        }
    }
}