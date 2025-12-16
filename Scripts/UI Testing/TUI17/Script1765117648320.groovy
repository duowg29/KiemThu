import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import static com.kms.katalon.core.testobject.ObjectRepository.findWindowsObject
import com.kms.katalon.core.checkpoint.Checkpoint as Checkpoint
import com.kms.katalon.core.cucumber.keyword.CucumberBuiltinKeywords as CucumberKW
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import com.kms.katalon.core.testcase.TestCase as TestCase
import com.kms.katalon.core.testdata.TestData as TestData
import com.kms.katalon.core.testng.keyword.TestNGBuiltinKeywords as TestNGKW
import com.kms.katalon.core.testobject.TestObject as TestObject
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.windows.keyword.WindowsBuiltinKeywords as Windows
import internal.GlobalVariable as GlobalVariable
import org.openqa.selenium.Keys as Keys

WebUI.openBrowser('')

WebUI.navigateToUrl('http://localhost/CAMNEST/')

WebUI.maximizeWindow()

// Đợi page load hoàn toàn
WebUI.delay(2)

// Đợi element present (tồn tại trong DOM) trước
WebUI.waitForElementPresent(findTestObject('Object Repository/Page_CamNest/a_Camera_active'), 20)

// Đợi element visible và scroll đến element
WebUI.waitForElementVisible(findTestObject('Object Repository/Page_CamNest/a_Camera_active'), 20)
WebUI.scrollToElement(findTestObject('Object Repository/Page_CamNest/a_Camera_active'), 10)

// Thử click bình thường, nếu fail thì dùng JavaScript click
try {
	WebUI.click(findTestObject('Object Repository/Page_CamNest/a_Camera_active'))
} catch (Exception e) {
	// Fallback: Dùng JavaScript click nếu normal click fail
	println "Normal click failed, trying JavaScript click..."
	WebUI.executeJavaScript('arguments[0].click();', [WebUI.findWebElement(findTestObject('Object Repository/Page_CamNest/a_Camera_active'))])
}

WebUI.takeScreenshotAsCheckpoint('home_page')

WebUI.closeBrowser()

