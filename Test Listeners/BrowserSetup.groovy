import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject

import com.kms.katalon.core.checkpoint.Checkpoint as Checkpoint
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.testcase.TestCase as TestCase
import com.kms.katalon.core.testdata.TestData as TestData
import com.kms.katalon.core.testobject.TestObject as TestObject

import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile

import internal.GlobalVariable as GlobalVariable

import com.kms.katalon.core.annotation.BeforeTestCase
import com.kms.katalon.core.annotation.BeforeTestSuite
import com.kms.katalon.core.annotation.AfterTestCase
import com.kms.katalon.core.annotation.AfterTestSuite
import com.kms.katalon.core.context.TestCaseContext
import com.kms.katalon.core.context.TestSuiteContext

class BrowserSetup {

	@BeforeTestSuite
	def beforeTestSuite(TestSuiteContext testSuiteContext) {
		// Setup before test suite starts
		println "Starting test suite: ${testSuiteContext.getTestSuiteId()}"
	}

	@BeforeTestCase
	def beforeTestCase(TestCaseContext testCaseContext) {
		// Tự động maximize window trước mỗi test case
		// Lưu ý: maximizeWindow() sẽ được gọi trong test case sau khi openBrowser
		// Đây chỉ là backup nếu test case quên maximize
		safeMaximizeWindow()
	}
	
	@AfterTestCase
	def afterTestCase(TestCaseContext testCaseContext) {
		// Cleanup sau mỗi test case nếu cần
	}
	
	/**
	 * Maximize window một cách an toàn (bỏ qua trong headless mode)
	 * @param context Optional context message for logging
	 */
	private void safeMaximizeWindow(String context = '') {
		// Bỏ qua nếu đang chạy trong headless mode
		if (isHeadlessMode()) {
			return
		}
		
		try {
			WebUI.maximizeWindow()
			if (context) {
				println "✓ Window maximized $context"
			}
		} catch (Exception e) {
			// Browser chưa mở hoặc headless mode, bỏ qua
			// Không log error để tránh spam trong headless mode
		}
	}
	
	/**
	 * Kiểm tra xem có đang chạy trong headless mode không
	 * @return true nếu headless mode, false nếu không
	 */
	private boolean isHeadlessMode() {
		try {
			// Kiểm tra browser type từ GlobalVariable
			try {
				String browserType = GlobalVariable.browserType
				if (browserType != null && browserType.toLowerCase().contains('headless')) {
					return true
				}
			} catch (Exception e) {
				// GlobalVariable.browserType có thể không tồn tại
			}
			
			// Kiểm tra JAVA_OPTS system property
			String headlessProp = System.getProperty('java.awt.headless')
			if (headlessProp != null && headlessProp.equalsIgnoreCase('true')) {
				return true
			}
			
			// Kiểm tra browser type từ system property
			String browserTypeProp = System.getProperty('katalon.browser.type')
			if (browserTypeProp != null && browserTypeProp.toLowerCase().contains('headless')) {
				return true
			}
			
			// Kiểm tra environment variable
			String browserTypeEnv = System.getenv('KATALON_BROWSER_TYPE')
			if (browserTypeEnv != null && browserTypeEnv.toLowerCase().contains('headless')) {
				return true
			}
			
			// Mặc định: không phải headless (để maximize hoạt động trên local)
			return false
		} catch (Exception e) {
			// Nếu có lỗi khi kiểm tra, giả định không phải headless
			return false
		}
	}
}
