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
		// Tự động maximize window cho mọi test case trong mọi test suite
		try {
			// Thử maximize window ngay lập tức
			WebUI.maximizeWindow()
		} catch (Exception e) {
			// Nếu browser chưa mở, đợi một chút rồi thử lại
			try {
				Thread.sleep(500) // Đợi 500ms
		WebUI.maximizeWindow()
			} catch (Exception e2) {
				// Nếu vẫn không được, browser sẽ được mở bởi test case
				// Maximize sẽ được thực hiện sau khi browser mở
			}
		}
	}
	
	@AfterTestCase
	def afterTestCase(TestCaseContext testCaseContext) {
		// Đảm bảo window vẫn maximize sau mỗi test case
		try {
			WebUI.maximizeWindow()
		} catch (Exception e) {
			// Browser có thể đã đóng, bỏ qua
		}
	}
}
