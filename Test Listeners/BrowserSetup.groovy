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
import com.kms.katalon.core.annotation.AfterTestStep
import com.kms.katalon.core.context.TestCaseContext
import com.kms.katalon.core.context.TestSuiteContext
import com.kms.katalon.core.context.TestStepContext

class BrowserSetup {

	@BeforeTestSuite
	def beforeTestSuite(TestSuiteContext testSuiteContext) {
		// Setup before test suite starts
		println "Starting test suite: ${testSuiteContext.getTestSuiteId()}"
	}

	@BeforeTestCase
	def beforeTestCase(TestCaseContext testCaseContext) {
		// Tự động maximize window trước mỗi test case
		// Nếu browser chưa mở thì bỏ qua (sẽ maximize sau khi browser mở)
		try {
			WebUI.maximizeWindow()
		} catch (Exception e) {
			// Browser chưa mở, không cần xử lý
		}
	}
	
	@AfterTestStep
	def afterTestStep(TestStepContext testStepContext) {
		// QUAN TRỌNG: Sau mỗi test step, tự động maximize window
		// Đảm bảo window được maximize sau khi browser mở hoặc navigate
		try {
			String stepName = testStepContext.getTestStepName()
			
			// Maximize sau các step quan trọng (openBrowser, navigateToUrl)
			if (stepName != null) {
				String lowerStepName = stepName.toLowerCase()
				
				if (lowerStepName.contains('openbrowser') || 
					lowerStepName.contains('navigatetourl') ||
					lowerStepName.contains('navigateto')) {
					// Đợi browser sẵn sàng (tăng thời gian đợi)
					Thread.sleep(800)
					WebUI.maximizeWindow()
					println "✓ Window maximized after: $stepName"
				} else {
					// Với các step khác, vẫn thử maximize (nếu browser đã mở)
					WebUI.maximizeWindow()
				}
			} else {
				// Nếu không có step name, vẫn thử maximize
				WebUI.maximizeWindow()
			}
		} catch (Exception e) {
			// Browser chưa mở hoặc đã đóng, bỏ qua
		}
	}
}
