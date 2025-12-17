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

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/a (23)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Contact_txt (75)'), 'admin')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Contact_loginPassword (75)'), 'tzHExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/button_submit (74)'))_submit (74)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Dashboard Manager - CamNest Admin/a_Order_nav-link (11)'))

WebUI.selectOptionByValue(findTestObject('Object Repository/Page_CamNest/select_Template_template_type (5)'), 'Promotional_Custom', ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/div_Performance Analyzer_preview-content'))view-content'))

WebUI.takeScreenshotAsCheckpoint('T41-01')

WebUI.closeBrowser()

