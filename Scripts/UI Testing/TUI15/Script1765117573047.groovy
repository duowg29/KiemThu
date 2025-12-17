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
import com.kms.katalon.keyword.WebUIExtendedKeywords as ExtendedKeywords
import com.kms.katalon.core.windows.keyword.WindowsBuiltinKeywords as Windows
import internal.GlobalVariable as GlobalVariable
import org.openqa.selenium.Keys as Keys

WebUI.openBrowser('')

WebUI.navigateToUrl('http://localhost/CAMNEST/')

WebUI.maximizeWindow()

ExtendedKeywords.safeClickLoginIcon(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (133)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (116)'), 'phu123@')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (116)'), '2JzPR/xYVF0ESRcxiJj1+g==')

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/button_submit (115)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/a (24)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/i_My nh k thut s Sony ZV-E10_far fa-cart-plus cart (6)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest - Camera/i_Contact_fas fa-shopping-cart (7)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/button_Apply_normal (5)'))

// Đợi checkout page load hoàn toàn
WebUI.waitForPageLoad(30)

// Đợi một chút để đảm bảo page đã render đầy đủ
WebUI.delay(2)

WebUI.takeScreenshotAsCheckpoint('cart_page_form')

WebUI.closeBrowser()

