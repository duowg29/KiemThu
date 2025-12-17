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

ExtendedKeywords.safeClickLoginIcon(findTestObject('Object Repository/Page_CamNest/i_Contact_fas fa-user (41)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/label_Or_toggleLabel (6)'))

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Sign Up_txt-signup (2)'), 'phu123@')

WebUI.setText(findTestObject('Object Repository/Page_CamNest/input_Sign Up_email (2)'), '25a4041902@hvnh.edu.vn')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input_Sign Up_signupPassword1 (2)'), '2JzPR/xYVF0ESRcxiJj1+g==')

WebUI.setEncryptedText(findTestObject('Object Repository/Page_CamNest/input__signupPassword2 (2)'), '2JzPR/xYVF0ESRcExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/input__acceptExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CamNest/button_Subscribe for news_signupButton (2)'))e for news_signupButton (2)'))

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Thng bo kim tra Email/a_Vui lng kim tra email  xc nhn ng k_btn-custom'))

WebUI.setText(findTestObject('Object Repository/Page_Gmail/input_to continue to Gmail_identifierId'), '25a4041902@hvnh.edu.vn')

ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Gmail/span_Learn more about using Guest mode_VfPp_231d3e'))

WebUI.setEncryptedText(findTestObject('Object Repository/Page_Welcome/input_Too many failed attempts_Passwd'), 'v79kof+O4jeVZepuujW8Kw==')

WebUI.sendKeys(findTestObject('Object Repository/Page_Welcome/input_Too many failed attempts_Passwd'), Keys.chord(KExtendedKeywords.safeClick(findTestObject('Object Repository/Page_Inbox (16) - 25a4041902hvnh.edu.vn - H_19f46d/div_CAMNEST  Xc nhn ti khon  08 Dec 2025, ExtendedKeywords.safeClick(findTestObject('Object Repository/Page_CAMNEST  Xc nhn ti khon  08 Dec 2025, _7e3502/a_CamNest_m_-3443156591798166017button'))_-3443156591798166017button'))

WebUI.takeScreenshotAsCheckpoint('T12-01')

WebUI.closeBrowser()

