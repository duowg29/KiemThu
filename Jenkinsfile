pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', 
                     url: 'https://github.com/ThienPhu41224/KiemThu.git',
                     credentialsId: '' // Để trống nếu repo public, hoặc thêm credentialsId nếu private
            }
        }
        stage('Run Katalon Tests') {
            steps {
                echo 'Running Katalon Studio tests...'
                bat '''
                    "C:\Users\haidu\.katalon\packages\KSE-10.4.2\katalon.exe" -runMode=console ^
                    -projectPath="%WORKSPACE%" ^
                    -retry=0 ^
                    -testSuitePath="Test Suites/UI Testing" ^
                    -executionProfile="default" ^
                    -browserType="Chrome (headless)" ^
                    -apiKey="" ^
                    -g_username="" ^
                    -g_password=""
                '''
            }
        }
        
        stage('Archive Reports') {
            steps {
                echo 'Archiving test reports...'
                archiveArtifacts artifacts: 'Reports/**/*', 
                                fingerprint: true, 
                                allowEmptyArchive: true
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'Tests passed successfully!'
        }
        failure {
            echo 'Tests failed!'
        }
    }
}