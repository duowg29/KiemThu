pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git branch: 'main', 
                     url: 'https://github.com/duowg29/KiemThu',
                     credentialsId: '' // Để trống nếu repo public, hoặc thêm credentialsId nếu private
            }
        }
        stage('Run Katalon Tests') {
            steps {
                echo 'Running Katalon Studio tests...'
                timeout(time: 30, unit: 'MINUTES') {
                bat '''
                    set KATALON_HOME=C:\\Users\\feu29\\.katalon\\packages\\KSE-10.4.2
                    
                    REM Tắt hoàn toàn WebView server bằng cách set JVM args
                    REM Các args này sẽ ngăn WebView server khởi động hoặc làm nó fail gracefully
                    set JAVA_TOOL_OPTIONS=-Djava.awt.headless=true -Dorg.eclipse.swt.browser.DefaultType=none -Dorg.eclipse.swt.browser.noDefault=true -Dkatalon.execution.report.enabled=false -Dkatalon.webview.enabled=false -Dorg.eclipse.swt.browser.chromium.enabled=false -Declipse.e4.inject.javax.disabled=true -Dorg.eclipse.swt.browser.WebView.enabled=false -Dorg.eclipse.swt.browser.WebView2.enabled=false
                    set JAVA_OPTS=-Djava.awt.headless=true -Dorg.eclipse.swt.browser.DefaultType=none -Dorg.eclipse.swt.browser.noDefault=true -Dkatalon.execution.report.enabled=false -Dkatalon.webview.enabled=false -Dorg.eclipse.swt.browser.chromium.enabled=false -Declipse.e4.inject.javax.disabled=true -Dorg.eclipse.swt.browser.WebView.enabled=false -Dorg.eclipse.swt.browser.WebView2.enabled=false
                    set KATALON_OPTS=-noSplash -noExit -consoleLog
                    
                    REM Thử sửa file katalon.ini nếu có quyền (optional)
                    REM if exist "%KATALON_HOME%\\katalon.ini" (
                    REM     copy "%KATALON_HOME%\\katalon.ini" "%KATALON_HOME%\\katalon.ini.bak"
                    REM     echo -Djava.awt.headless=true >> "%KATALON_HOME%\\katalon.ini"
                    REM     echo -Dorg.eclipse.swt.browser.DefaultType=none >> "%KATALON_HOME%\\katalon.ini"
                    REM     echo -Dkatalon.webview.enabled=false >> "%KATALON_HOME%\\katalon.ini"
                    REM )
                    
                    REM Chạy Katalon - WebView sẽ không khởi động với các JVM args trên
                    "%KATALON_HOME%\\katalon.exe" -runMode=console ^
                    -projectPath="%WORKSPACE%" ^
                    -retry=0 ^
                    -testSuitePath="Test Suites/Functional/Login Testcases" ^
                    -executionProfile="default" ^
                    -browserType="Chrome (headless)" ^
                    -apiKey="" ^
                    -g_username="" ^
                    -g_password=""
                '''
                }
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